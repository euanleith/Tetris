class I extends Piece {
  I(float xPos, float yPos, int numPixels, color col) {
    super(xPos, yPos, numPixels, col);
    this.col=ICol;
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
      x[2]=xPos+2*PIXEL;
      x[3]=xPos+3*PIXEL;
      width=4;
      y[0]=yPos;
      y[1]=yPos;
      y[2]=yPos;
      y[3]=yPos;
      height=1;
      break;
    case 1:
    case 3:
      x[0]=xPos;
      x[1]=xPos;
      x[2]=xPos;
      x[3]=xPos;
      width=1;
      y[0]=yPos;
      y[1]=yPos+PIXEL;
      y[2]=yPos+2*PIXEL;
      y[3]=yPos+3*PIXEL;
      height=4;
      break;
    }
  }
}
