import 'package:chinesechess/common/colors_const.dart';
import 'package:chinesechess/ui/board/chess_board.dart';
import 'package:chinesechess/ui/board/painter_base.dart';
import 'package:chinesechess/ui/cchess/cc_base.dart';
import 'package:chinesechess/ui/cchess/phase.dart';
import 'package:flutter/material.dart';

class PiecesPainter extends PainterBase {
  // 棋盘的宽度， 横盘上线格的总宽度，每一个格子的边长
  final double width;
  final thePaint = Paint();

  final Phase phase;
  double pieceSide;

  // 添加棋盘上的棋子移动、选择位置指示
  final int focusIndex, blurIndex;

  PiecesPainter({
    @required this.width,
    @required this.phase,
    // 添加棋盘上的棋子移动、选择位置指示，-1 表示无效，不用绘制
    this.focusIndex = -1,
    this.blurIndex = -1,
  }) : super(width: width) {
    //
    pieceSide = squareSide * 0.9;
  }

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      phase: phase,
      gridWidth: gridWidth,
      squareSide: squareSide,
      pieceSide: pieceSide,
      offsetX: ChessBoard.Padding + squareSide / 2,
      offsetY: ChessBoard.Padding + ChessBoard.DigitsHeight + squareSide / 2,
      focusIndex: focusIndex,
      blurIndex: blurIndex,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 每次重建 Painter 时都要重画
    return false;
  }

  static void doPaint(
    Canvas canvas,
    Paint paint, {
    Phase phase,
    double gridWidth,
    double squareSide,
    double pieceSide,
    double offsetX,
    double offsetY,
    int focusIndex = -1,
    int blurIndex = 1,
  }) {
    /*计算好各棋子位置*/
    final left = offsetX, top = offsetY;
    // 在 Flutter 中绘制阴影，需要先将阴影对象添加到一个 Path 中
    // 我们绘制棋子时，可以将每个棋子的阴影路径一次性添加到 Path 中，然后一次绘制所有棋子的阴隐
    final shadowPath = Path();
    final piecesToDraw = <PiecePaintStub>[];

    for (var row = 0; row < 10; row++) {
      //
      for (var column = 0; column < 9; column++) {
        //
        final piece = phase.pieceAt(row * 9 + column);
        if (piece == Piece.Empty) continue;

        // 根据行列位置，计算棋子的位置
        var pos = Offset(left + squareSide * column, top + squareSide * row);

        piecesToDraw.add(PiecePaintStub(piece: piece, pos: pos));

        // 为每一个棋盘上存在的棋子绘制一个圆形阴影
        shadowPath.addOval(
          Rect.fromCenter(center: pos, width: pieceSide, height: pieceSide),
        );
      }
    }
    // 绘制黑色的厚度为 2dp 的棋子阴影
    canvas.drawShadow(shadowPath, Colors.black, 2, true);

    /*棋子绘制*/
    paint.style = PaintingStyle.fill;

    final textStyle = TextStyle(
      color: ColorsConst.PieceTextColor,
      fontSize: pieceSide * 0.8,
      fontFamily: 'QiTi',
      height: 1.0,
    );

    // 逐个绘制棋子
    piecesToDraw.forEach((pps) {
      //
      paint.color = Piece.isRed(pps.piece) ? ColorsConst.RedPieceBorderColor : ColorsConst.BlackPieceBorderColor;

      // 绘制棋子的边界
      canvas.drawCircle(pps.pos, pieceSide / 2, paint);

      paint.color = Piece.isRed(pps.piece) ? ColorsConst.RedPieceColor : ColorsConst.BlackPieceColor;

      // 绘制棋子的内部圆
      canvas.drawCircle(pps.pos, pieceSide * 0.8 / 2, paint);

      final textSpan = TextSpan(text: Piece.Names[pps.piece], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      // 计算字体的 Metrics，包含相应字体的 Baseline
      final metric = textPainter.computeLineMetrics()[0];

      // 测量文字的尺寸
      final textSize = textPainter.size;

      // 从顶上算，文字的 Baseline 在 2/3 高度线上
      final textOffset = pps.pos - Offset(textSize.width / 2, metric.baseline - textSize.height / 3);

      // 将文字绘制到 Canvas 上
      textPainter.paint(canvas, textOffset);
    });

    /*draw focus and blur position*/
    // 绘制棋子的选定效果，注意绘制的次序，先绘制的在下层

    if (focusIndex != -1) {
      //
      final int row = focusIndex ~/ 9, column = focusIndex % 9;

      paint.color = ColorsConst.FocusPosition;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;

      canvas.drawCircle(
        Offset(left + column * squareSide, top + row * squareSide),
        pieceSide / 2,
        paint,
      );
    }

    if (blurIndex != -1) {
      //
      final row = blurIndex ~/ 9, column = blurIndex % 9;

      paint.color = ColorsConst.BlurPosition;
      paint.style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(left + column * squareSide, top + row * squareSide),
        pieceSide / 2 * 0.8,
        paint,
      );
    }
  }
}

class PiecePaintStub {
  final String piece;
  final Offset pos; // 棋子呈现位置
  PiecePaintStub({this.piece, this.pos});
}
