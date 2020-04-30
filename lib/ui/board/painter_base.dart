import 'package:chinesechess/ui/board/chess_board.dart';
import 'package:flutter/material.dart';

// 这个类是基于棋盘绘制和棋子绘制类的交集提升出来的基类
abstract class PainterBase extends CustomPainter {
  //
  final double width;

  final thePaint = Paint();
  final gridWidth, squareSide;

  PainterBase({@required this.width})
      : gridWidth = (width - ChessBoard.Padding * 2) * 8 / 9,
        squareSide = (width - ChessBoard.Padding * 2) / 9;
}