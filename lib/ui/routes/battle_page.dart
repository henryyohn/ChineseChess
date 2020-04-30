import 'package:chinesechess/ui/board/chess_board.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  // 棋盘的纵横方向的边距
  static const boardMarginV = 10.0, borderMarginH = 10.0;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - borderMarginH * 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Battle'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: ChessBoard(width: boardHeight),
      ),
    );
  }
}
