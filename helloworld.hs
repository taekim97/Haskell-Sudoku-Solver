{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards          #-}
import           Yesod
import           Data.Text (Text)

data HelloWorld = HelloWorld
data Board = Board
    { board :: [[Int]],
      validNum :: Bool
    }

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/newBoard BoardR GET
|]

instance Yesod HelloWorld
instance ToJSON Board where
    toJSON Board {..} = object
        [ "board" .= board,
          "validNum" .= validNum
        ]

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello World!|]

getBoardR :: Handler Value
getBoardR = returnJson $ Board[[2,3,4],[5,6,7]] True

main :: IO ()
main = warp 3000 HelloWorld
