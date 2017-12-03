module TestHelper
( emptyBoard
, duplicateInRow
, duplicateInCol
, duplicateInCell
, solvedBoard
, solvableBoard
, unsolvableBoard
) where

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
