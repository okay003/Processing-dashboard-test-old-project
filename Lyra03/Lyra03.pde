String [][] csv;
String [] prjName;
float [][] numData;
String csvPath="../test2.csv";

int rangeXBottom=200;
int rangeXTop=1280-rangeXBottom;
int rangeYTop=200;
int rangeYBottom=720-rangeYTop;
int diaBottom=50;
int diaTop=100;
int margin=50;

float [][] diameter;

void setup() {
  size(1280, 720);
  ellipseMode(RADIUS);

  //set prjName array, numData array
  csv=csv2array(csvPath);
  prjName=new String[csv.length-1];
  numData=new float[csv.length-1][csv[1].length -1];
  for (int i=1; i<csv.length; i++) {
    for (int j=0; j<csv[i].length; j++) {
      if (j==0)
        prjName[i-1]=csv[i][j];
      else
        numData[i-1][j-1]=float(csv[i][j]);
    }
  }
  diameter=new float[csv.length-1][csv.length-1];
}

void draw() {
  //axis
  line(rangeXBottom-getDia(0)-margin, rangeYBottom+getDia(0)+margin, rangeXTop+getDia(numData.length-1)+margin, rangeYBottom+getDia(0)+margin);
  line(rangeXBottom-getDia(0)-margin, rangeYBottom+getDia(0)+margin, rangeXBottom-getDia(0)-margin, rangeYTop-getDia(numData.length-1)-margin);

  //regression
  //https://ytake2.github.io/Rsite/_site/lec3.html
  float aveX=0;
  float aveY=0;
  float varX=0;
  float varXY=0;
  float a=0;
  float b=0;
  float x0=0;
  float y0=0;
  float x1=0;
  float y1=0;
  for (int i=0; i<numData.length; i++) {
    aveX+=numData[i][0];
    aveY+=numData[i][2];
  }
  aveX=aveX/numData.length;
  aveY=aveY/numData.length;
  for (int i=0; i<numData.length; i++) {
    varX+=sq((numData[i][0]-aveX));
    varXY+=(numData[i][0]-aveX)*(numData[i][2]-aveY);
  }
  b=varXY/varX;
  a=aveY-b*aveX;
  x0=map(numData[0][0], numData[0][0], numData[numData.length-1][0], rangeXBottom, rangeXTop);
  x1=map(numData[numData.length-1][0], numData[0][0], numData[numData.length-1][0], rangeXBottom, rangeXTop);
  y0=a+b*numData[0][0];
  y1=a+b*numData[numData.length-1][0];
  y0=map(y0, numData[0][2], numData[numData.length-1][2], rangeYBottom, rangeYTop);
  y1=map(y1, numData[0][2], numData[numData.length-1][2], rangeYBottom, rangeYTop);

  //plot
  float dMin=getDia(0);
  float dMax=getDia(0);
  for (int i=0; i<numData.length; i++) {
    if (dMin>getDia(i))
      dMin=getDia(i);
    if (dMax<getDia(i))
      dMax=getDia(i);
  }
  for (int i=0; i<numData.length; i++) {
    float x=map(numData[i][0], numData[0][0], numData[numData.length-1][0], rangeXBottom, rangeXTop);
    float y=map(numData[i][2], numData[0][2], numData[numData.length-1][2], rangeYBottom, rangeYTop);
    diameter[i][1]=map(getDia(i), dMin, dMax, 20, 80);
    if(diameter[i][0]<diameter[i][1]) {
      println(i);
      diameter[i][0]++;
    }
    if (numData[i][2]>a+b*numData[i][0]) {
      ellipse(x, y, diameter[i][0], diameter[i][0]);
      fill(255, 0, 0);
    } else {
      ellipse(x, y, diameter[i][0], diameter[i][0]);
      fill(0, 255, 0);
    }
    ellipse(x, y, 1, 1);
  }
  line(x0, y0, x1, y1);
}

//in:.csv, out:2d string array
//https://www.atnr.net/processing%E3%81%A7csv%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%80%E6%96%B9%E6%B3%95/
String[][] csv2array(String path) {
  String [][] csv;
  int collen=0;
  String row[] = loadStrings(path);

  for (int i=0; i < row.length; i++) { 
    String [] element=split(row[i], ","); 
    if (element.length>collen) {
      collen=element.length;
    }
  }
  csv = new String [row.length][collen];
  for (int i=0; i < row.length; i++) {
    String [] temp = new String [row.length];
    temp= split(row[i], ",");
    for (int j=0; j < temp.length; j++) {
      csv[i][j]=temp[j];
    }
  }
  return csv;
}

//return diameter
float getDia(int i) {
  float d=map(numData[i][2]/(numData[i][1]-numData[i][0]), numData[0][2]/(numData[0][1]-numData[0][0]), numData[numData.length-1][2]/(numData[numData.length-1][1]-numData[numData.length-1][0]), diaBottom, diaTop);
  return d;
}
