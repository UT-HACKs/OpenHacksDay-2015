/*

04(開発中)

p1 ★ p2 = p3
形式の正誤判定。ただしintに限る

認識できる数式の種類を増やす。
具体的には，+=*や/の四則を認識できるように

 03(Serial通信ができるようになった)
 結果をArduinoに送信
 （参照）1412ArduinoOhkawaのSerialTest1を
 
 02 入力した数式も表示されるように
 
 01
 string "2+3=6"にターゲットを絞り，整数"+"整数"="整数を読む
 今は"2+3=6"は与えられてるものとする
 
 00
 手書き数式の正誤判定をArduinoに流す
 
 */
import processing.serial.*;

Serial arduino;

String target = "5+5=9";//これを構文解析
//今は手で与えているが，将来的にはこれが送られてくる

int p1, p2, p3;//2,3,6をここに格納

boolean result;

PFont font;


void setup() {
  size(200, 300);

  //Arduino初期化  
  arduino = new Serial(this, "/dev/tty.usbmodemfd121", 9600);


  //fontの準備
  font = loadFont("Serif-48.vlw");
  textFont(font);
  text(target, 40, 50);

  //演算子で区切る
  String[] side = split(target, '=');
  String[] ps = split(side[0], '+');

  //用意したint変数に格納
  p3 = parseInt(side[1]);
  p1 = parseInt(ps[0]);
  p2 = parseInt(ps[1]);

  //正誤判定
  if (p1+p2 == p3) result = true;
  else result = false;

//まるばつ表示
drawResult(result);

}


void draw() {
  if (result)  arduino.write(1);
  else arduino.write(0);
}

//画面中心に○×表示
void drawResult(boolean result){
    //描画
  translate(width/2, height/2);
  noFill();
  strokeWeight(10);
  if (result) {
    stroke(255, 0, 0);
    ellipse(0, 0, 100, 100);
  } else {
    stroke(0, 0, 255);
    rotate(radians(45));
    line(-100, 0, 100, 0);
    rotate(radians(90));
    line(-100, 0, 100, 0);
  }
  
}
