class GridCellRenderTruchet extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  // Scale along x,y axis

  // ----------------------------------------------------------
  // Controls

  // ----------------------------------------------------------
  GridCellRenderTruchet()
  {
    super("Truchet");
  }

  // ----------------------------------------------------------
  GridCellRenderTruchet(String name)
  {
    super(name);
  }

  // ----------------------------------------------------------
  int getValueInt(float rx, float ry,  float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    int r = getValueInt(rect.x,rect.y,0.0,3.0);

    pushMatrix();
    translate(x,y);

    if (r == 0)
    {
      line(0, 0, w, h);
    } else if (r == 1)
    {
      line(0, h, w, 0);
    } else if (r == 2)
    {
      line(w/2, 0, w/2, h);
    } else if (r == 3)
    {
      line(0, h/2, w, h/2);
    }
    popMatrix();
  }

  // ----------------------------------------------------------
  public void controlEvent(CallbackEvent theEvent) 
  {
  }
}



// ----------------------------------------------------------
class GridCellRenderSpaghetti extends GridCellRenderTruchet
{
  float scale = 1.0;
  Slider sliderScale;
  // ----------------------------------------------------------
  GridCellRenderSpaghetti()
  {
    super("Spaghetti");
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    int r = getValueInt(rect.x,rect.y,0.0,1.0);

    pushMatrix();
    translate(x,y);

    if (r == 0)
    {
      arc(w,0,w*scale,h*scale,radians(90), radians(180));
      arc(0,h,w*scale,h*scale,radians(-90), radians(0));
    } else if (r == 1)
    {
      arc(0,0,w*scale,h*scale,radians(0), radians(90));
      arc(w,h,w*scale,h*scale,radians(180), radians(270));
    } 
    
    popMatrix();
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
    g = cp5.addGroup(this.name).setBackgroundHeight(400).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridCellRenderControls);

    sliderScale = cp5.addSlider( _id("scale") ).setLabel("scale").setPosition(x, y).setSize(wControl, hControl).setRange(0.2, 2).setValue(this.scale).setGroup(g).addCallback(this);
    y+=(hControl+padding);


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
      if (name.equals( _id("scale") ) )
      {
        this.scale = value;
        this.grid.bComputeGridVec = true;
      }
      break;
    }
  }
}

// ----------------------------------------------------------
class GridCellRenderSpaghettiOrtho extends GridCellRenderTruchet
{
  float scale = 1.0;
  Slider sliderScale;
  // ----------------------------------------------------------
  GridCellRenderSpaghettiOrtho()
  {
    super("SpaghettiOrtho");
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    int r = getValueInt(rect.x,rect.y,0.0,3.0);

    pushMatrix();
    translate(x,y);

    if (r == 0)
    {
      arc(w,0,w*scale,h*scale,radians(90), radians(180));
      arc(0,h,w*scale,h*scale,radians(-90), radians(0));
    } 
    else if (r == 1)
    {
      arc(0,0,w*scale,h*scale,radians(0), radians(90));
      arc(w,h,w*scale,h*scale,radians(180), radians(270));
    } 
    else if (r == 2)
    {
        line(w/2,0,w/2,h);
//      line(w/2,0,w,h/2);
//      line(0,h/2,w/2,h);
    } 
    else if (r == 3)
    {
        line(0,h/2,w,h/2);
//      line(w/2,0,0,h/2);
//      line(w,h/2,w/2,h);
    } 
    
    popMatrix();
  }
}
