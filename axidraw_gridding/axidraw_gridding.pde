/*

  WORKSHOP “PROCESSING ET TRACEUR AXIDRAW”
  Du mardi 26 novembre au mercredi 27 novembre 2019 à Stereolux

  https://github.com/v3ga/Workshop_Processing_Axidraw_Stereolux_2019/
 
  —
  
  Julien @v3ga Gachadoat
  www.v3ga.net
  www.2roqs.com
 
*/

// ------------------------------------------------------
import java.util.*;
import processing.svg.*;
import controlP5.*;
import toxi.geom.*;
import toxi.math.*;


// ------------------------------------------------------
// Window dimensions
int windowWidth = 1400;
int windowHeight = 1000;

// Resolution max for grid (both x & y)
int nbGridResMax = 20;
int gridMargin = 40;

// Export folder (relative to sketch)
String strExportFolder = "data/exports/svg/";

// ------------------------------------------------------
Grid grid;

// ------------------------------------------------------
Rect rectColumnLeft, rectGrid, rectColumnRight;

// ------------------------------------------------------
Controls controls;

// ------------------------------------------------------
boolean bExportSVG = false;

// ------------------------------------------------------
void settings()
{
  size(windowWidth,windowHeight);

  float r = 0.25;
  float wRectColumn = r*windowWidth;
  rectColumnLeft = new Rect(0,0,wRectColumn,windowHeight);
  rectColumnRight = new Rect(width-wRectColumn,0,wRectColumn,windowHeight);
  float wRectGrid = width - (rectColumnLeft.width+rectColumnRight.width);
  println(wRectGrid);
  rectGrid = new Rect(wRectColumn,0,wRectGrid,windowHeight);
  println(rectGrid);
  
}

// ------------------------------------------------------
void setupGrid()
{
  grid = new Grid(10,10,rectGrid);
}

// ------------------------------------------------------
void setup()
{
  setupLibraries();
  setupMedias();
  setupGrid();
  setupControls();
}


// ------------------------------------------------------
void draw()
{
  background(255);
  grid.compute();
  if (bExportSVG)
  {
      beginRecord(SVG, strExportFolder + Utils.timestamp() + "_grid.svg");
  }
  grid.draw();
  if (bExportSVG)
  {
    endRecord();
    bExportSVG = false;
  }
  grid.drawField();
  controls.draw();
  drawDebug();
}

// ------------------------------------------------------
void drawDebug()
{
  pushStyle();
  noFill();
  stroke(200,0,0,50);
  rect(rectColumnLeft.x,rectColumnLeft.y,rectColumnLeft.width,rectColumnLeft.height);
  rect(rectColumnRight.x,rectColumnRight.y,rectColumnRight.width,rectColumnRight.height);
  rect(rectGrid.x,rectGrid.y,rectGrid.width,rectGrid.height);
  popStyle();
}


// ------------------------------------------------------
void keyPressed()
{
  if (key == 'c')
  {
    controls.close();
  } else if (key == 'o')
  {
    controls.open();
  }

}
