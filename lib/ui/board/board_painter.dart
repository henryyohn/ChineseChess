import 'dart:math';

import 'package:chinesechess/common/colors_const.dart';
import 'package:chinesechess/ui/board/chess_board.dart';
import 'package:chinesechess/ui/board/painter_base.dart';
import 'package:flutter/material.dart';

class BoardPainter extends PainterBase {
  // 棋盘的宽度， 横盘上线格的总宽度，每一个格子的边长
  final double width;
  final thePaint = Paint();

  BoardPainter( {@required this.width}) : super(width: width);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      gridWidth,
      squareSide,
      offsetX: ChessBoard.Padding + squareSide / 2,
      offsetY: ChessBoard.Padding + ChessBoard.DigitsHeight + squareSide / 2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  static void doPaint(
    Canvas canvas,
    Paint paint,
    double gridWidth,
    double squareSide, {
    double offsetX,
    double offsetY,
  }) {
    /* 绘制外框和纵横线 */
    paint.color = ColorsConst.BoardLine;
    paint.style = PaintingStyle.stroke;

    var left = offsetX, top = offsetY;

    // 外框
    paint.strokeWidth = 2;
    print("width=$gridWidth, squareSidex9=${squareSide * 9}");
    canvas.drawRect(
      Rect.fromLTWH(left, top, gridWidth, squareSide * 9),
      paint,
    );

    // 中轴线
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(left + gridWidth / 2, top),
      Offset(left + gridWidth / 2, top + squareSide * 9),
      paint,
    );

    // 8 根中间的横线
    for (var i = 1; i < 9; i++) {
      canvas.drawLine(
        Offset(left, top + squareSide * i),
        Offset(left + gridWidth, top + squareSide * i),
        paint,
      );
    }

    // 上下各6根短竖线
    for (var i = 0; i < 8; i++) {
      //
      if (i == 4) continue; // 中间拉通的线已经画过了

      canvas.drawLine(
        Offset(left + squareSide * i, top),
        Offset(left + squareSide * i, top + squareSide * 4),
        paint,
      );
      canvas.drawLine(
        Offset(left + squareSide * i, top + squareSide * 5),
        Offset(left + squareSide * i, top + squareSide * 9),
        paint,
      );
    }

    /* 九宫中的四根斜线 */
    canvas.drawLine(
      Offset(left + squareSide * 3, top),
      Offset(left + squareSide * 5, top + squareSide * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 5, top),
      Offset(left + squareSide * 3, top + squareSide * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 3, top + squareSide * 7),
      Offset(left + squareSide * 5, top + squareSide * 9),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 5, top + squareSide * 7),
      Offset(left + squareSide * 3, top + squareSide * 9),
      paint,
    );

    /* 绘制标定炮和兵卒起始位置的标识 */
    // 炮/兵架位置指示
    final positions = [
      // 炮架位置指示
      Offset(left + squareSide, top + squareSide * 2),
      Offset(left + squareSide * 7, top + squareSide * 2),
      Offset(left + squareSide, top + squareSide * 7),
      Offset(left + squareSide * 7, top + squareSide * 7),
      // 部分兵架位置指示
      Offset(left + squareSide * 2, top + squareSide * 3),
      Offset(left + squareSide * 4, top + squareSide * 3),
      Offset(left + squareSide * 6, top + squareSide * 3),
      Offset(left + squareSide * 2, top + squareSide * 6),
      Offset(left + squareSide * 4, top + squareSide * 6),
      Offset(left + squareSide * 6, top + squareSide * 6),
    ];

    positions.forEach((pos) => canvas.drawCircle(pos, 5, paint));

    // 兵架靠边位置指示
    final leftPositions = [
      Offset(left, top + squareSide * 3),
      Offset(left, top + squareSide * 6),
    ];
    leftPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, -pi / 2, pi, true, paint);
    });

    final rightPositions = [
      Offset(left + squareSide * 8, top + squareSide * 3),
      Offset(left + squareSide * 8, top + squareSide * 6),
    ];
    rightPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, pi / 2, pi, true, paint);
    });
  }
}
