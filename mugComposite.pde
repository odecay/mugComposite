import java.awt.*;
import hypermedia.video.*;
import java.io.*;
import java.util.Random;
OpenCV opencv;
PImage[] mugs;
String[] mugsNames;
float transperancy = 100;
float transpStep;
float totalFaceWidth;
float avgFaceWidth;
int avgFaceNum=0;
float newFaceScaleX;
float newFaceScaleY;
int sucess = 0;

String[] getFileNames(String directory){
  File file = new File(directory);
  if(file.isDirectory()){
    String[] Names = file.list();
    return Names;
  }
  else {
    return null;
  }
}

float offsetX(float x, float w){ 
  float offsetX = width - (w/2 + x);
  return offsetX;
}

float offsetY(float y, float h){
  float offsetY =  height - (h/2 + y);
  return offsetY;
}

void chomp(PImage img){
  int xDiff;
  int yDiff;
  opencv.allocate(width,height);
  opencv.copy(img);
  opencv.cascade("C:\\Program Files (x86)\\OpenCV\\data\\haarcascades\\haarcascade_frontalface_alt.xml");
  Rectangle[] faceBox = opencv.detect();
  if(faceBox.length > 0){
  
    sucess ++;
    avgFaceNum += 1;
    totalFaceWidth += faceBox[0].width;
    avgFaceWidth = totalFaceWidth/avgFaceNum;
    newFaceScaleX = width + width*((avgFaceWidth-faceBox[0].width)/100);
    newFaceScaleY = height + height*((avgFaceWidth-faceBox[0].height)/100);
    //offsetX = (width/2 - avgFaceWidth/2)/2;
    //println(newFaceScaleX);
    image(opencv.image(),offsetX(faceBox[0].x,faceBox[0].width),offsetY(faceBox[0].y,faceBox[0].height),newFaceScaleX,newFaceScaleY);
    println(sucess);
    //print("facebox");
    //print(faceBox[0].x);
    //println(faceBox[0].y);
    //print(faceBox[0].width);
    //println(faceBox[0].height);
  }
    
  
}

void setup(){
  imageMode(CENTER);
  opencv = new OpenCV(this);
  map(transperancy, 0, 100, 0, 255);
  mugsNames = getFileNames("C:\\Users\\otis\\Documents\\Processing\\mugComposite\\data");
  mugs = new PImage[mugsNames.length];
  
  for (int i = 0; i < mugsNames.length; i ++){
    mugs[i] = loadImage(mugsNames[i]);
  }
  size(mugs[0].width,mugs[0].height);
  transpStep = 100.0/mugs.length;
 
  for(int i = 0; i<mugs.length; i ++){
    tint(255, transperancy);
    transperancy -= transpStep;
    //print("transperancy"+transperancy);
    chomp(mugs[i]);
    //image(mugs[i],0,0);
    //Rectangle[] faceBox = opencv.detect();
    //print(faceBox);
    //print(transperancy);
  }
  println("number of images rendered" + sucess);
  //println(transpStep);
  print ("length"+mugs.length);
  saveFrame("hamp12.tif");
}


void draw(){
}
