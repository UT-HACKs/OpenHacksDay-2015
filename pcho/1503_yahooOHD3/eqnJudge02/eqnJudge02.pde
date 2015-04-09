/*

02 入力した数式も表示されるように
 
 01
 string "2+3=6"にターゲットを絞り，整数"+"整数"="整数を読む
 今は"2+3=6"は与えられてるものとする
 
 00
 手書き数式の正誤判定をArduinoに流す
 
 */


String target = "5+4=10";//これを構文解析
//今は手で与えているが，将来的にはこれが送られてくる

int add1, add2, sum;//2,3,6をここに格納

boolean result;

PFont font;


void setup() {
  size(200, 300);
  
  //fontの準備
  font = loadFont("Serif-48.vlw");
  textFont(font);
  text(target,40,50);

//演算子で区切る
  String[] side = split(target, '=');
  String[] adds = split(side[0], '+');
  
  //用意したint変数に格納
  sum = parseInt(side[1]);
  add1 = parseInt(adds[0]);
  add2 = parseInt(adds[1]);
  
//正誤判定
if(add1+add2 == sum) result = true;
else result = false;

//描画
  translate(width/2,height/2);
  noFill();
  strokeWeight(10);
if(result) {
  stroke(255,0,0);
  ellipse(0,0,100,100);
}else{
  stroke(0,0,255);
  rotate(radians(45));
  line(-100,0,100,0);
    rotate(radians(90));
  line(-100,0,100,0);
}
  
  
}


void draw() {
}



