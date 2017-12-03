particlesJS.load('particles-js', 'particles.json', function() {
  console.log('callback - particles.js config loaded');
});

var app = angular.module("sudokuApp", []);

app.controller("mainCtrl", function($scope, $http) {
    $scope.gameState = 0;
    $scope.board = [];

    $scope.difficultyMenu = function () {
        $scope.gameState = 1;
    }

    $scope.newPuzzle = function (difficulty) {
        // 0 = easy, 1 = medium, 2 = hard
        if (difficulty == 0) {
            $http({
                method: 'GET',
                url: 'http://localhost:3000/checkBoard'
            }).then(function successCB(response) {
                $scope.gameState = 2;
                $scope.drawNewBoard(response.data);
            }, function errorCB (error) {
                console.log(error);
            })
        }

    }

    $scope.drawNewBoard = function drawNewBoard (data) {
        $scope.board = data.board;
        console.log(data);
        for (let row = 0; row < $scope.board.length; row++) {
            let rowID = 'row' + row;
            $('table.sudoku').append("<tr id='" + rowID + "'></tr>");

            for (let col = 0; col < $scope.board[0].length; col++) {
                let cellID = row + "_" + col;

                if ($scope.board[row][col] == null) {
                    $('tr#' +rowID).append("<td id='" + cellID + "'><input type='text'></tr>");
                } else {
                    $('tr#' +rowID).append("<td id='" + cellID + "'>" + $scope.board[row][col] + "</tr>");
                }
            }
        }

        //return(submitBoard())
    }

});

/*
$(document).ready(function () {
    // Global Variables

    var board = []
    let url = 'http://localhost:3000/checkBoard';


    $.ajax({
        url: url,
        success: drawNewBoard,
        data: null,
        dataType: 'json'
    })
});
*/




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
