class InfoWidget {
  float x, y, width, height;
  String info;
  color backgroundCol, textCol;
  String infoType;
  PFont font;
  boolean stroke;//strokeColour
  InfoWidget(float x, float y, float width, float height, 
    color backgroundCol, color textCol, String info, PFont font, boolean stroke) {
    this.x=x;
    this.y=y;
    this.width=width/2;//?
    this.height=height;
    this.backgroundCol=backgroundCol;
    this.textCol=textCol;
    this.infoType=infoType;
    this.info=info;
    this.font=font;
    this.stroke=stroke;
  }
  void draw() {
    rectMode(RADIUS);
    textAlign(CENTER,CENTER);
    fill(backgroundCol);
    if (stroke) stroke(0);
    else noStroke();
    rect(x,y,width,height);
    fill(textCol);
    textFont(font);
    text(info, x, y);
    rectMode(CORNER);
    textAlign(CORNER);
    stroke(0);
  }
  void setInfo(String info) {
    this.info=info;
  }
}
