{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards          #-}
import           Yesod
import           Data.Text (Text)
import           Data.Aeson
import           qualified Data.ByteString.Lazy as B
import           Sudoku
<<<<<<< HEAD
import           System.Random
=======
import           System.Random (randomR, newStdGen)
>>>>>>> ec762e512cc6dd7505450875c8e9d01937f1bc8e
import           System.IO.Unsafe
import           Control.Applicative



staticFiles "../HSS_Site"

data HelloWorld = HelloWorld
    { getStatic :: Static
    }


mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/static StaticR Static getStatic
/newBoard BoardR POST OPTIONS
/checkBoard CheckR POST OPTIONS
/solveBoard SolveBoardR POST OPTIONS
|]


instance Yesod HelloWorld

data Difficulty = Difficulty
    { difficulty :: Int }  deriving (Show)


-- Parsing Functions
instance ToJSON Board where
    toJSON Board {..} = object
        [ "board" .= board,
          "valid" .= valid
        ]

instance FromJSON Board where
    parseJSON (Object v) =
        Board <$> v .: "board"
              <*> v .:? "valid"


instance FromJSON Difficulty where
  parseJSON (Object v) =
      Difficulty <$> v .: "difficulty"


jsonFile ::  [Char] -> FilePath
jsonFile s = s

getJSON :: [Char] -> IO B.ByteString
getJSON filePath = B.readFile $ jsonFile filePath




-- Welcome Page
getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]
    --app <- getYesod
    --let indexPath = getRootDir app <$> "index.html"
    --sendFile "text/html" indexPath



getRandNum :: IO Int
getRandNum = do
    g <- newStdGen
    let (x,r) = randomR(1,6) g
    return x

chooseBoard :: Difficulty -> [Char]
chooseBoard (Difficulty d) =
    let rand = unsafePerformIO $ getRandNum in
    if (d == 0) then
        "boards/easy/" ++ (show rand) ++ ".json"
    else if (d == 1) then
        "boards/med/" ++ (show rand) ++ ".json"
    else if (d == 2) then
        "boards/hard/" ++ (show rand) ++ ".json"
    else
        error "invalid Difficulty"

-- Generates a new board (easy, medium, or hard) and returns a new JSON representation of that board
postBoardR :: Handler Value
postBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    diff <- requireJsonBody :: Handler Difficulty
    d <- liftIO ( (eitherDecode <$> getJSON (chooseBoard diff)) :: IO (Either String Board))

    case d of
        Left _ -> returnJson $ emptyBoard
        Right ps -> returnJson $ ps

optionsBoardR :: Handler RepPlain
optionsBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    addHeader "Access-Control-Allow-Methods" "PUT, OPTIONS"
    addHeader "Access-Control-Allow-Headers" "Origin, X-Requested-With, Content-Type, Accept"
    return $ RepPlain $ toContent ("" :: Text)


-- Returns this board solved, if unsolvable it returns the original board
postSolveBoardR :: Handler Value
postSolveBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    board <- requireJsonBody :: Handler Board
    returnJson $ solveBoard $ board

optionsSolveBoardR :: Handler RepPlain
optionsSolveBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    addHeader "Access-Control-Allow-Methods" "PUT, OPTIONS"
    addHeader "Access-Control-Allow-Headers" "Origin, X-Requested-With, Content-Type, Accept"
    return $ RepPlain $ toContent ("" :: Text)

-- Checks if board is valid
postCheckR :: Handler Value
postCheckR = do
    addHeader "Access-Control-Allow-Origin" "*"
    --d <- liftIO ( (eitherDecode <$> getJSON "/board/easy/1.json") :: IO (Either String Board))
    board <- requireJsonBody :: Handler Board
    let Board b v = board in returnJson $ Board b $ Just $ isValid b

optionsCheckR :: Handler RepPlain
optionsCheckR = do
    addHeader "Access-Control-Allow-Origin" "*"
    addHeader "Access-Control-Allow-Methods" "PUT, OPTIONS"
    addHeader "Access-Control-Allow-Headers" "Origin, X-Requested-With, Content-Type, Accept"
    return $ RepPlain $ toContent ("" :: Text)


main :: IO ()
main = do
    static@(Static settings) <- static "../HSS_Site"
    warp 3000 $ HelloWorld static
