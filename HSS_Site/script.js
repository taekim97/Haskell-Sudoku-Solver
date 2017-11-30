
$(document).ready(function () {
    // Global Variables
    var gameState = 0; // 0 = Menu, 1 = Solver

    var board = []
    let url = 'http://localhost:3000/checkBoard';


    $.ajax({
        url: url,
        success: drawNewBoard,
        data: null,
        dataType: 'json'
    })




});
//



function drawNewBoard (data) {
    board = data.board;
    console.log(data);
    for (let row = 0; row < board.length; row++) {
        let rowID = 'row' + row;
        $('table.sudoku').append("<tr id='" + rowID + "'></tr>");

        for (let col = 0; col < board[0].length; col++) {
            let cellID = row + "_" + col;

            if (board[row][col] == null) {
                $('tr#' +rowID).append("<td id='" + cellID + "'><input type='text'></tr>");
            } else {
                $('tr#' +rowID).append("<td id='" + cellID + "'>" + board[row][col] + "</tr>");
            }
        }
    }

    //return(submitBoard())
}



function submitBoard(){
    //extract numbers from the table
    //if not a number, stop, alert
    //once done, pass to get request call back
    //if successful, then toast "Correct!" or similar

    sudokuEntries = {'board':[]};
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
