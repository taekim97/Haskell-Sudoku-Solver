{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards          #-}
import           Yesod
import           Data.Text (Text)
import           Data.Aeson
import           qualified Data.ByteString.Lazy as B

data HelloWorld = HelloWorld
data Board = Board
    { board :: [[Maybe Int]],
      valid :: Maybe Bool
    } deriving (Show)

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR GET

|]

instance Yesod HelloWorld

instance ToJSON Board where
    toJSON Board {..} = object
        [ "board" .= board,
          "valid" .= valid
        ]

instance FromJSON Board where
    parseJSON (Object v) =
        Board <$> v .: "board"
              <*> v .:? "valid"

jsonFile :: FilePath
jsonFile = "sampleBoard.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]



-- Generates a new board and returns a JSON representation of the board
getBoardR :: Handler Value
getBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))

    case d of
        Left _ -> returnJson $ Board[[Just 2, Just 3, Just 4],[Just 5, Just 6, Just 7]] (Just True)
        Right ps -> returnJson $ ps


main :: IO ()
main = warp 3000 HelloWorld
