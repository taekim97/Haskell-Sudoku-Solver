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
-- Board -> Row -> Col -> Bool
checkCells :: [[Maybe Int]] -> Int -> Int -> Bool
checkCells _ 0 _ = True
checkCells b r 0 = checkCells b (r - 3) 9
checkCells b r c =
    if checkCell b [0,0,0,0,0,0,0,0,0] r 0 c 0 then
        checkCells b r (c - 3)
    else False

checkCell :: [[Maybe Int]] -> [Int] -> Int -> Int ->  Int -> Int -> Bool
checkCell _ _ _ 3 _ _ = True
checkCell b v r rl c 3 = checkCell b v r (rl + 1) c 0
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

-- solves the board, using a dfs
-- for each entry
-- if it has a value, go to the next entry
-- if it is nothing, try every value, from 1 to 9
-- if one of these values works, commit to it and go

solveBoard :: [[Maybe Int]]-> Int -> Int -> Board
solveBoard board 9 0 = Board board (Just True)
solveBoard board row 9 =  solveBoard board (row+1) 0
solveBoard board row col | not $ isValid board = error "passed in invalid board"
solveBoard board row col | isValid board =

     case board!!row!!col of
        Just n -> solveBoard board row (col+1)
        Nothing ->

            case setValue board row col 1 of
                [[]] -> Board board (Just False)
                b -> Board b (Just True)




--tries different values from 1 to 9
-- chooses the first one that solves the entire board lol
setValue :: [[Maybe Int]] -> Int -> Int -> Int -> [[Maybe Int]]
setValue board row col 10 = [[]]
setValue board row col val =
    let  rowToAdd = board!!row in

        let r = (take col rowToAdd ++ [Just val] ++ drop (col+1) rowToAdd) in
        let b = (take row board ++ [r] ++ drop (row+1) board) in


        if((isValid b)) then

            case solveBoard b row col of
                Board newB (Just True) -> newB
                Board _ (Just False) -> setValue board row col (val+1)
        else
            setValue board row col (val+1)











main :: IO ()
main = warp 3000 HelloWorld
