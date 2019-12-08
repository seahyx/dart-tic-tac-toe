import 'dart:io';


void main() {

	while(true) {

		// First initialize the board 2d array
		List<List<int>> board = initBoard();

		// Player tracker
		bool isPlayerOne = true;

		// Greeting statement
		print('Tic-tac-toe game! Starting now...');

		// Prints the inital board
		printBoard(board);
		
		// Actual game loop
		while(true) {

			// New round text
			if (isPlayerOne) {
				
				print("Player 1's turn liao. Input your move please.");

			} else {

				print("Player 2's turn already. Faster input your move ah.");

			}
			

			// Input loops, attempts to take in input
			// until a valid input is given

			int x, y;

			// Big loop to check for overall valid move
			while(true) {
				
				// Parse x coordinate
				print('x: ');

				// x coordinate input loop
				while (true) {
					
					// Take in string input and parse it to int
					// int.tryParse will return null if string is not a valid integer
					x = int.tryParse(stdin.readLineSync());

					// If input is not a valid integer (thus unable to parse to int)
					if (x == null) {

						print('Your input got problem. Type a number from 1-3 pls.');
						print('x: ');

						// Loop again since input is not valid integer
						continue;
					}
					
					// Input is an integer, break loop
					break;

				}
				
				// Parse y coordinate
				print('y: ');

				// y coordinate input loop
				while (true) {
					
					// Take in string input and parse it to int
					// int.tryParse will return null if string is not a valid integer
					y = int.tryParse(stdin.readLineSync());

					// If input is not a valid integer (thus unable to parse to int)
					if (y == null) {

						print('Pls input proper number leh. Type a number from 1-3 pls.');
						print('y: ');

						// Loop again since input is not valid integer
						continue;
					}
					
					// Input is an integer, break loop
					break;

				}

				// The coordinate people give usually starts from 1, 2 and 3
				// so we need to subtract one from each number to make sure they
				// fit within our coordinate system
				y--;
				x--;


				// At this point, x and y are valid ints, but may not be valid moves
				// Thus, needs to be checked
				int result = checkMove(board, x, y);
				
				// Move is valid
				// Can't be put in switch case because it needs to break the while loop
				if (result == 0) {
					break;
				}

				// Move is invalid, will loop the input loop
				switch(result) {
					
					// 1 - fail, move is not given/invalid
					case 1:
						print('What number you give sia? Input one more time.');
						break;
					
					// 2 - fail, move is outside the board
					case 2:
						print('Your move is outside the board lah. Input one more time.');
						break;
					
					// 3 - fail, move has already been taken
					case 3:
						print('Move take already liao. Input one more time.');
						break;
					
					// Safety net to handle unexpected result
					default:
						print('Got error. Idk what happen sia. Input one more time.');
						break;
				}

				// End of while loop (input checking loop)
			}


			// At this point, the player's move is valid
			// So, input the move
			inputBoard(board, isPlayerOne, x, y);

			// Change is made to the board, so print it again
			printBoard(board);

			// Check if player won
			bool win = checkWin(board, x, y);

			if (win) {

				// Player won. Congratulations
				if (isPlayerOne) {

					print('Player 1 won! Good job. You get day off.');

				} else {

					print('Player 2 won! Congrats. You get day off.');

				}
				
				// Break game loop
				break;
			}

			// Change player
			isPlayerOne = !isPlayerOne;
			
			// End of a player's turn, loop again till a player wins!
		}

		// Game ended, ask for restart, otherwise exit
		print('Restart? (y/n)');

		String reply = stdin.readLineSync().toLowerCase();

		if (reply == 'n') {
			// Exit window
			exit(0);

		} else {
			// Tbh just take any other reply as 'y'
			print('\n');

		}

		// End of while loop. Restart game!
	}
}

List<List<int>> initBoard() {

	// Initializes the board with a 2d array of 0's
	//
	// Essentially board will look like this:
	// board = [ [0, 0, 0],
	//           [0, 0, 0],
	//           [0, 0, 0] ];

	List<List<int>> b = [
		List.filled(3, 0),
		List.filled(3, 0),
		List.filled(3, 0)];
	
	return b;

}

void printBoard(List<List<int>> b) {

	// Prints board into the console
	//       x
	//   + 0 1 2
	//   0 _ _ _ -> Each line is a list, so this function
	// y 1 _ _ _    iterates through each list (y axis) first,
	//   2 _ _ _    then iterates the individual lists (x axis)

	String playerOneMark = 'X';
	String playerTwoMark = 'O';

	for (int y = b.length - 1; y >= 0; y--) {

		String line = '\n${y + 1}   ';

		for (int x = 0; x < b[y].length; x++) {

			switch(b[y][x]) {

				case 1:
					line += playerOneMark + '   ';
					break;
				
				case 2:
					line += playerTwoMark + '   ';
					break;
				
				// Unmarked
				case 0:
					line += '-   ';
					break;
				
				// Safety net to catch any unexpected value
				default:
					line += '?   ';
					break;

			}

		}

		print(line);
	}

	print('\n+   1   2   3');

	print('\n');
}

int checkMove(List<List<int>> b, int x, int y) {
	
	// Checks if a move is valid
	// Returns an integer upon check complete
	// 0 - success, move is valid
	// 1 - fail, move is not given/invalid
	// 2 - fail, move is outside the board
	// 3 - fail, move has already been taken

	if (x == null || y == null) {
		return 1;
	}

	if (y < 0 || y > b.length) {
		return 2;
	}

	if (x < 0 || x > b[0].length) {
		return 2;
	}

	if (b[y][x] != 0) {
		return 3;
	}

	return 0;
}

List<List<int>> inputBoard(List<List<int>> b, bool isPlayerOne, int x, int y) {

	// Takes in a coordinate for a move and applies to the board
	// Assumes that the move given is already valid
	// Player 1 represented by number 1
	// Player 2 represented by number 2

	b[y][x] = isPlayerOne ? 1 : 2;

	return b;
}

bool checkWin(List<List<int>> b, int x, int y) {
	
	// Check if the last move is a winning move
	// Branch out from the move and check if there are 3 markings in a row
	// There are 4 directions to go in:
	// 1. Horizontal
	// 2. Vertical
	// 3. Diagonal up to down
	// 4. Diagonal down to up

	// Board reference
	//       x
	//   + 0 1 2
	//   0 _ _ _ 
	// y 1 _ _ _
	//   2 _ _ _

	// First, obtain the mark on the current move
	int mark = b[y][x];

	// 1. Check horizontal

	//       x
	//   + 0 1 2
	//   0 _ _ _ 
	// y 1 X X X
	//   2 _ _ _

	bool win = true;

	for (int xCheck = 0; xCheck < b[y].length; xCheck++) {
		if (b[y][xCheck] != mark) {
			win = false;
			break;
		}
	}

	if (win) return true;


	// 2. Check vertical

	//       x
	//   + 0 1 2
	//   0 _ X _ 
	// y 1 _ X _
	//   2 _ X _

	win = true;

	for (int yCheck = 0; yCheck < b.length; yCheck++) {
		if (b[yCheck][x] != mark) {
			win = false;
			break;
		}
	}

	if (win) return true;

	// 3. Check diagonal up to down

	//       x
	//   + 0 1 2
	//   0 X _ _ 
	// y 1 _ X _
	//   2 _ _ X

	win = true;

	for (int xyCheck = 0; xyCheck < b.length; xyCheck++) {
		if (b[xyCheck][xyCheck] != mark) {
			win = false;
		}
	}

	if (win) return true;

	// 4. Check diagonal down to up

	//       x
	//   + 0 1 2
	//   0 _ _ X 
	// y 1 _ X _
	//   2 X _ _

	win = true;

	for (int xyCheck = 0; xyCheck < b.length; xyCheck++) {
		if (b[(b.length - 1) - xyCheck][xyCheck] != mark) {
			win = false;
		}
	}

	if (win) return true;

	return false;
}