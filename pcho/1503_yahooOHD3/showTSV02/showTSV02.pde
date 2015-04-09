/*

 02
 左右keyで移動
 
 *n列目を棒グラフとして表示
 *滑らかに補完して表示
 *散布図
 
 01
 tsvを読んで何かを表示する
 
 */


FloatTable data;
int columnCount, rowCount;

int curCol=0;

PFont font;

int w, h;

void setup() {
  size(640, 480);
  noStroke();
  colorMode(HSB);

  w=width;
  h=height;

  font = loadFont("Dialog-48.vlw");
  textFont(font);

  data = new FloatTable("sample.tsv");
  columnCount = data.getColumnCount();
  rowCount = data.getRowCount();
}


void draw() {
  background(255);

  //文字はデカルト座標になる前に
  fill(255, 0, 0);
  text(curCol, w-80, 80);

//デカルト座標化処理
  Cartesianize();



  //描画
  //drawBar(curCol); 
  //drawPoly(curCol);
  drawScatter(curCol, 2);
}

//デカルト座標化，軸の描画
void Cartesianize() {

  //デカルト座標化
  //translate(0, height);
  translate(w/10, h-h/10);
  scale(1, -1);

  //グラフの軸
  stroke(0);
  strokeWeight(5);
  int tic = 100;
  //x軸
  line(-w/20, 0, w-3*w/20, 0);
  line(w-3*w/20, 0, w-3*w/20-10, 10);
  line(w-3*w/20, 0, w-3*w/20-10, -10);

  for (int i=1; i<w/tic; i++) {
    line(tic*i, -10, tic*i, 10);
  }
  //y軸
  line(0, -h/20, 0, h-3*h/20);
  line(0, h-3*h/20, 10, h-3*h/20-10);
  line(0, h-3*h/20, -10, h-3*h/20-10);
  for (int i=1; i<h/tic; i++) {
    line(-10, tic*i, 10, tic*i);
  }
  

}

//左右キーで列を行き来
void keyPressed() {

  if (key==CODED) {
    if (keyCode==RIGHT) curCol++; 
    if (keyCode==LEFT) curCol--;
  }

  //境界を超えない
  if (curCol<0)curCol+=columnCount;
  if (curCol>=columnCount)curCol-=columnCount;
}

//二軸指定の散布図
void drawScatter(int col1, int col2) {

  for (int row = 0; row<rowCount; row++) {

    float val1 = data.getFloat(row, col1); 
    float val2 = data.getFloat(row, col2); 
    fill(curCol*100,200,200);
    noStroke();
    ellipse(val1, val2, 10, 10);
  }
}

//折線
void drawPoly(int col) {

  int rowCount = data.getRowCount();

  colorMode(HSB);
  noFill();
  stroke(col*50, 200, 200);
  strokeWeight(5);
  beginShape();
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    //fill(50*col);
    //rect(row*50+25, 0, 40, val);
    vertex(row*50+25, val);
  }
  endShape();
}

//単色棒グラフの表示
void drawBar(int col) {

  int rowCount = data.getRowCount();
  for (int row = 0; row<rowCount; row++) {

    float val = data.getFloat(row, col);
    fill(50*col);
    noStroke();
    rect(row*50+25, 0, 40, val);
  }
}


//サンプルで作ってみただけ
void drawData() {
  //int rowCount = data.getRowCount();
  //println(rowCount);

  for (int row = 0; row<rowCount; row++) {

    // if (data.isValid(row, col)) {
    //println("hi");
    //    float value = data.getFloat(row, col);

    float x = data.getFloat(row, 0);
    float y = data.getFloat(row, 1);
    float r = data.getFloat(row, 2);

    fill(r, 200, 200);
    ellipse(x, y, r, r);

    int sz=20;
    fill(r+20, 200, 100);    
    text(row+1, x-sz, y+sz);





    //float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
    //float y = map(value, dataMin, dataMax, plotY2, plotY1);
    //point(x, y);

    //}
  }
}

