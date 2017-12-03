-- tests the validator and solver functions
emptyBoard :: Board
emptyBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just False)



duplicateInRow :: Board
duplicateInRow = Board [[Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Just 1],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Just 3, Nothing, Nothing, Just 3, Nothing, Just 5, Nothing, Just 4, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Just 2, Nothing, Nothing, Nothing, Just 2, Nothing, Nothing, Nothing, Nothing],
[Nothing, Just 7, Nothing, Just 6, Nothing, Nothing, Nothing, Just 6, Nothing],
[Nothing, Nothing, Just 8, Nothing, Nothing, Just 8, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Just 4, Nothing, Nothing,  Nothing, Just 4, Nothing],
[Nothing, Just 9, Nothing, Nothing, Nothing, Nothing, Nothing, Just 9, Nothing]] (Just False)


duplicateInCol :: Board
duplicateInCol = Board [[Just 1, Just 2, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Just 2, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just False)

solvedBoard :: Board
sovledBoard = Board [[Just 1,Just 2,Just 3,Just 4,Just 5,Just 6,Just 7,Just 8,Just 9],
[Just 4,Just 5,Just 6,Just 7,Just 8,Just 9,Just 1,Just 2,Just 3],
[Just 7,Just 8,Just 9,Just 1,Just 2,Just 3,Just 4,Just 5,Just 6],
[Just 2,Just 1,Just 4,Just 3,Just 6,Just 5,Just 8,Just 9,Just 7],[
Just 3,Just 6,Just 5,Just 8,Just 9,Just 7,Just 2,Just 1,Just 4],[Just 8,Just 9,Just 7,Just 2,Just 1,Just 4,Just 3,Just 6,Just 5],[Just 5,Just 3,Just 1,Just 6,Just 4,Just 2,Just 9,Just 7,Just 8],[Just 6,Just 4,Just 2,Just 9,Just 7,Just 8,Just 5,Just 3,Just 1],[Just 9,Just 7,Just 8,Just 5,Just 3,Just 1,Just 6,Just 4,Just 2]] (Just True)

solvableBoard :: Board
solvableBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just True)

solvableBoard :: Board
solvableBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],
[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just True)

unitTests = [
  ("checkRows", checkRowsTest),
  ("checkCols", checkColsTest),
  ("checkCells", checkCellsTest),
  ("solvePossible", solvePossibleTest),
  ("solveImpossible", solveImpossibleTest)
  ]

runPublicTests :: String -> IO ()
runPublicTests func =
  case (lookup func publicTests) of
    Just t -> if t then putStrLn $ "Passed " ++ func
              else error $ "Failed " ++ func
    Nothing -> error $ "Unrecognized test: " ++ func

main = do
  args <- getArgs
  let func = head args in
    if ("public" `isPrefixOf` func) then runPublicTests func
    else error $ "No prefix \"public\" in " ++ func
