class Piece {
  int pos;
  boolean collide, c;
  float xPos, yPos;
  float[] x, y;
  int width, height, cnt, cnt2, numPixels;
  color col;
  //could alter rotations to look cleaner, but would need to change 'collideSide' to check all pixels


  //maybe just have xy, and add num and col as methods? or dont have to have num and col in constructor for subclasses (is that possible?)
  Piece(float xPos, float yPos, int numPixels, color col) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.numPixels=numPixels;
    this.col = col;
    collide = false;
    x = new float[numPixels];
    y = new float[numPixels];
    //for (int i = 0; i < numPixels; i++) {//?need to set pixels to something at start....
    //-could start out with one, then method for adding new pixel(s)
    x[0]=xPos;
    y[0]=yPos;

    pos=0;
    setPos(0);
    cnt=TICK;
    cnt2=TICK;
  }

  //dont want to let them move/rotate if doing so would clip with another piece/wall
  void move() {
    cnt-=dy;

    //messy but works... (even messier now :))
    //want to give one tick after first collides where player can choose final pos
    //and if the piece stops colliding, reset the counter
    //could player do this forever? and is that bad?
    //-doesnt work when rotating?
    //-or on final tick?
    if (cnt2 < TICK && c) {
      yPos+=PIXEL;
      setPos(0);
      if (collide()) {
        yPos-=PIXEL;
        setPos(0);
      } else c = false;
      cnt2-=dy;
      if (cnt2 < 0) collide = true;
    } else if (cnt < 0) {
      cnt=TICK;
      yPos+=PIXEL;
      setPos(0);
      if (collide()) {
        c=true;
        yPos-=PIXEL;//could do earlier?
        setPos(0);
        cnt2=TICK-1;
      }
    }
    dy=speed;
  }
  //need to rethink:
  //want to give one tick after first collides where player can choose final pos
  //and if the piece stops colliding, reset the counter
  //problem is that collide() only goes off if piece is in another block (i.e. not just touching)
  //
  //if (cnt < 0) {
  //  cnt = TICK;
  //  yPos+=PIXEL;
  //  setPos(0);
  //}

  void draw() {
    fill(col);
    for (int i = 0; i < numPixels; i++) {
      rect(x[i], y[i], PIXEL, PIXEL);
      //image(awman, x[i], y[i]);
    }
  }

  boolean collide() {
    return colFloor() || colPiece();
  }

  boolean collideSide(int dir) {//-1=left, 1=right, 0=straight (make final)
    if (dir == -1 && (xPos < board.x || colPiece())) {
      xPos+=PIXEL;
      setPos(0);
      return true;
    } else if (dir == 1 && 
      (xPos + width > board.x + board.width || colPiece())) {
      xPos-=PIXEL;
      setPos(0);
      return true;
    }
    return false;
  }

  void setPos(int rotate) {
  }

  boolean colFloor() {
    return yPos + height*PIXEL > board.y + board.height;
  }

  boolean colPiece() {
    for (int pixel = 0; pixel < numPixels; pixel++) {
      if (x[pixel] < board.x || x[pixel] >= board.x + board.width ||
        board.getCol(getPixelX(x[pixel], board.x), getPixelY(y[pixel], board.y))!=board.backgroundCol) {
        //shouldnt need to know what board its on? do elsewhere???
        return true;
      }
    }
    return false;
  }

  void start() {
    xPos=board.x+board.width/2-2*PIXEL;//...
    if (board.width%2!=0) xPos-=PIXEL/2;
    yPos=board.y;
    setPos(0);
  }

  //shouldnt need i as parameter, can do within class
  //-make x and y arraylists and this.x.add(x);
  void addPixel(int i, int x, int y) {
    this.x[i]=x;
    this.y[i]=y;
  }
}
