class Z extends Piece {
  Z(float xPos, float yPos, int numPixels, color col) {
    super(xPos, yPos, numPixels, col);
    this.col=ZCol;
    this.numPixels = 4;
  }

  void setPos(int rotate) {
    pos+=rotate;
    if (pos > 3) pos = 0;
    else if (pos < 0) pos = 3;
    switch(pos) {
    case 0:
    case 2:
      x[0]=xPos;
      x[1]=xPos+PIXEL;
      x[2]=xPos+PIXEL;
      x[3]=xPos+2*PIXEL;
      width=3;
      y[0]=yPos;
      y[1]=yPos;
      y[2]=yPos+PIXEL;
      y[3]=yPos+PIXEL;
      height=2;
      break;
    case 1:
    case 3:
      x[0]=xPos;
      x[1]=xPos;
      x[2]=xPos+PIXEL;
      x[3]=xPos+PIXEL;
      width=2;
      y[0]=yPos+PIXEL;
      y[1]=yPos+2*PIXEL;
      y[2]=yPos;
      y[3]=yPos+PIXEL;
      height=3;
      break;
    }
  }
}
