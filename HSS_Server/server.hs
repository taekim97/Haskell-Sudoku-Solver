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

emptyBoard :: Board
emptyBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just True)

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR GET
/checkBoard CheckR GET

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
jsonFile = "sampleBoard.json"

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

-- Checks if board is valid
getCheckR :: Handler Value
getCheckR = do
    addHeader "Access-Control-Allow-Origin" "*"
    d <- liftIO ( (eitherDecode <$> getJSON) :: IO (Either String Board))

    case d of
        Left _ -> returnJson $ emptyBoard
        Right (Board b v) -> returnJson $ Board b $ Just $ isValid b

isValid :: [[Maybe Int]] -> Bool
isValid b =

    -- Check rows and columns
    checkRows b 9 && checkCols b 9 && checkCells b 9 9




-- Check Rows
checkRows :: [[Maybe Int]] -> Int -> Bool
checkRows _ 0 = True
checkRows b n =
    if checkRow (b!!(n - 1)) [0,0,0,0,0,0,0,0,0] then
        checkRows b (n-1)
    else
        False

checkRow :: [Maybe Int] -> [Int] -> Bool
checkRow [] _ = True
checkRow (x:xs) visited = do
    case x of
        Just n ->
            if n > 9 || n < 1 then
                False
            else if visited!!(n - 1) /= 0 then
                False
            else
                checkRow xs (take (n - 1) visited ++ [1] ++ drop n visited)
        Nothing -> checkRow xs visited

-- Check Columns
checkCols :: [[Maybe Int]] -> Int -> Bool
checkCols _ 0 = True
checkCols b n =
    if checkCol b [0,0,0,0,0,0,0,0,0] (n - 1) then
        checkCols b (n-1)
    else
        False

checkCol :: [[Maybe Int]] -> [Int] -> Int -> Bool
checkCol [] _ _ = True
checkCol (x:xs) visited i = do

    case x!!i of
        Just n ->
            if n > 9 || n < 1 then
                False
            else if visited!!(n - 1) /= 0 then
                False
            else
                checkCol xs (take (n - 1) visited ++ [1] ++ drop n visited) i
        Nothing -> checkCol xs visited i

-- Check Cells
checkCells :: [[Maybe Int]] -> Int -> Int -> Bool
checkCells _ 0 _ = True
checkCells _ _ 0 = True
checkCells b r c =
    if checkCell b [0,0,0,0,0,0,0,0,0] r 0 c 0 then
        checkCells b (r - 3) c && checkCells b r (c - 3)
    else False

checkCell :: [[Maybe Int]] -> [Int] -> Int -> Int ->  Int -> Int -> Bool
checkCell _ _ r 3 c 3 = True
checkCell b v r rl c 3 = checkCell b v (r - 1) rl c 0
checkCell b v r rl c cl =
    case b!!(r - 1 - rl)!!(c - 1 - cl) of
        Just n ->
            if n > 9 || n < 1 then
                False
            else if v!!(n - 1) /= 0 then
                False
            else
                checkCell b (take (n - 1) v ++ [1] ++ drop n v) r rl c (cl + 1)
        Nothing -> checkCell b v r rl c (cl + 1)


main :: IO ()
main = warp 3000 HelloWorld
