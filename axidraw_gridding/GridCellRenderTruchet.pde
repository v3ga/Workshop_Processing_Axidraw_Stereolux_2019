class GridCellRenderTruchet extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  int[][] random;

  // ----------------------------------------------------------
  // Controls

  // ----------------------------------------------------------
  GridCellRenderTruchet(Grid grid)
  {
    super("Truchet", grid);
    this.grid = grid;
    this.bDrawDirect = true;
    this.bDrawPolygon = false;
  }

  // ----------------------------------------------------------
  void createControls()
  {
    int margin = 5;
    int wControl = int(rectColumnRight.width - 2*margin)-60;
    int hControl = 20;
    int padding = 10;
    int x = 5;
    int y = 10;

    ControlP5 cp5 = controls.cp5;
    g = cp5.addGroup(this.name).setBackgroundHeight(400).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, 10);

    cp5.setBroadcast(true);
  }

  // ----------------------------------------------------------
  public void controlEvent(CallbackEvent theEvent) 
  {
    switch(theEvent.getAction()) 
    {
    case ControlP5.ACTION_RELEASED: 
    case ControlP5.ACTION_RELEASEDOUTSIDE: 
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();
      //      println(name + "/"+value);
      break;
    }
  }

  // ----------------------------------------------------------
  void computeDirect()
  {
    int i, j, offset;
    this.random = new int[this.grid.resx][this.grid.resy];
    
    for (j=0; j<this.grid.resy; j++)
    {
      for (i=0; i<this.grid.resx; i++)
      {
        this.random[i][j] = int(random(4));
      }
    }
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
  
    if (random[i][j] == 0)
    {
      line(x,y,x+w,y+h);
    }
    else if (random[i][j] == 1)
    {
      line(x,y+h,x+w,y);
    }
    else if (random[i][j] == 2)
    {
      line(x+w/2,y,x+w/2,y+h);
    }
    else if (random[i][j] == 3)
    {
      line(x,y+h/2,x+w,y+h/2);
    }
  }
}
