var app = angular.module("sudokuApp", []);


app.controller("mainCtrl", function($scope, $http) {
    $scope.gameState = 0;
    $scope.board = [];

    $scope.difficultyMenu = function () {
        $scope.gameState = 1;
    }

    $scope.newSolver = function () {
        $scope.gameState = 3;
        $scope.newPuzzle(-1); //Empty Board
    }

    $scope.newPuzzle = function (difficulty) {
        // 0 = easy, 1 = medium, 2 = hard
        if (difficulty == 0) {
            $http({
                method: 'POST',
                url: 'http://localhost:3000/newBoard',
                data: JSON.stringify({
                    difficulty: difficulty
                })
            }).then(function successCB(response) {
                $scope.gameState = 2;
                $scope.board = response.data.board;

            }, function errorCB (error) {
                console.log(error);
            })
        } else {
            $scope.board = new Array(9);
            for (let row = 0; row < 9; row++) {
                let tempAry = new Array(9);
                $scope.board[row] = tempAry;

            }
        }

    }

    $scope.backState = function () {
        $scope.gameState = 0;
    }

    $scope.solve = function () {

        $http({
            method: 'POST',
            url: 'http://localhost:3000/solveBoard',
            data: {
                board: $scope.board
            }
        }).then(function successCB(response) {

            $scope.board = response.data.board;

            console.log("Success")

        }, function errorCB (error) {
            console.log(error);
        })
    }

    $scope.validate = function () {
        $http({
            method: 'POST',
            url: 'http://localhost:3000/checkBoard',
            data: {
                board: $scope.board
            }
        }).then(function successCB(response) {

            $scope.board = response.data.board;
            alert(response.data.valid);

            console.log("Success")

        }, function errorCB (error) {
            console.log(error);
        })

    }

});



function submitBoard(){
    //extract numbers from the table
    //if not a number, stop, alert
    //once done, pass to get request call back
    //if successful, then toast "Correct!" or similar

    sudokuEntries = {'board':[], 'valid': false};
    board = []

    for (let row = 0; row < 9; row++) {
        entryRow = []
        for (let col = 0; col < 9; col++) {
            let cellId = row + "_" + col;
            let entry = $("tr #" + cellId);

            if(entry.children().length > 0 ){
                let inputVal = $("tr #" + cellId + " input").val();
                if(inputVal === ""){
                    //alert("please fill out the board");
                } else if (!(/^\d+$/.test(inputVal)) ){
                    alert("Only numbers please :)");
                    return;
                } else {
                    entryRow.push(inputVal);
                }

            } else {
                entryRow.push(entry.text());
            }
        }

        board.push(entryRow);
    }

    sudokuEntries['board'] = board

}

function submissionResults(board){
    //if true, then alert "Congrats!", otherwise, alert "try again!"
}
