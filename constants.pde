int PIXEL = 25;//change this to change screen size
final int BORDER_W = 5 * PIXEL;
final int BORDER_H = 1 * PIXEL;
final int BOARD_X = BORDER_W;
final int BOARD_Y = BORDER_H;
//standard: 10x20
final int BOARD_W = 10 * PIXEL;
final int BOARD_H = 20 * PIXEL;
final int NUM_X = BOARD_W + 2*BORDER_W;
final int NUM_Y = BOARD_H + 2*BORDER_H;
final int SCREEN_W = NUM_X;
final int SCREEN_H = NUM_Y;

color BACKGROUND_COL = 255;
color BORDER_COL = 35;
color ICol = color(0, 255, 255);
color JCol = color(0, 0, 255);
color LCol = color(255, 165, 0);
color OCol = color(255, 204, 0);
color SCol = color(0, 255, 0);
color TCol = color(153, 51, 255);
color ZCol = color(255, 0, 0);

int TICK = 60;//speeds up over time
//could fix but ech

final int NUM_TYPES = 7;

//change based on difficulty; can have levels which start high but dont inc as fast, etc.
final float INIT_DY = 1;
float acceleration = 1.0001;  //exponential (need to change to *=)
//float acceleration = 0.0001;  //linear (need to change to +=)

final int SCORE_COEFFICIENT = 1000;

final int NUM_FUTURE_PIECES = 4;

//enums?
final int NUM_SCREENS = 4;
final int GAME = 0;
final int MENU = 1;
final int OPTIONS = 2;
final int GAME_OVER = 3;
