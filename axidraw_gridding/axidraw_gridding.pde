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
Controls controls;

// ------------------------------------------------------
Grid grid;

// ------------------------------------------------------
String strExportFolder = "data/exports/svg/";
boolean bExportSVG = false;

// ------------------------------------------------------
void settings()
{
  size(297*4,210*4);
}

// ------------------------------------------------------
void setupGrid()
{
  grid = new Grid(10,10,60);
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
  controls.draw();
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
