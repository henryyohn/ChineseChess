import 'package:chinesechess/game/battle.dart';
import 'package:chinesechess/ui/board/chess_board.dart';
import 'package:chinesechess/ui/cchess/cc_base.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  // 棋盘的纵横方向的边距
  static const boardMarginV = 10.0, borderMarginH = 10.0;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  @override
  void initState() {
    super.initState();
    // 使用默认的「新对局」棋子分布
    Battle.shared.init();
  }

  // 由 BattlePage 的 State 类来处理棋盘的点击事件
  onBoardTap(BuildContext context, int index) {
    //
    print('board cross index: $index');
    //
    final phase = Battle.shared.phase;

    // 仅 Phase 中的 side 指示一方能动棋
    if (phase.side != Side.Red) return;

    final tapedPiece = phase.pieceAt(index);

    // 之前已经有棋子被选中了
    if (Battle.shared.focusIndex != -1 && Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      //
      // 当前点击的棋子和之前已经选择的是同一个位置
      if (Battle.shared.focusIndex == index) return;

      // 之前已经选择的棋子和现在点击的棋子是同一边的，说明是选择另外一个棋子
      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tapedPiece)) {
        //
        Battle.shared.select(index);
        //
      } else if (Battle.shared.move(Battle.shared.focusIndex, index)) {
        // 现在点击的棋子和上一次选择棋子不同边，要么是吃子，要么是移动棋子到空白处
        // todo: scan game result
      }
      //
    } else {
      // 之前未选择棋子，现在点击就是选择棋子
      if (tapedPiece != Piece.Empty) Battle.shared.select(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BattlePage.borderMarginH * 2;

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
        child: ChessBoard(width: boardHeight, onBoardTap: onBoardTap),
      ),
    );
  }
}
