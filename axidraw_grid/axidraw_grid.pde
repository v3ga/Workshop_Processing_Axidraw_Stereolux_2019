/*

 Processing & Axidraw 
 Mardi 26 et Mercredi 27 novembre 2019
 Stereolux, Nantes
 https://github.com/v3ga/Workshop_Processing_Axidraw_Stereolux_2019
 
 —
 
 Julien @v3ga Gachadoat
 
 with contributions by : 
 + Laurent @__vac__ Novac
 + Antoine @aguillien Guillien
 + Laurent @lebourhl Le Bouris
 
 —
 
 www.instagram.com/julienv3ga/
 https://twitter.com/v3ga
 www.2roqs.com
 www.v3ga.net
 
 */

// ------------------------------------------------------
import java.util.*;
import processing.svg.*;
import controlP5.*;
import toxi.geom.*;
import toxi.math.*;

// ------------------------------------------------------
boolean bModeDirect = true;

// ------------------------------------------------------
boolean bDarkMode = true;

// ------------------------------------------------------
boolean bDrawDebug = false;

// Colors constants + variables
color COLOR_BLACK = color(0);
color COLOR_WHITE = color(255);
color colorBackground = COLOR_BLACK;
color colorStroke = COLOR_WHITE;

// Window dimensions
int windowWidth = 1280;
int windowHeight = 720;

// Resolution max for grid (both x & y)
int nbGridResMax = 30;
int gridMargin = 40;

// Export folder (relative to sketch)
String strExportFolder = "data/exports/svg/";

// Controls
float yGridFieldControls = 200; 
int hGridFieldControls = 200;
float yGridCellRenderControls = 0;

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
  size(windowWidth, windowHeight);
  setupLayout();
  setupColors();
}

// ------------------------------------------------------
void setupGrid()
{
  // Create the grid
  grid = new Grid(10, 10, rectGrid);

  // Add renderers + fields
  // Undirect / polygon mode
  grid.addGridCellRenderPolygon( new GridCellRenderEllipse()  );
  grid.addGridCellRenderPolygon( new GridCellRenderQuad()  );

  // Direct mode 
  grid.addGridCellRenderDirect( new GridCellRenderArnaud() );
  grid.addGridCellRenderDirect( new GridCellRenderTruchetCaroA() );
  grid.addGridCellRenderDirect( new GridCellRenderTruchetCaroD() );
  grid.addGridCellRenderDirect( new GridCellRenderStereolux1() );
  grid.addGridCellRenderDirect( new GridCellRenderThomas() );
  grid.addGridCellRenderDirect( new GridCellRenderNoiseGlyphs() );
  grid.addGridCellRenderDirect( new GridCellRenderSecond() );
  grid.addGridCellRenderDirect( new GridCellRenderSpiro() );
  grid.addGridCellRenderDirect( new GridCellRenderToinou() );
  grid.addGridCellRenderDirect( new GridCellRenderCedric() );
  

  
  

  grid.addGridCellRenderDirect( new GridCellRenderTruchet() );
  grid.addGridCellRenderDirect( new GridCellRenderSpaghetti() );
//  grid.addGridCellRenderDirect( new GridCellRenderTemplate() );
  
  //grid.addGridCellRenderDirect( new GridCellRenderSpaghettiOrtho() );
  //grid.addGridCellRenderDirect( new GridCellRenderVera() );

  // Fields
  grid.addGridField( new GridFieldConstant() );
  grid.addGridField( new GridFieldGradientVertical() );
  grid.addGridField( new GridFieldSine() );
  grid.addGridField( new GridFieldNoise() );
  grid.addGridField( new GridFieldRandom() );

  // Configuration
  grid.loadConfiguration("default");
}

// ------------------------------------------------------
void setup()
{
  setupLibraries();
  setupMedias();
  setupGrid();
  setupControls();

//  grid.selectGridCellRenderWithIndex(0);
//  grid.selectGridFieldWithIndex(0);
  grid.bUpdateControls = true;
}

// ------------------------------------------------------
void setupColors()
{
  colorBackground = bDarkMode ? COLOR_BLACK : COLOR_WHITE;
  colorStroke = bDarkMode ? COLOR_WHITE : COLOR_BLACK;
}

// ------------------------------------------------------
void setupLayout()
{

  float r = 0.25;
  float wRectColumn = r*windowWidth;
  rectColumnLeft = new Rect(0, 0, wRectColumn, windowHeight);
  rectColumnRight = new Rect(width-wRectColumn, 0, wRectColumn, windowHeight);
  float wRectGrid = width - (rectColumnLeft.width+rectColumnRight.width);
  rectGrid = new Rect(wRectColumn, 0, wRectGrid, windowHeight);
/*
  float wRectColumn = 0.3*windowWidth;
  rectColumnLeft = new Rect(0, 0, wRectColumn, windowHeight);
  
  float wRectColumnRight = 0.2*windowWidth;
  rectColumnRight = new Rect(width-wRectColumnRight, 0, wRectColumnRight, windowHeight);

  float wRectGrid = 0.5*windowWidth;
  rectGrid = new Rect(wRectColumn, 0, wRectGrid, windowHeight);
*/
}

// ------------------------------------------------------
void setupMedias()
{
}

// ------------------------------------------------------
void setupLibraries()
{
}

// ------------------------------------------------------
void draw()
{
  background(colorBackground);
  drawLayout();
  grid.drawField();
  grid.compute();
  beginExportSVG();
  grid.draw();
  endExportSVG();
  grid.updateControls();
  controls.draw();
  drawDebug();
}

// ------------------------------------------------------
void drawLayout()
{
  pushStyle();
  noStroke();
  fill(0);
  rect(rectColumnLeft.x, rectColumnLeft.y, rectColumnLeft.width, rectColumnLeft.height);
  rect(rectColumnRight.x, rectColumnRight.y, rectColumnRight.width, rectColumnRight.height);
  popStyle();
}

// ------------------------------------------------------
void drawDebug()
{
  if (bDrawDebug)
  {
    pushStyle();
    noFill();
    stroke(200, 0, 0, 50);
    rect(rectColumnLeft.x, rectColumnLeft.y, rectColumnLeft.width, rectColumnLeft.height);
    rect(rectColumnRight.x, rectColumnRight.y, rectColumnRight.width, rectColumnRight.height);
    rect(rectGrid.x, rectGrid.y, rectGrid.width, rectGrid.height);
    popStyle();
  }
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
void keyPressed()
{
  if (key == 'c')
  {
    controls.close();
  }
  else if (key == 'o')
  {
    controls.open();
  }
  else if (key == 'e')
  {
    exportSVG();
  }
  else if (key == 's')
  {
    saveFrame("data/exports/images/interface.png");
  }
}
