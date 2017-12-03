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

import Sudoku

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR GET
/checkBoard CheckR GET
/solveBoard SolveBoardR POST
|]

instance Yesod HelloWorld


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

jsonFile :: FilePath
jsonFile = "boards/easy/1.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile


-- Welcome Page
getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]


-- Generates a new board and returns a JSON representation of the board
getBoardR :: Handler Value
getBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))

    case d of
        Left _ -> returnJson $ emptyBoard
        Right ps -> returnJson $ ps


-- Returns this board solved, if unsolvale it returns the original board
postSolveBoardR :: Handler Value
postSolveBoardR = do
    addHeader "Access-Control-Allow-Origin" "*"
    --d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))
    board <- requireJsonBody :: Handler Board
    returnJson $ solveBoard $ board

-- Checks if board is valid
getCheckR :: Handler Value
getCheckR = do
    addHeader "Access-Control-Allow-Origin" "*"
    d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))

    case d of
        Left _ -> returnJson $ emptyBoard
        Right (Board b v) -> returnJson $ Board b $ Just $ isValid b





main :: IO ()
main = warp 3000 HelloWorld
