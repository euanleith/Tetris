class PageWidget {
  int x, y, width, height;
  String label;
  color col, labelCol;
  PFont font;
  int toScreen; //which screen clicking on this takes you to
  //name (cant use same as in main...)
  boolean background;

  //could have a bunch of constructors...
  PageWidget(int x, int y, int width, int height, int toScreen, color col, 
    String label, color labelCol, PFont font) {
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.toScreen=toScreen;
    this.label=label;
    this.col=col; 
    this.font=font;//not used...
    this.labelCol=labelCol;
    background=true;
  }
  PageWidget(int x, int y, int width, int height, int toScreen, color col) {
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.toScreen=toScreen;
    this.col=col; 
    labelCol=col;
    label="";
    background=true;
  }
  //doesnt have any background
  PageWidget(int x, int y, int width, int height, int toScreen, 
    String label, color labelCol, PFont font) {
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.toScreen=toScreen;
    this.label=label;
    this.col=col; 
    this.font=font;//not used...
    this.labelCol=labelCol;
    background=false;
  }

  void draw() {
    rectMode(RADIUS);
    textAlign(CENTER, CENTER);
    stroke(0);//strokeCol
    if (background) {
      fill(col);
      rect(x, y, width, height);
    }
    fill(labelCol);
    text(label, x, y);
    rectMode(CORNER);
    textAlign(CORNER);
  }

  boolean collide(int x, int y) {
    return x > this.x - width && x < this.x + width && y > this.y - height && y < this.y + height;
    //return x > this.x && x < this.x+width && y > this.y && y < this.y+height;//might be weird now
  }
  void mousePressed() {
    screen=toScreen;
    
    //bit messy...
    loop();
    pause = false;
  }
}
