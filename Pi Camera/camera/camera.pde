import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core;
import java.util.*;
import java.nio.*;
 
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;
import org.opencv.features2d.*;
import org.opencv.highgui.Highgui;

import org.opencv.core.Scalar;
import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfKeyPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.MatOfDMatch;
import org.opencv.core.CvType;

import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.utils.Converters;
import java.awt.Rectangle;

public Mat matHSV;
public Mat matBGRA;


//Store Images to print out - for demo purposes
PImage img,hsv,colorFilteredImage;

ArrayList<MatOfPoint> contours;
ArrayList<MatOfPoint2f> approximations;
ArrayList<MatOfPoint2f> markers;

void setup(){
  size(600,200);
  //load pi image from camera for demo we'll load from file
  OpenCV opencv = new OpenCV(this, "more.png");
  img = opencv.getSnapshot();
  opencv.useColor(HSB);
  hsv  = opencv.getSnapshot();
  
  //get hsv green hue
  colorMode(HSB, 100);  // Use HSB with scale of 0-100
  color c = color(80,120,120);
  colorMode(RGB);
  int hue = int(map(hue(c), 0, 255, 0, 180));
  println("hue to detect: " + hue);

  Mat thresholdMat = OpenCV.imitate(opencv.getGray());

  //blur the image to reduce noise (for when we take pictures)
  //this is a std value, but can be increase or decrased as needed.
  opencv.blur(5);
  opencv.setGray(opencv.getH().clone());
  
  //if in range will be white. otherwise will be black.
  opencv.inRange(hue-10, hue+10);
  
  colorFilteredImage = opencv.getSnapshot();
  
  //find all areas of the same color
  contours = new ArrayList<MatOfPoint>();
  
  Imgproc.adaptiveThreshold(opencv.getGray(), thresholdMat, 255, Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY_INV, 451, -65);  
  Imgproc.findContours(thresholdMat, contours, new Mat(), Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_NONE);
  approximations = createPolygonApproximations(contours);

//find all boxes
  markers = new ArrayList<MatOfPoint2f>();
  markers = selectMarkers(approximations);

  noLoop();
}

void draw(){
  pushMatrix();
  background(80,120,120);
  scale(0.5);
  image(img, 0, 0);

  noFill();
  smooth();
  strokeWeight(5);
  stroke(0, 255, 0);
  drawContours2f(markers);  
  popMatrix();

  pushMatrix();
  translate(img.width/2, 0);
  strokeWeight(1);
  scale(0.5);
  image(hsv, 0, 0);
  popMatrix();
  
  pushMatrix();
  translate(img.width, 0);
  strokeWeight(1);
  scale(0.5);
  image(colorFilteredImage, 0, 0);
  popMatrix();  
}

ArrayList<MatOfPoint2f> selectMarkers(ArrayList<MatOfPoint2f> candidates) {
  float minAllowedContourSide = 50;
  minAllowedContourSide = minAllowedContourSide * minAllowedContourSide;

  ArrayList<MatOfPoint2f> result = new ArrayList<MatOfPoint2f>();

  for (MatOfPoint2f candidate : candidates) {
    //not a square/rectangle
    if (candidate.size().height != 4) {
      continue;
    } 

    if (!Imgproc.isContourConvex(new MatOfPoint(candidate.toArray()))) {
      continue;
    }

    // eliminate markers where consecutive
    // points are too close together
    float minDist = img.width * img.width;
    Point[] points = candidate.toArray();
    for (int i = 0; i < points.length; i++) {
      Point side = new Point(points[i].x - points[(i+1)%4].x, points[i].y - points[(i+1)%4].y);
      float squaredLength = (float)side.dot(side);
      // println("minDist: " + minDist  + " squaredLength: " +squaredLength);
      minDist = min(minDist, squaredLength);
    }

    //too small
    if (minDist < minAllowedContourSide) {
      continue;
    }

    result.add(candidate);
  }

  return result;
}

ArrayList<MatOfPoint2f> createPolygonApproximations(ArrayList<MatOfPoint> cntrs) {
  ArrayList<MatOfPoint2f> result = new ArrayList<MatOfPoint2f>();

  double epsilon = cntrs.get(0).size().height * 0.01;
  println(epsilon);

  for (MatOfPoint contour : cntrs) {
    MatOfPoint2f approx = new MatOfPoint2f();
    Imgproc.approxPolyDP(new MatOfPoint2f(contour.toArray()), approx, epsilon, true);
    result.add(approx);
  }

  return result;
}

void drawContours2f(ArrayList<MatOfPoint2f> cntrs) {
  for (MatOfPoint2f contour : cntrs) {
    beginShape();
    Point[] points = contour.toArray();

    for (int i = 0; i < points.length; i++) {
      vertex((float)points[i].x, (float)points[i].y);
    }
    endShape(CLOSE);
  }
}