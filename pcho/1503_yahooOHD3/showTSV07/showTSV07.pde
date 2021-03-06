/*

 07
 軸の自動目盛機能を実装！
 sub_adaptiveTic01を取り入れた！
 ※scatterモードはまだうまく作動しない
 
 
 06(modeチェンジして欲しいグラフを出力：親03)
 ・jpg出力機能
 ※たまに落ちるようになった
 
 03
 上下でグラフモード変更
 
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
int mode=0;

PFont font;

float max1, max2;

int tic=100, ticNum=3;//縦軸用

int modeNum=3;


int w, h;

void setup() {
  size(640, 480);
  noStroke();
  colorMode(HSB);

  w=width;
  h=height;

  max1=-1;
  max2=-1;

  font = loadFont("Dialog-48.vlw");
  textFont(font);

  data = new FloatTable("target.tsv");
  columnCount = data.getColumnCount();
  rowCount = data.getRowCount();
}


void draw() {
  background(255);

  //文字はデカルト座標になる前に
  //fill(255, 0, 0);
  //text(curCol, w-80, 80);

  //デカルト座標化処理
  Cartesianize();

  String colName=data.getColumnName(curCol);

  //軸の名前
  textSize(24);
  if(mode%modeNum != 2){
  invText(colName, w-200, 0.8*h);
  }else{
   //Scatterのとき
      invText(colName+":T[s]", w-240, 0.8*h);

  }


  //描画
  String modeName="";
  switch(mode%modeNum) {
  case 0:  
    drawBar(curCol); 
    modeName="BAR";
    break;
  case 1:  
    drawPoly(curCol); 
    modeName="POLYGONAL";
    break;
    //default:
  case 2: 
    drawScatter(curCol, 2);
    modeName="SCATTER";
    break;
  }

  //モード名
  fill(0);
  textSize(36);
//  invText(modeName, 0.5*w, 0.8*h);

  //  drawBar(curCol); 
  //drawPoly(curCol);
  //drawScatter(curCol, 2);
}

//png出力
void mousePressed() {
  mySave();
}

//mouseとENTER
void mySave() {
  save("fig/graph.png");
  println("saved!");
}


//デカルト座標で上下反転状態でも正立の文字を表示
void invText(String str, float x, float y) {

  pushMatrix();
  translate(x, y);
  scale(1, -1);
  text(str, 0, 0);
  popMatrix();
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
  //  int tic = 100;
  //x軸
  line(-w/20, 0, w-3*w/20, 0);
  line(w-3*w/20, 0, w-3*w/20-10, 10);
  line(w-3*w/20, 0, w-3*w/20-10, -10);


  //y軸
  line(0, -h/20, 0, h-3*h/20);
  line(0, h-3*h/20, 10, h-3*h/20-10);
  line(0, h-3*h/20, -10, h-3*h/20-10);

  //ticX
  int ticX=100;
  for (int i=1; i<w/ticX; i++) {
    float x = ticX*i;
    line(x, -10, x, 10);

    //Scatterじゃなければデータ番号
    if (mode%modeNum != 2) {
      textSize(24);
      invText(str(2*i), x-35, -25);
    }
  }


  //ticY
  for (int i=0; i<=ticNum; i++) {
    float y=map(tic*i, 0, max1, 0, 0.6*w);

    line(-10, y, 10, y);
    textSize(24);
    invText(str(tic*i), -60., y-20);
  }
}

//左右キーで列を行き来
void keyPressed() {

  if (key==CODED) {
    if (keyCode==RIGHT)  curCol++; 
    if (keyCode==LEFT)   curCol--;
    if (keyCode==UP)  mode++; 
    if (keyCode==DOWN)   mode--;
    if (keyCode==ENTER) mySave();
  }

  //境界を超えない
  if (curCol<0)curCol+=columnCount;
  if (curCol>=columnCount)curCol-=columnCount;
  if (mode<0) mode+=modeNum;
}

//二軸指定の散布図
void drawScatter(int col1, int col2) {

  for (int row = 0; row<rowCount; row++) {

    float val1 = data.getFloat(row, col1); 
    float val2 = data.getFloat(row, col2); 
    fill(curCol*100, 200, 200);
    noStroke();
    ellipse(val1, val2, 10, 10);
  }
}

//折線
void drawPoly(int col) {

  //最大値探索  
  max1=-1;
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    if (max1<val)max1=val;
  }

  adaptiveTic(int(max1));


  int rowCount = data.getRowCount();

  colorMode(HSB);
  noFill();
  stroke(col*50, 200, 200);
  strokeWeight(5);
  beginShape();
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    //fill(50*col);
    float y=map(val, 0, max1, 0, 0.6*w);
    vertex(row*50, y);
  }
  endShape();
}

//単色棒グラフの表示
void drawBar(int col) {

  //最大値探索      
  max1=-1;
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    if (max1<val)max1=val;
  }

  adaptiveTic(int(max1));

  int rowCount = data.getRowCount();
  for (int row = 0; row<rowCount; row++) {

    float val = data.getFloat(row, col);
    fill(50*col, 200, 200);
    noStroke();
    float y=map(val, 0, max1, 0, 0.6*w);
    rect(row*50, 0, 40, y);
  }
}

//maxをいれるとticとticNumを自動設定
void adaptiveTic(int max) {
  String numStr= str(max);
  int len = numStr.length();
  String pre2str=numStr.substring(0, 2);
  int n2 = parseInt(pre2str);//先頭２文字

  if (10<=n2 && n2<20) {
    tic = 5;
  } else if (20<=n2 && n2<50) {
    tic = 10;
  } else if (50<=n2 && n2 <=99) {
    tic = 20;
  }  
  ticNum= n2/tic;
  tic*=pow(10, len-2);//元の桁数に直す

  println(max);
  println(ticNum);
  println(tic);
}

