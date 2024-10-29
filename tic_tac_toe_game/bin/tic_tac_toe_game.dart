import 'dart:io';
import 'dart:math';

bool winner = false;
bool IsXTurn = true;
int MoveCount = 0;
bool isComputerOpponent = true;
bool isHardMode = false;

List<String> values = [
  "1", "2", "3", "4", "5", "6", "7", "8", "9",
];
List<String> combinations = [
  "012", "048", "036", "147", "246", "258", "345", "678",
];

void main() {
  chooseGameMode();
  board();
  get_char();
}


// method that choose game mode 
void chooseGameMode() {
  print("Choose Game Mode:");
  print("1. Player X vs Player Y");
  print("2. Player X vs Computer (Easy)");
  print("3. Player X vs Computer (Hard)");
  String? mode = stdin.readLineSync();

  if (mode == '1') {
    isComputerOpponent = false;
  } else if (mode == '2') {
    isComputerOpponent = true;
    isHardMode = false;
  } else if (mode == '3') {
    isComputerOpponent = true;
    isHardMode = true;
  }
}


// method that check combination
bool check_combination(String combination, String player) {
  List<int> numbers = combination.split('').map((item) {
    return int.parse(item);
  }).toList();

  for (final item in numbers) {
    if (values[item] != player) {
      return false;
    }
  }
  return true;
}
// // method that check winner
void check_winner(String player) {
  for (final combination in combinations) {
    if (check_combination(combination, player)) {
      print("$player WON!");
      winner = true;
      ask_for_restart();
      return;
    }
  }
}



void get_char() {
  if (!isComputerOpponent || (isComputerOpponent && IsXTurn)) {
    print("Choose Number For ${IsXTurn ? 'X' : 'O'}");
    int num;
    try {
      num = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print('Invalid input. Please enter a number between 1-9.');
      get_char();
      return;
    }

    if (num < 1 || num > 9 || values[num - 1] == 'X' || values[num - 1] == 'O') {
      print('Invalid move. Try again.');
      get_char();
      return;
    }

    values[num - 1] = IsXTurn ? 'X' : 'O';
  } else {
    if (isHardMode) {
      computerMoveHard();
    } else {
      computerMoveEasy();
    }
  }

  IsXTurn = !IsXTurn;
  MoveCount++;

  board();

  if (MoveCount >= 5) {
    check_winner('X');
    check_winner('O');
  }

  if (MoveCount == 9 && !winner) {
    print('TIE.....');
    winner = true;
    ask_for_restart();
  }

  if (!winner) {
    get_char();
  }
}

void computerMoveEasy() {
  List<int> availableMoves = [];
  for (int i = 0; i < values.length; i++) {
    if (values[i] != 'X' && values[i] != 'O') {
      availableMoves.add(i);
    }
  }

  int move = availableMoves[Random().nextInt(availableMoves.length)];
  values[move] = 'O';
  print("Computer chose position ${move + 1}");
}

void computerMoveHard() {
  int bestScore = -1000;
  int bestMove = -1;

  for (int i = 0; i < 9; i++) {
    if (values[i] != 'X' && values[i] != 'O') {
      // Simulate the move
      values[i] = 'O';
      int score = minimax(0, false);
      // Undo the move
      values[i] = (i + 1).toString();
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  values[bestMove] = 'O';
  print("Computer chose position ${bestMove + 1}");
}

// Minimax Algorithm
int minimax(int depth, bool isMaximizing) {
  // Check for terminal states
  if (check_winner_logic('O')) return 10;
  if (check_winner_logic('X')) return -10;
  if (isDraw()) return 0;

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 9; i++) {
      if (values[i] != 'X' && values[i] != 'O') {
        values[i] = 'O';
        int score = minimax(depth + 1, false);
        values[i] = (i + 1).toString();
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 9; i++) {
      if (values[i] != 'X' && values[i] != 'O') {
        values[i] = 'X';
        int score = minimax(depth + 1, true);
        values[i] = (i + 1).toString();
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}

bool check_winner_logic(String player) {
  for (final combination in combinations) {
    if (check_combination(combination, player)) {
      return true;
    }
  }
  return false;
}

bool isDraw() {
  for (int i = 0; i < 9; i++) {
    if (values[i] != 'X' && values[i] != 'O') {
      return false;
    }
  }
  return true;
}


// the board
void board() {
  print(' ___ ___ ___ ');
  print('|   |   |   |');
  print('| ${values[0]} | ${values[1]} | ${values[2]} |');
  print('|___|___|___|');
  print('|   |   |   |');
  print('| ${values[3]} | ${values[4]} | ${values[5]} |');
  print('|___|___|___|');
  print('|   |   |   |');
  print('| ${values[6]} | ${values[7]} | ${values[8]} |');
  print('|___|___|___|');
}


// to ask player if he want to restart the game
void ask_for_restart() {
  print("Do you want to play again? (yes/no)");
  String? answer = stdin.readLineSync()?.toLowerCase();

  if (answer == 'yes') {
    reset_game();
    main();
  } else {
    print("Thanks for playing!");
    exit(0);
  }
}

void reset_game() {
  winner = false;
  IsXTurn = true;
  MoveCount = 0;
  values = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
}
