/*

 
 01
 string "2+3=6"にターゲットを絞り，整数"+"整数"="整数を読む
 今は"2+3=6"は与えられてるものとする
 
 00
 手書き数式の正誤判定をArduinoに流す
 
 */


String target = "2+3=6";//これを構文解析
//今は手で与えているが，将来的にはこれが送られてくる

int add1, add2, sum;//2,3,6をここに格納

boolean result;


void setup() {
  size(200, 300);

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
  ellipse(0,0,100,100);
}else{
  rotate(radians(45));
  line(-100,0,100,0);
    rotate(radians(90));
  line(-100,0,100,0);
}
  
  
}


void draw() {
}



