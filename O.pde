class O extends Piece {
  O(float xPos, float yPos, int numPixels, color col) {
    super(xPos, yPos, numPixels, col);
    this.col=OCol;
    this.numPixels = 4;
  }
  void setPos(int rotate) {
    x[0]=xPos;
    x[1]=xPos+PIXEL;
    x[2]=xPos;
    x[3]=xPos+PIXEL;
    width=2;
    y[0]=yPos;
    y[1]=yPos;
    y[2]=yPos+PIXEL;
    y[3]=yPos+PIXEL;
    height=2;
  }
}
