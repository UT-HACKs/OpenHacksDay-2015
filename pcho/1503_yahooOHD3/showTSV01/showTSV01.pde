/*

 01
 tsvを読んで何かを表示する
 花火みたいにちょっとおしゃれな？感じ
 
 */


FloatTable data;
int columnCount;

PFont font;

void setup() {
  size(640, 480);
  noStroke();

  font = loadFont("Dialog-48.vlw");
  textFont(font);

  data = new FloatTable("sample.tsv");
  columnCount = data.getColumnCount();
}


void draw() {
  //background(255);
  //fill(50, 100);
  fill(#191970,100);
  rect(0, 0, width, height);

  //デカルト
  //translate(0, height);
  //  scale(1, -1);


  //描画
  drawData();
}

void drawData() {
  int rowCount = data.getRowCount();
  //println(rowCount);

  for (int row = 0; row<rowCount; row++) {

    // if (data.isValid(row, col)) {
    //println("hi");
    //    float value = data.getFloat(row, col);

    float x = data.getFloat(row, 0);
    float y = data.getFloat(row, 1);
    float r = data.getFloat(row, 2);

    colorMode(HSB);
    fill(r, 200, 200);

    pushMatrix();
    translate(x, y);
    int N=12;
    for (int n=0; n<N; n++) {
      ellipse(0, -mouseY, 5, 30);
      rotate(radians(360/N));
    }
    popMatrix();






    int sz=20;
    fill(r+20, 200, 100);    
    text(row+1, x-sz, y+sz);



    //float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
    //float y = map(value, dataMin, dataMax, plotY2, plotY1);
    //point(x, y);

    //}
  }
}

