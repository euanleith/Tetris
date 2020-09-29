class Board {
  //matrix of pixels of backgroundCol
  //can add pixels of a colour at a location
  Pixel[][] board;
  float x, y;//in normal
  int height, width;//in pixels //make both the same (normal)
  boolean stroke, backgroundStroke;//adds stroke for background pixels
  //-what about if you want all pixels to be one or the other?
  
  color backgroundCol;

  Board(float x, float y, int width, int height, color backgroundCol, boolean stroke, boolean backgroundStroke) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.stroke = stroke;
    this.backgroundStroke = backgroundStroke;
    this.backgroundCol = backgroundCol;
    board = new Pixel[width/PIXEL][height/PIXEL];
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        board[i][j]=new Pixel(backgroundCol);
      }
    }
  }

//puts piece on board
//name; setPiece?
  void addPiece(Piece p) {
    for (int pixel = 0; pixel < p.numPixels; pixel++) {
      board[getPixelX(p.x[pixel],x)][getPixelY(p.y[pixel],y)]=new Pixel(p.col);
    }
  }
  
  void addPixel(float x, float y, color col) {
    board[getPixelX(x,this.x)][getPixelY(y,this.y)]=new Pixel(col);
  }
  
  //moves piece to board[i][j]
  void movePiece(Piece p, int col, int row) {
    for (int pixel = 0; pixel < p.numPixels; pixel++) {
      board[col][row]=board[getPixelX(p.x[pixel],x)][getPixelY(p.y[pixel],y)];
    }
  }
  
  //sets pixel at col1row1 to col2row2
  void movePixel(int col1, int row1, int col2, int row2) {
    board[col1][row1]=board[col2][row2];
  }

  void draw() {
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        fill(board[i][j].col);
        if (!backgroundStroke && board[i][j].col==backgroundCol) noStroke();//...
        else if (stroke) {
          stroke(0);
        }
        rect(getPosX(i,x), getPosY(j,y), PIXEL, PIXEL);
        stroke(0);
      }
    }
  }
  
  color getCol(int col, int row) {
    return board[col][row].col;
  }
  //color getCol(Pixel p) {
  //  return board[getPixelX(p.x,x)]
  //}
}
