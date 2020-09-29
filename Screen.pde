import java.util.Optional;

class Screen {
  //methods; addWidget, removeWidget, addWidgetList, removeWidgetList, draw
  ArrayList widgets;
  ArrayList<InfoWidget> infoList;
  ArrayList<Board> boardList;
  ArrayList<PageWidget> pageWidgetList;
  ArrayList<Slider> sliderList;
  ArrayList<Piece> pieceList;
  //could have an object of type T which contains any variables normally kept in main
  
  Screen() {
    infoList = new ArrayList();
    boardList = new ArrayList();
    pageWidgetList = new ArrayList();
    sliderList = new ArrayList();
    pieceList = new ArrayList();
    widgets = new ArrayList();
    widgets.add(infoList);
  }
  
  void draw() {//order is important
    int[] arr = {infoList.size(), boardList.size(), pageWidgetList.size(), sliderList.size(), pieces.size()};
    int max = max(arr);//need variable?
    for (int i = 0; i < max; i++) {
      if (i < boardList.size()) boardList.get(i).draw();
      if (i < infoList.size()) infoList.get(i).draw();
      if (i < pageWidgetList.size()) pageWidgetList.get(i).draw();
      if (i < sliderList.size()) sliderList.get(i).draw();
      if (i < pieceList.size()) pieceList.get(i).draw();
    }
  }
  
  void mousePressed() {
    int[] arr = {infoList.size(), boardList.size(), pageWidgetList.size(), sliderList.size()};
    int max = max(arr);
    for (int i = 0; i < max; i++) {//for each thing that has an event...
      if (i < pageWidgetList.size() && pageWidgetList.get(i).collide(mouseX, mouseY)) pageWidgetList.get(i).mousePressed();
    }
  }
  void mouseDragged() {
    int[] arr = {infoList.size(), boardList.size(), pageWidgetList.size(), sliderList.size()};
    int max = max(arr);
    for (int i = 0; i < max; i++) {//for each thing that has a drag...
      if (i < sliderList.size()) sliderList.get(i).mouseDragged(mouseX, mouseY);  
    }
  }
  void mouseMoved() {
    int[] arr = {infoList.size(), boardList.size(), pageWidgetList.size(), sliderList.size()};
    int max = max(arr);
    for (int i = 0; i < max; i++) {//for each thing that has a drag...
    }
  }
  
  
  //void main() {
  //}
  
  void addInfo(InfoWidget info) {
    infoList.add(info);
  }
  void addBoard(Board board) {
    boardList.add(board);
  }
  void addPageWidget(PageWidget pageWidget) {
    pageWidgetList.add(pageWidget);
  }
  void addSlider(Slider slider) {
    sliderList.add(slider);
  }
  void addPiece(Piece piece) {
    pieceList.add(piece);
  }
  
  
  //dont even need this: jsut need addWidget which either makes a new arraylist of the type of the widget, or adds the widget parameter to the list if that list already exists
  void addWidgetList(ArrayList list) {//adds arraylist of type t to 'widgets'
    widgets.add(list);
  }
  void addWidget(Optional<T> widget) {//puts in relevant list
  }//can give index so it goes on top?
}
