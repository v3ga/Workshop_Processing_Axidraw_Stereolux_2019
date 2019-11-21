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
boolean bModeDirect = false;

// ------------------------------------------------------
// Colors
boolean bDarkMode = true;

// Colors constants + variables
color COLOR_BLACK = color(0);
color COLOR_WHITE = color(255);
color colorBackground = COLOR_BLACK;
color colorStroke = COLOR_WHITE;

// Window dimensions
int windowWidth = 1400;
int windowHeight = 1000;

// Resolution max for grid (both x & y)
int nbGridResMax = 30;
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
  setupLayout();
  setupColors();
}

// ------------------------------------------------------
void setupLayout()
{

  float r = 0.25;
  float wRectColumn = r*windowWidth;
  rectColumnLeft = new Rect(0,0,wRectColumn,windowHeight);
  rectColumnRight = new Rect(width-wRectColumn,0,wRectColumn,windowHeight);
  float wRectGrid = width - (rectColumnLeft.width+rectColumnRight.width);
  rectGrid = new Rect(wRectColumn,0,wRectGrid,windowHeight);
}


// ------------------------------------------------------
void setupColors()
{
    colorBackground = bDarkMode ? COLOR_BLACK : COLOR_WHITE;
    colorStroke = bDarkMode ? COLOR_WHITE : COLOR_BLACK;
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
  
  grid.selectGridCellRenderWithIndex(0);
  grid.selectGridFieldWithIndex(0);
}


// ------------------------------------------------------
void draw()
{
  background(colorBackground);
  drawLayout();
  grid.compute();
  grid.drawField();
  beginExportSVG();
  grid.draw();
  endExportSVG();
  controls.draw();
  //drawDebug();
}

// ------------------------------------------------------
void beginExportSVG()
{
  if (bExportSVG)
      beginRecord(SVG, strExportFolder + Utils.timestamp() + "_grid.svg");
}

// ------------------------------------------------------
void endExportSVG()
{
  if (bExportSVG)
  {
    endRecord();
    bExportSVG = false;
  }
}


// ------------------------------------------------------
void drawLayout()
{
  pushStyle();
  noStroke();
  fill(0);
  rect(rectColumnLeft.x,rectColumnLeft.y,rectColumnLeft.width,rectColumnLeft.height);
  rect(rectColumnRight.x,rectColumnRight.y,rectColumnRight.width,rectColumnRight.height);
  popStyle();
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
