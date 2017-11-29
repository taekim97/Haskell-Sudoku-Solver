$(document).ready(function () {

    var board = [];
    let url = 'http://localhost:3000/newBoard';


    $.ajax({
        url: url,
        success: drawNewBoard,
        data: null,
        dataType: 'json'
    })


});

function drawNewBoard (data) {
    board = data.board;

    for (let row = 0; row < board.length; row++) {
        let rowID = 'row' + row;
        $('table.sudoku').append("<tr id='" + rowID + "'></tr>");

        for (let col = 0; col < board[0].length; col++) {
            let cellID = row + ',' + col;

            if (board[row][col] == null) {
                $('tr#' +rowID).append("<td id='" + cellID + "'></tr>");
            } else {
                $('tr#' +rowID).append("<td id='" + cellID + "'>" + board[row][col] + "</tr>");
            }
        }
    }
}
