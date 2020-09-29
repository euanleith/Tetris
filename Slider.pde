class Slider {
  int x, y, width, height;
  String label;
  color col, labelCol;
  PFont font;
  float xBar;
  float num;
  float per;
  final int MARGINX, MARGINY, BAR_W, BAR_H;
  
  //have two main constructors: one for just slider, and one for slider w/ standard widget
  //3 things: slider, info its sliding between, and a 'title'
  //so 3 main; 1: just slider. 2: slider & info. 3: slider, info, & title.
  //other combinations/stuff?
  //numOptions (3-easy,medium,hard) . per = len/numOptions; label for each
  Slider(int x, int y, int width, int height, color col,
    String label, color labelCol, PFont font) {
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.label=label;
    this.col=col; 
    this.font=font;
    this.labelCol=labelCol;
    
    MARGINX = width/20;
    MARGINY = height/4;
    BAR_W = width/4;
    BAR_H = height/2;
    xBar=x+MARGINX;
    
    float len = (x+width-MARGINX-BAR_W/2)-(BAR_W/2+x+MARGINX);
    per=len/100;
  }
  void draw() {
    fill(col);
    //rectMode(RADIUS);
    rect(x, y, width, height);
    //rectMode(CORNER);
    fill(labelCol);
    text(label, x+10, y+height/2);
    fill(255);
    rect(xBar, y+MARGINY, BAR_W, BAR_H);
    fill(0);
    text(int(num),x,y);
  }
  
  //boolean collide(int x, int y) {
  //  return x > this.x - width && x < this.x + width && y > this.y - height && y < this.y + height;
  //  //return x > this.x && x < this.x+width && y > this.y && y < this.y+height;//might be weird now
  //}
  boolean collide(int mX, int mY) {//temp
    if (mX>x && mX < x+width && mY >y && mY <y+height) {
      return true;
    }
    return false;
  }
  
  void mouseDragged(int x, int y) {
    if (x > xBar && xBar >= x+MARGINX &&
      x < xBar+BAR_W && xBar+BAR_W <= x+width-MARGINX) {
        xBar = x-BAR_W/2;
      }
      if (xBar+BAR_W > x+width-MARGINX) xBar=x+width-MARGINX-BAR_W;
      if (xBar < x+MARGINX) xBar = x+MARGINX;
      
      num=(xBar-(x+MARGINX))/per;
  }
}
