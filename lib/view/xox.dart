import 'package:flutter/material.dart';

class XoxGameScreen extends StatefulWidget {
  const XoxGameScreen({Key? key}) : super(key: key);

  @override
  State<XoxGameScreen> createState() => _XoxGameScreenState();
}

class _XoxGameScreenState extends State<XoxGameScreen> {
  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  late List<String> board;
  late String currentPlayer;
  late String winner;
  late bool isTie;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
      isTie = false;
    });
  }

  void makeMove(int index) {
    if (winner.isNotEmpty || board[index].isNotEmpty) return;

    setState(() {
      board[index] = currentPlayer;
      currentPlayer = (currentPlayer == "X") ? "O" : "X";
      checkGameStatus();
    });
  }

  void checkGameStatus() {
    for (var line in winningLines) {
      if (board[line[0]].isNotEmpty &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        winner = board[line[0]];
        return;
      }
    }

    if (!board.contains("")) {
      isTie = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPlayerIndicators(),
          const SizedBox(height: 20),
          _buildGameStatus(),
          _buildGameBoard(),
          if (winner.isNotEmpty || isTie) _buildPlayAgainButton(),
        ],
      ),
    );
  }

  Widget _buildPlayerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPlayerIndicator("BOT 1", "X", currentPlayer == "X"),
        _buildPlayerIndicator("BOT 2", "O", currentPlayer == "O"),
      ],
    );
  }

  Widget _buildPlayerIndicator(String name, String symbol, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? Colors.amber : Colors.transparent,
        ),
        boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 3)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person, color: Colors.white, size: 55),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              symbol,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStatus() {
    if (winner.isNotEmpty) {
      return Text(
        "$winner Won",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (isTie) {
      return const Text(
        "It's a Tie!",
        style: TextStyle(
          fontSize: 30,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildGameBoard() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 9,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => _buildGridItem(index),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    return GestureDetector(
      onTap: () => makeMove(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            board[index],
            style: const TextStyle(fontSize: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayAgainButton() {
    return ElevatedButton(
      onPressed: resetGame,
      child: const Text("Play Again"),
    );
  }
}
