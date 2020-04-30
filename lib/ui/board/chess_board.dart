import 'package:chinesechess/common/colors_const.dart';
import 'package:chinesechess/ui/board/board_painter.dart';
import 'package:chinesechess/ui/board/words_on_board.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatelessWidget {
  // 棋盘内边界 + 棋盘上的路数指定文字高度
  static const Padding = 5.0, DigitsHeight = 36.0;

  // 棋盘的宽高
  final double width, height;

  ChessBoard({@required this.width}) : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: ColorsConst.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Padding,
            // 因为棋子是放在交叉线上的，不是放置在格子内，所以棋子左右各有一半在格线之外
            // 这里先依据横盘的宽度计算出一个格子的边长，再依此决定垂直方向的边距
            horizontal: (width - Padding * 2) / 9 / 2 + Padding - WordsOnBoard.DigitsFontSize / 2,
          ),
          child: WordsOnBoard(),
        ),
      ),
    );
  }
}
