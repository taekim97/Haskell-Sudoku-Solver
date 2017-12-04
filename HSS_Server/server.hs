{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards          #-}
import           Yesod
import           Data.Text (Text)
import           Data.Aeson
import           qualified Data.ByteString.Lazy as B
import Debug.Trace
import System.Random
import Sudoku
import System.Random (randomRIO)
import System.IO.Unsafe

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR POST
/checkBoard CheckR POST
/solveBoard SolveBoardR POST
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



getRandNum :: Int
getRandNum =  unsafePerformIO $ do
    x <- randomRIO (1,3)
    return x

chooseBoard :: Difficulty -> [Char]
chooseBoard (Difficulty d) =
    if (d == 0) then
        "boards/easy/" ++ (show getRandNum) ++ ".json"
    else if (d == 1) then
        "boards/med/" ++ (show getRandNum) ++ ".json"
    else if (d == 2) then
        "boards/hard/" ++ (show getRandNum) ++ ".json"
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


-- Returns this board solved, if unsolvable it returns the original board
postSolveBoardR :: Handler Value
postSolveBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    --d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))
    board <- requireJsonBody :: Handler Board
    returnJson $ solveBoard $ board

-- Checks if board is valid
postCheckR :: Handler Value
postCheckR = do
    addHeader "Access-Control-Allow-Origin" "*"
    --d <- liftIO ( (eitherDecode <$> getJSON "/board/easy/1.json") :: IO (Either String Board))
    board <- requireJsonBody :: Handler Board
    let Board b v = board in returnJson $ Board b $ Just $ isValid b







main :: IO ()
main = warp 3000 HelloWorld
