/*

 適応的軸目盛
 
 00
 軸を
 
 先頭二文字で判別
 10-20:5刻み
 21-50:10刻み
 51-99:20刻み
 
 */

//int[] data = {  100, 200, 300, 250, 400, 200};
int[] data = {20,45,4,5,10};
int max = -1;

PFont font;

void setup() {
  size(640, 480); 

font = loadFont("Dialog-48.vlw");
textFont(font);

  //最大値探索
  for (int val : data) {
    if (val>max) max = val;
  }
  println(max);

  //上二桁抽出

  println(len);
  println("n2:"+n2);

  int tic=0;
  int ticNum=0;
  //
  if (10<=n2 && n2<20) {
    tic = 5;
  } else if (20<=n2 && n2<50) {
    tic = 10;
  } else if (50<=n2 && n2 <=99) {
    tic = 20;
  }  
  println("tic:"+tic);

  ticNum= n2/tic;

  tic*=pow(10, len-2);

  println(ticNum);
  println("tic:"+tic);

  //描画
  line(0, height/2, width, height/2);

  for (int n : data) {
    float x =map(n, 0, max, 0.1*width, 0.9*width);
    noStroke();
    fill(200,200,100);
    ellipse(x, height/2, 20, 20);
  }


  println(max);
  for (int i=0; i<=ticNum; i++) {
    float ticPos = map(tic*i, 0, max, 0.1*width, 0.9*width);
    strokeWeight(3);
    stroke(255);
    line(ticPos, height/2-10, ticPos, height/2+10);
    
    textSize(20);
    fill(100);
    text(tic*i,ticPos-20,height/2+50);
  }
}


void draw() {
}



