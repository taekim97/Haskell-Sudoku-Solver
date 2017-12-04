var app = angular.module("sudokuApp", []);


app.controller("mainCtrl", function($scope, $http) {
    $scope.gameState = 0;
    $scope.board = [];
    $scope.originalBoard = [];

    $scope.difficultyMenu = function () {
        $scope.gameState = 1;
    }

    $scope.newSolver = function () {
        $scope.gameState = 3;
        $scope.newPuzzle(-1); //Empty Board
    }

    $scope.newPuzzle = function (difficulty) {
        // 0 = easy, 1 = medium, 2 = hard
        if (difficulty > -1 && difficulty < 3) {
            $http({
                method: 'POST',
                url: 'http://localhost:3000/newBoard',
                data: JSON.stringify({
                    difficulty: difficulty
                })
            }).then(function successCB(response) {
                $scope.gameState = 2;
                $scope.board = response.data.board;
                $scope.originalBoard = JSON.parse(JSON.stringify(response.data.board.slice()));;
                console.log($scope.originalBoard);

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
        $scope.board = [];
        $scope.originalBoard = [];
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
        console.log($scope.originalBoard);
        $http({
            method: 'POST',
            url: 'http://localhost:3000/checkBoard',
            data: {
                board: $scope.board
            }
        }).then(function successCB(response) {

            if (response.data.valid) {
                $scope.board = response.data.board;
            }

            console.log("after");
            console.log($scope.originalBoard);
            alert(response.data.valid);

            console.log("Success")

        }, function errorCB (error) {
            console.log(error);
        })

    }

});
