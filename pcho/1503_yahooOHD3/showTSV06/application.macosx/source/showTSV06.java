import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class showTSV06 extends PApplet {

/*

 06(mode\u30c1\u30a7\u30f3\u30b8\u3057\u3066\u6b32\u3057\u3044\u30b0\u30e9\u30d5\u3092\u51fa\u529b\uff1a\u89aa03)
 \u30fbjpg\u51fa\u529b\u6a5f\u80fd
 \u30fb\u6700\u5927\u5024\u30b9\u30b1\u30fc\u30ea\u30f3\u30b0\u6a5f\u80fd
 
 03
 \u4e0a\u4e0b\u3067\u30b0\u30e9\u30d5\u30e2\u30fc\u30c9\u5909\u66f4
 
 02
 \u5de6\u53f3key\u3067\u79fb\u52d5
 
 *n\u5217\u76ee\u3092\u68d2\u30b0\u30e9\u30d5\u3068\u3057\u3066\u8868\u793a
 *\u6ed1\u3089\u304b\u306b\u88dc\u5b8c\u3057\u3066\u8868\u793a
 *\u6563\u5e03\u56f3
 
 01
 tsv\u3092\u8aad\u3093\u3067\u4f55\u304b\u3092\u8868\u793a\u3059\u308b
 
 */


FloatTable data;
int columnCount, rowCount;

int curCol=0;
int mode=0;

PFont font;

float max1, max2;

int w, h;

public void setup() {
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


public void draw() {
  background(255);

  //\u6587\u5b57\u306f\u30c7\u30ab\u30eb\u30c8\u5ea7\u6a19\u306b\u306a\u308b\u524d\u306b
  //fill(255, 0, 0);
  //text(curCol, w-80, 80);

  //\u30c7\u30ab\u30eb\u30c8\u5ea7\u6a19\u5316\u51e6\u7406
  Cartesianize();

  String colName=data.getColumnName(curCol);

  //\u8ef8\u306e\u540d\u524d
  textSize(24);
  invText(colName, width-150, -30);



  //\u63cf\u753b
  String modeName="";
  switch(mode%3) {
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
    drawScatter(curCol, 1);
    modeName="SCATTER";
    break;
  }

  //\u30e2\u30fc\u30c9\u540d
  fill(0);
  textSize(36);
  invText(modeName, 0.5f*w, 0.8f*h);

  //  drawBar(curCol); 
  //drawPoly(curCol);
  //drawScatter(curCol, 2);
}

//png\u51fa\u529b
public void mousePressed() {
  mySave();
  //textSize(50);
  //tint(100,100,100);
  //invText("Saved!", w*0.1, h/3);
}

//mouse\u3068ENTER
public void mySave() {
  save("fig/graph.png");
  println("saved!");
}


//\u30c7\u30ab\u30eb\u30c8\u5ea7\u6a19\u3067\u4e0a\u4e0b\u53cd\u8ee2\u72b6\u614b\u3067\u3082\u6b63\u7acb\u306e\u6587\u5b57\u3092\u8868\u793a
public void invText(String str, float x, float y) {

  pushMatrix();
  translate(x, y);
  scale(1, -1);
  text(str, 0, 0);
  popMatrix();
}


//\u30c7\u30ab\u30eb\u30c8\u5ea7\u6a19\u5316\uff0c\u8ef8\u306e\u63cf\u753b
public void Cartesianize() {

  //\u30c7\u30ab\u30eb\u30c8\u5ea7\u6a19\u5316
  //translate(0, height);
  translate(w/10, h-h/10);
  scale(1, -1);

  //\u30b0\u30e9\u30d5\u306e\u8ef8
  stroke(0);
  strokeWeight(5);
  int tic = 100;
  //x\u8ef8
  line(-w/20, 0, w-3*w/20, 0);
  line(w-3*w/20, 0, w-3*w/20-10, 10);
  line(w-3*w/20, 0, w-3*w/20-10, -10);

  for (int i=1; i<w/tic; i++) {
    line(tic*i, -10, tic*i, 10);
  }
  //y\u8ef8
  line(0, -h/20, 0, h-3*h/20);
  line(0, h-3*h/20, 10, h-3*h/20-10);
  line(0, h-3*h/20, -10, h-3*h/20-10);
  for (int i=1; i<h/tic; i++) {
    line(-10, tic*i, 10, tic*i);
  }
}

//\u5de6\u53f3\u30ad\u30fc\u3067\u5217\u3092\u884c\u304d\u6765
public void keyPressed() {

  if (key==CODED) {
    if (keyCode==RIGHT)  curCol++; 
    if (keyCode==LEFT)   curCol--;
    if (keyCode==UP)  mode++; 
    if (keyCode==DOWN)   mode--;
    if (keyCode==ENTER) mySave();
  }

  //\u5883\u754c\u3092\u8d85\u3048\u306a\u3044
  if (curCol<0)curCol+=columnCount;
  if (curCol>=columnCount)curCol-=columnCount;
}

//\u4e8c\u8ef8\u6307\u5b9a\u306e\u6563\u5e03\u56f3
public void drawScatter(int col1, int col2) {

  for (int row = 0; row<rowCount; row++) {

    float val1 = data.getFloat(row, col1); 
    float val2 = data.getFloat(row, col2); 
    fill(curCol*100, 200, 200);
    noStroke();
    ellipse(val1, val2, 10, 10);
  }
}

//\u6298\u7dda
public void drawPoly(int col) {

  //\u6700\u5927\u5024\u63a2\u7d22  
  max1=-1;
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    if (max1<val)max1=val;
  }
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
    vertex(row*50, val/max1*0.6f*w);
  }
  endShape();
}

//\u5358\u8272\u68d2\u30b0\u30e9\u30d5\u306e\u8868\u793a
public void drawBar(int col) {

  //\u6700\u5927\u5024\u63a2\u7d22      
  max1=-1;
  for (int row = 0; row<rowCount; row++) {
    float val = data.getFloat(row, col);
    if (max1<val)max1=val;
  }

  int rowCount = data.getRowCount();
  for (int row = 0; row<rowCount; row++) {

    float val = data.getFloat(row, col);
    fill(50*col, 200, 200);
    noStroke();
    rect(row*50, 0, 40, val/max1*0.6f*w);
  }
}


//\u30b5\u30f3\u30d7\u30eb\u3067\u4f5c\u3063\u3066\u307f\u305f\u3060\u3051
public void drawData() {
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

// first line of the file should be the column headers
// first column should be the row titles
// all other values are expected to be floats
// getFloat(0, 0) returns the first data value in the upper lefthand corner
// files should be saved as "text, tab-delimited"
// empty rows are ignored
// extra whitespace is ignored


class FloatTable {
  int rowCount;
  int columnCount;
  float[][] data;
  String[] rowNames;
  String[] columnNames;
  
  
  FloatTable(String filename) {
    String[] rows = loadStrings(filename);
    
    String[] columns = split(rows[0], TAB);
    columnNames = subset(columns, 1); // upper-left corner ignored
    scrubQuotes(columnNames);
    columnCount = columnNames.length;

    rowNames = new String[rows.length-1];
    data = new float[rows.length-1][];

    // start reading at row 1, because the first row was only the column headers
    for (int i = 1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      scrubQuotes(pieces);
      
      // copy row title
      rowNames[rowCount] = pieces[0];
      // copy data into the table starting at pieces[1]
      data[rowCount] = parseFloat(subset(pieces, 1));

      // increment the number of valid rows found so far
      rowCount++;      
    }
    // resize the 'data' array as necessary
    data = (float[][]) subset(data, 0, rowCount);
  }
  
  
  public void scrubQuotes(String[] array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i].length() > 2) {
        // remove quotes at start and end, if present
        if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
          array[i] = array[i].substring(1, array[i].length() - 1);
        }
      }
      // make double quotes into single quotes
      array[i] = array[i].replaceAll("\"\"", "\"");
    }
  }
  
  
  public int getRowCount() {
    return rowCount;
  }
  
  
  public String getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }
  
  
  public String[] getRowNames() {
    return rowNames;
  }

  
  // Find a row by its name, returns -1 if no row found. 
  // This will return the index of the first row with this name.
  // A more efficient version of this function would put row names
  // into a Hashtable (or HashMap) that would map to an integer for the row.
  public int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (rowNames[i].equals(name)) {
        return i;
      }
    }
    //println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  // technically, this only returns the number of columns 
  // in the very first row (which will be most accurate)
  public int getColumnCount() {
    return columnCount;
  }
  
  
  public String getColumnName(int colIndex) {
    return columnNames[colIndex];
  }
  
  
  public String[] getColumnNames() {
    return columnNames;
  }


  public float getFloat(int rowIndex, int col) {
    // Remove the 'training wheels' section for greater efficiency
    // It's included here to provide more useful error messages
    
    // begin training wheels
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    // end training wheels
    
    return data[rowIndex][col];
  }
  
  
  public boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(data[row][col]);
  }
  
  
  public float getColumnMin(int col) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (!Float.isNaN(data[i][col])) {
        if (data[i][col] < m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }

  
  public float getColumnMax(int col) {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (isValid(i, col)) {
        if (data[i][col] > m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }

  
  public float getRowMin(int row) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < columnCount; i++) {
      if (isValid(row, i)) {
        if (data[row][i] < m) {
          m = data[row][i];
        }
      }
    }
    return m;
  } 

  
  public float getRowMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int i = 1; i < columnCount; i++) {
      if (!Float.isNaN(data[row][i])) {
        if (data[row][i] > m) {
          m = data[row][i];
        }
      }
    }
    return m;
  }
  
  
  public float getTableMin() {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] < m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }

  
  public float getTableMax() {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] > m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "showTSV06" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
