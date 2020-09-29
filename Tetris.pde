import java.io.*;
import java.nio.*;
import processing.sound.*;
import java.util.Collections;
SoundFile music;

PImage awman;

String[] highScores;
int NUM_HIGH_SCORES=5;

ArrayList<Piece> pieces, piecesFalling;
Piece pieceHeld;//could do as one?
boolean pause, held;
float dy, score, speed;
PFont font;
InfoWidget scoreWidget;
//might not need widgets as globals... (if only dealt with within each screen)
Board board, background;
PageWidget newGame, resumeGame, returnMenu, options, quitGame, title;
//maybe dont even need seperate pageWidget and widget (and other), just handle what the event does elsewhere???? or set the event as a parameter
//could have the same widget on multiple screens (e.g. main menu pageWidget)
//->takes function as a parameter
Slider difficultySlider;
ArrayList<Screen> screens;
int screen;
/*
major:
 win/lose condition
 fix rotation (allow rotation whne it would normally collide, i.e. change how it rotates...)
 ->rotate about centre?
 fix gap after collision
 new game doesnt work after game is lost
 
 minor:
 fix UP, DOWN; keys in general
 fix collisions (remove for loops)/~
 improve rotation 'animations'
 allow for more options with screen (board size, shape)
 add scorebord (already made:)) (and store high score in memory??)
 GUI
 bigger 'tetris' combos
 ->win condition: levels? (timed/score-based/-)
 
 add a background to text which changes depending on the size of the text?
 */

void settings() {
  size(SCREEN_W, SCREEN_H);
  
  //init music
  music = new SoundFile(this, "Tetris Official Theme song.mp3");
  music.play();
}

void setup() {
  screens = new ArrayList();
  screen=MENU;
  setGameScreen();
  setGame();
  setMenuScreen();
  setOptionsScreen();
  setGameOverScreen();
  pause= false;

  
  
  awman = loadImage("awman.png");
  awman.resize(PIXEL, PIXEL);

  score=0;
  highScores = loadStrings("highscores.txt");
}

void draw() {
  background(BACKGROUND_COL);
  if (screen == GAME) {
    move();
  } else {
    screens.get(screen).draw();
    //screens.get(screen).doStuff();//->somehow put pieces in GAME...
    //screens.get(screen).draw();
  }
}

void setGameScreen() {
  screens.add(GAME, new Screen());

  background = new Board(0, 0, SCREEN_W, SCREEN_H, BORDER_COL, true, true);
  screens.get(GAME).addBoard(background);

  board = new Board(BOARD_X, BOARD_Y+PIXEL, BOARD_W, BOARD_H, 255, false, false);
  screens.get(GAME).addBoard(board);

  returnMenu = new PageWidget(SCREEN_W-5*PIXEL/2, SCREEN_H-PIXEL, 2*PIXEL, PIXEL/2, MENU, "Main menu", 255, font);
  screens.get(GAME).addPageWidget(returnMenu);

  font = loadFont("Monospaced-12.vlw");
  textFont(font);
  scoreWidget = new InfoWidget(SCREEN_W/2, board.y/2, board.width, board.y, BACKGROUND_COL, 0, "score: 0", font, false);
  screens.get(GAME).addInfo(scoreWidget);
}

void setGame() {
  dy=speed=INIT_DY;//put variable elsewhere? (not global)
  pieces = new ArrayList<Piece>(1+NUM_FUTURE_PIECES);
  for (int i = 0; i < 1+NUM_FUTURE_PIECES; i++) {
    pieces.add(newPiece(PIXEL, 4*PIXEL*i-1+PIXEL));
  }
  pieces.get(0).start();
}

void setMenuScreen() {
  screens.add(MENU, new Screen());

  screens.get(MENU).addBoard(background);

  title = new PageWidget(SCREEN_W/2, SCREEN_H/8, 4*PIXEL, PIXEL, MENU, "TETRIS", 255, font);
  screens.get(MENU).addPageWidget(title);

  newGame = new PageWidget(SCREEN_W/2, SCREEN_H/5, 4*PIXEL, PIXEL, GAME, 255, "New game", 0, font);
  screens.get(MENU).addPageWidget(newGame);

  resumeGame = new PageWidget(SCREEN_W/2, 2*SCREEN_H/5, 4*PIXEL, PIXEL, GAME, 255, "Resume game", 0, font);
  screens.get(MENU).addPageWidget(resumeGame);

  options = new PageWidget(SCREEN_W/2, 3*SCREEN_H/5, 4*PIXEL, PIXEL, OPTIONS, 255, "Options", 0, font);
  screens.get(MENU).addPageWidget(options);

  quitGame = new PageWidget(SCREEN_W/2, 4*SCREEN_H/5, 4*PIXEL, PIXEL, OPTIONS, 255, "Quit", 0, font);
  screens.get(MENU).addPageWidget(quitGame);

  //have pieces falling from the top :)
  piecesFalling = new ArrayList<Piece>();
  piecesFalling.add(newPiece(int(random(0, SCREEN_W-PIXEL))*PIXEL, int(random(0, SCREEN_H-PIXEL))*PIXEL));
}

void setOptionsScreen() {
  screens.add(OPTIONS, new Screen());

  screens.get(OPTIONS).addBoard(background);

  difficultySlider = new Slider(SCREEN_W/2, SCREEN_H/2, 4*PIXEL, PIXEL, 255, "Difficulty", 0, font);
  screens.get(OPTIONS).addSlider(difficultySlider);

  screens.get(OPTIONS).addPageWidget(returnMenu);
}

void setGameOverScreen() {
  screens.add(GAME_OVER, new Screen());

  screens.get(GAME_OVER).addBoard(background);
  screens.get(GAME_OVER).addPageWidget(newGame);
  screens.get(GAME_OVER).addPageWidget(options);
  screens.get(GAME_OVER).addPageWidget(quitGame);

  String out = "High Scores\n";
  for (int i = 0; i < NUM_HIGH_SCORES; i++) {
    if (highScores != null && i < highScores.length) {
      out+=highScores[i];
    } else {
      out+="---";
    }
    if (highScores != null && i < highScores.length-1) {
      out += "\n";
    }
  }
  screens.get(GAME_OVER).addInfo(new InfoWidget(SCREEN_W/2, 2*SCREEN_H/5, board.width, 2*PIXEL, BACKGROUND_COL, 0, out, font, false));
}

//should return the pixel position from the border
int getPixelX(float pos, float boardX) {
  return int((pos-boardX)/PIXEL);
}
int getPixelY(float pos, float boardY) {
  return int((pos-boardY)/PIXEL);
}
float getPosX(int pixel, float boardX) {
  return pixel*PIXEL+boardX;
}
float getPosY(int pixel, float boardY) {
  return pixel*PIXEL+boardY;
}

void keyPressed() {
  if (key == 0x20) {//(space)
    if (pause) {
      loop();
      pause = false;
    } else {
      noLoop();
      fill(pieces.get(0).col);//:)
      textAlign(CENTER, CENTER);
      text("paused", SCREEN_W/2, SCREEN_H/2);
      pause = true;
    }
  } else if (!pause) {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        pieces.get(0).xPos+=PIXEL;
        pieces.get(0).setPos(0);
        pieces.get(0).collideSide(1);
      } else if (keyCode == LEFT) {
        pieces.get(0).xPos-=PIXEL;
        pieces.get(0).setPos(0);
        pieces.get(0).collideSide(-1);
      } else if (keyCode == DOWN) {
        dy=2*speed;
      } else if (keyCode == UP) {
        pieces.get(0).yPos=highestPoint(pieces.get(0))-pieces.get(0).height*PIXEL;
        pieces.get(0).setPos(0);
      } else if (keyCode == 0x10 && !held) {//shift
        Piece temp = pieces.get(0);

        pieces.remove(0);
        if (pieceHeld!=null) {
          pieces.add(0, pieceHeld);
          pieces.remove(pieces.size()-1);
        }

        //set constant?
        pieceHeld = temp;
        pieceHeld.yPos=PIXEL;
        pieceHeld.xPos=BOARD_X+BOARD_W+PIXEL;
        pieceHeld.setPos(0);

        //if (pieces.get(1) != null) {
        //  pieces.set(0, pieces.get(1));//currentPiece = pieceHeld
        //  pieces.remove(pieces.get(1));//remove pieceHeld from end of array
        //  //pieces.add(temp);
        //  //pieces.remove(pieces.size()-1);//remove ?
        //}
        //else {
        //  for (int i = 0; i < pieces.size()-1; i++) {
        //    pieces.set(i, pieces.get(i+1));
        //    //pieces.get(i).setPos(0);
        //  }

        //}
        //println(pieces.size());
        //pieces.set(1, temp);//set piece held
        //pieces.get(1).yPos=PIXEL;
        //pieces.get(1).xPos=BOARD_X+BOARD_W+PIXEL;
        //pieces.get(1).setPos(0);
        //held=true;


        //temp //why is this here?
        pieces.add(newPiece(PIXEL, 4*PIXEL*pieces.size()-1+PIXEL));
        for (int i = 1; i < NUM_FUTURE_PIECES; i++) {
          pieces.get(i).yPos=4*PIXEL*(i-1)+PIXEL;
          pieces.get(i).setPos(0);
        }

        pieces.get(0).start();
      }
    } else {
      if (key == 'd') {
        pieces.get(0).setPos(1);
        if (pieces.get(0).collide()) pieces.get(0).setPos(-1);//should do in Piece
      } else if (key == 'a') {
        pieces.get(0).setPos(-1);
        if (pieces.get(0).collide()) pieces.get(0).setPos(1);//mostly works?
      } else if (key == 0x0A) {//standardize?
        resumeGame.mousePressed();
      }
    }
  }
}

void mousePressed() {
  //temp
  if (screen == MENU) {
    if (newGame.collide(mouseX, mouseY)) setup();
    else if (quitGame.collide(mouseX, mouseY)) {
      exit();
    }
  }
  screens.get(screen).mousePressed();
}
void mouseDragged() {
  screens.get(screen).mouseDragged();
}
void mouseMoved() {
  screens.get(screen).mouseMoved();
}

float highestPoint(Piece p) {
  float point = board.y + board.height;
  //for (int row = board[0].length-1; row >= 0; row--) {
  for (int row = board.height/PIXEL-1; row >= 0; row--) {//might be board.width...
    //  for (int row = getPixelY(BOARD_Y+BOARD_W); row > getPixelY(BOARD_Y); row--) { //idk
    //board_h-1???
    //for (int col = getPixel(p.xPos); col < getPixel(p.xPos+p.width*PIXEL); col++) {
    for (int col = getPixelX(p.xPos, board.x); col < getPixelX(p.xPos+p.width*PIXEL, board.x); col++) {
      //if (board[col][row].col!=BACKGROUND_COL) {//need something like shortest distance...
      if (board.getCol(col, row)!=board.backgroundCol) {
        //point=getPos(row);

        point = getPosY(row, board.y);
      }
    }
  }

  //doesnt work if both x and y are one out :)
  //-only goes one away from highest point
  //actually want it to go shortest distance
  //could just go down for each pixel and find shortest distance
  //but if there's a pixel of piece below it, it breaks :)
  //int minL = 20-getPixel(p.y[3]);//~
  //for (int pixel = 0; pixel < 4; pixel++) {
  //  int min = 20-getPixel(p.y[pixel]);//name; finds the shortest distance from piece to floor
  //  if (min < minL) minL = min;
  //  for (int l = 19; l > 0; l--) {
  //    //if another free space, cont
  //    if (board[getPixel(p.x[pixel])][l].col==BACKGROUND_COL) {
  //      //println(l);
  //      break;
  //    }
  //    else if (l < minL) minL = l;
  //    println(l);
  //  }
  //  point = p.y[pixel]+minL*PIXEL;
  //}
  //println(getPixelY(point));

  return point;
}

int tetris() {
  boolean tetris = true;
  int score = 1;
  for (int row = 0; row < board.height/PIXEL; row++) {
    tetris = true;
    for (int col = 0; col < board.width/PIXEL; col++) {
      if (board.getCol(col, row)==board.backgroundCol) tetris = false;
    }
    if (tetris) {
      shiftDown(row);
      score*=2;//inc exponentially as more rows are removed simultaneously
    }
  }
  return score/2;//returns 0 if no tetris
}

void shiftDown(int r) {
  //bit messy but it works
  for (int row = r-1; row > 0; row--) {
    boolean cont = false;
    for (int col = 0; col < board.width/PIXEL; col++) {
      if (board.getCol(col, row)!=board.backgroundCol) 
        cont = true;
      board.movePixel(col, row+1, col, row);
    }
    if (!cont) {
      return;
    }
  }
}

//static in Piece?
Piece newPiece(int x, int y) {
  //if i == 0, start() (dont need func then)
  //make pos constant within Piece, and alterable elsewhere
  switch (int(random(0, NUM_TYPES))) {//better way?
  case 0:
    return new L(x, y, 4, 0);
  case 1:
    return new J(x, y, 4, 0);
  case 2:
    return new O(x, y, 4, 0);
  case 3:
    return new I(x, y, 4, 0);
  case 4:
    return new S(x, y, 4, 0);
  case 5: 
    return new Z(x, y, 4, 0);
  case 6:
    return new T(x, y, 4, 0);
  }
  return null;
}

void move() {
  if (!pieces.get(0).collide) {
    pieces.get(0).move();
  } else {
    held=false;
    //pieces[0] is current piece
    //setBoard(pieces.get(0));
    board.addPiece(pieces.get(0));
    pieces.remove(0);
    pieces.add(newPiece(PIXEL, 4*PIXEL*pieces.size()-1+PIXEL));
    for (int i = 1; i < NUM_FUTURE_PIECES; i++) {
      //for (int i = 2; i < NUM_FUTURE_PIECES; i++) {
      pieces.get(i).yPos=4*PIXEL*(i-1)+PIXEL;
      pieces.get(i).setPos(0);
    }
    pieces.get(0).start();
    score += tetris();

    if (pieces.get(0).collide()) {
      //reset
      //remember score
      try {
        setScore(int(SCORE_COEFFICIENT*(speed-1)+SCORE_COEFFICIENT/10*score));
      }
      catch(IOException e) {
        println(e);
      }
      setup();
      screen = GAME_OVER;
    }
  }
  speed*=acceleration;
  scoreWidget.setInfo("score: "+int(SCORE_COEFFICIENT*(speed-1)+SCORE_COEFFICIENT/10*score));
  screens.get(GAME).draw();

  //should be part of screen(GAME)?
  for (int i = 0; i < pieces.size(); i++) {
    pieces.get(i).draw();
  }
  if (pieceHeld!=null) pieceHeld.draw();
}

void setScore(int score) throws IOException {
  ArrayList<Integer> temp = new ArrayList<Integer>();
  for (int i = 0; i < highScores.length; i++) {
    temp.add(int(highScores[i]));
  }
  temp.add(score);
  Collections.sort(temp);
  Collections.reverse(temp);
  highScores = new String[min(temp.size(), NUM_HIGH_SCORES)];
  for (int i = 0; i < highScores.length; i++) {
    highScores[i]=str(temp.get(i));
  }
  saveStrings("highscores.txt", highScores);
}

int getNumElements(float num, int radix) {
  int i = 0;
  for (; num >= 1; i++) {
    num /= radix;
  }
  return i;
}
