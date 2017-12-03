-- tests the validator and solver functions
import testData
import server

checkRowsTest :: Bool
checkRowsTest =
    let Board b v = duplicateInRow in
        isValid(b) == False

unitTests = [
  ("checkRows", checkRowsTest)]
 -- ("checkCols", checkColsTest),
  --("checkCells", checkCellsTest),
 -- ("checkSolvedBoard", checkSolvedBoardTest)
 -- ("solvePossible", solvePossibleTest),
 -- ("solveImpossible", solveImpossibleTest)
  --]

runTests :: String -> IO ()
runTests func =
  case (lookup func unitTests) of
    Just t -> if t then putStrLn $ "Passed " ++ func
              else error $ "Failed " ++ func
    Nothing -> error $ "Unrecognized test: " ++ func

main = do
  args <- getArgs
  let func = head args in
    if ("public" `isPrefixOf` func) then runTests func
    else error $ "No prefix \"public\" in " ++ func
