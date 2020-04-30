import 'package:chinesechess/common/colors_const.dart';
import 'package:chinesechess/game/battle.dart';
import 'package:chinesechess/ui/board/board_painter.dart';
import 'package:chinesechess/ui/board/pieces_painter.dart';
import 'package:chinesechess/ui/board/words_on_board.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatelessWidget {
  // 棋盘内边界 + 棋盘上的路数指定文字高度
  static const Padding = 5.0, DigitsHeight = 36.0;

  // 棋盘的宽高
  final double width, height;

  // 棋盘的点击事件回调，由 board widget 的创建者传入
  final Function(BuildContext, int) onBoardTap;

  ChessBoard({@required this.width, @required this.onBoardTap}) : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

//  ChessBoard({@required this.width}) : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorsConst.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width),
        foregroundPainter: PiecesPainter(width: width, phase: Battle.shared.phase, focusIndex: Battle.shared.focusIndex, blurIndex: Battle.shared.blurIndex),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Padding,
            horizontal: (width - Padding * 2) / 9 / 2 + Padding - WordsOnBoard.DigitsFontSize / 2,
          ),
          child: WordsOnBoard(),
        ),
      ),
    );
// 用 GestureDetector 组件包裹我们的 board 组件，用于检测 board 上的点击事件
    return GestureDetector(
      child: boardContainer,
      onTapUp: (d) {
        // 网格的总宽度
        final gridWidth = (width - Padding * 2) * 8 / 9;
        // 每个格式的边长
        final squareSide = gridWidth / 8;

        final dx = d.localPosition.dx, dy = d.localPosition.dy;

        // 棋盘上的行、列转换
        final row = (dy - Padding - DigitsHeight) ~/ squareSide;
        final column = (dx - Padding) ~/ squareSide;

        if (row < 0 || row > 9) return;
        if (column < 0 || column > 8) return;

        print('row: $row, column: $column');
        // 回调
        onBoardTap(context, row * 9 + column);
      },
    );
  }
}
