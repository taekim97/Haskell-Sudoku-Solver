{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards          #-}
import           Yesod
import           Data.Text (Text)

data HelloWorld = HelloWorld
data Board = Board
    { board :: [[Maybe Int]],
      valid :: Bool
    }

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR GET
/updateBoard updateBoardR POST
|]

instance Yesod HelloWorld

instance ToJSON Board where
    toJSON Board {..} = object
        [ "board" .= board,
          "valid" .= valid
        ]

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]

type Board = [[Int]]

getBoardR :: Handler Value
getBoardR = returnJson $ Board[[Just 2, Just 3, Just 4],[Just 5, Just 6, Just 7]] (Just True)



updateBoardR :: Handler Value
updateBoardR  = do
    ((result, widget), enctype) <-


-- takes board,  and updates row and col with the value
getValue :: Board -> Int -> Int -> Int
getValue m row col = m!!row!!col

updateBoard :: Board -> (Int, Int) -> Int -> Board
updateBoard m (row, col) value = [ [if (y,x) == (row, col) then value else (getValue m y x) | x <- [0..9]]  | y <- [0..9]]

--relatively important function here
validBoard :: Board -> Bool
validBoard m = True



main :: IO ()
main = warp 3000 HelloWorld
