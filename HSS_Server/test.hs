-- tests the validator and solver functions
{-# LANGUAGE StandaloneDeriving #-}
import System.Environment
import Data.Monoid
import Debug.Trace

import Sudoku

duplicateInRow :: Board
duplicateInRow = Board [[Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Just 1],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Just 3, Nothing, Nothing, Just 3, Nothing, Just 5, Nothing, Just 4, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Just 2, Nothing, Nothing, Nothing, Just 2, Nothing, Nothing, Nothing, Nothing],[Nothing, Just 7, Nothing, Just 6, Nothing, Nothing, Nothing, Just 6, Nothing],[Nothing, Nothing, Just 8, Nothing, Nothing, Just 8, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Just 4, Nothing, Nothing,  Nothing, Just 4, Nothing],[Nothing, Just 9, Nothing, Nothing, Nothing, Nothing, Nothing, Just 9, Nothing]] (Just False)


duplicateInCol :: Board
duplicateInCol = Board [[Just 1, Just 2, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Just 2, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just False)

duplicateInCell :: Board
duplicateInCell = Board [[Just 1, Nothing , Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Just 2, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Just 1, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just False)

solvedBoard :: Board
solvedBoard = Board [[Just 1,Just 2,Just 3,Just 4,Just 5,Just 6,Just 7,Just 8,Just 9],[Just 4,Just 5,Just 6,Just 7,Just 8,Just 9,Just 1,Just 2,Just 3],[Just 7,Just 8,Just 9,Just 1,Just 2,Just 3,Just 4,Just 5,Just 6],[Just 2,Just 1,Just 4,Just 3,Just 6,Just 5,Just 8,Just 9,Just 7],[Just 3,Just 6,Just 5,Just 8,Just 9,Just 7,Just 2,Just 1,Just 4],[Just 8,Just 9,Just 7,Just 2,Just 1,Just 4,Just 3,Just 6,Just 5],[Just 5,Just 3,Just 1,Just 6,Just 4,Just 2,Just 9,Just 7,Just 8],[Just 6,Just 4,Just 2,Just 9,Just 7,Just 8,Just 5,Just 3,Just 1],[Just 9,Just 7,Just 8,Just 5,Just 3,Just 1,Just 6,Just 4,Just 2]] (Just True)

solvableBoard :: Board
solvableBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just True)

unsolvableBoard :: Board
unsolvableBoard = Board [[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Just 9, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing],[Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing]] (Just True)


--Tests if validator can reject based on rows
checkRowsTest :: Bool
checkRowsTest =
    let Board b v = duplicateInRow in
        isValid(b) == False

--Tests if validator can judge based on cols
checkColsTest :: Bool
checkColsTest =
    let Board b v = duplicateInCol in
        isValid(b) == False

--Tests if validator can judge based on cells
checkCellsTest :: Bool
checkCellsTest =
    let Board b v = duplicateInCell in
        isValid(b) == False

--Tests if validator can judge a correct board
checkSolvedBoardTest :: Bool
checkSolvedBoardTest =
    let Board b v = solvedBoard in
        isValid(b) == True

--Tests if solver can solve a normal sudoku board
--should return the board solved, and the valid flag should be true
solvePossibleTest :: Bool
solvePossibleTest=
    let Board validB v = solvedBoard in
    let Board resultB (Just resBool) = solveBoard solvableBoard in
        validB == resultB && resBool

--"Makes the impossible, possible!"
--Tests if the solver recognizes when a board is unsolvable
--in this case, it should return the original board, and set the valid flag to false
solveImpossibleTest :: Bool
solveImpossibleTest =
    let Board invalidB v = unsolvableBoard in
    let Board resultB (Just resBool) = solveBoard unsolvableBoard in
        invalidB == resultB && not resBool

unitTests = [
  ("checkRows", checkRowsTest),
  ("checkCols", checkColsTest),
  ("checkCells", checkCellsTest),
  ("checkSolvedBoard", checkSolvedBoardTest),
  ("solvePossible", solvePossibleTest),
  ("solveImpossible", solveImpossibleTest)
  ]

runTests :: String -> IO ()
runTests func =
  case (lookup func unitTests) of
    Just t -> if t then putStrLn $ "Passed " ++ func
              else error $ "Failed " ++ func
    Nothing -> error $ "Unrecognized test: " ++ func

main = do
  args <- getArgs
  let func = head args in
    runTests func
