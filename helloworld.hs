{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import           Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]

type Board = [[Int]]



-- takes board,  and updates row and col with the value
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
