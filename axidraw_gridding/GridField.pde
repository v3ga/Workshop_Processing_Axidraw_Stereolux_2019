class GridField
{
  String name = "";
  Grid grid;
  Group g;

  // ----------------------------------------------------------
  GridField(String name, Grid grid)
  {
    this.name = name;
    this.grid = grid;
  }

  // ----------------------------------------------------------
  void createControls()
  {
  }
  
  // ----------------------------------------------------------
  String _id(String s)
  {
    return this.name+"_"+s;
  }
  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    return 0.0;
  }

  // ----------------------------------------------------------
  void draw()
  {
  }
}

// ----------------------------------------------------------
class GridFieldSine extends GridField implements CallbackListener
{
  float nbPeriod = 1;
  Slider sliderNbPeriod;

  // ----------------------------------------------------------
  GridFieldSine(Grid grid)
  {
    super("Sine", grid);
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
    g = cp5.addGroup(this.name).setBackgroundHeight(400).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, height-400);

    cp5.setBroadcast(false);
    sliderNbPeriod = cp5.addSlider( _id("nbPeriod") ).setLabel("period").setPosition(x, y).setSize(wControl, hControl).setRange(0.5, 4).setValue(this.nbPeriod).setGroup(g).addCallback(this);
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
      //      println(name + "/"+value);
      if (name.equals( _id("nbPeriod") ) )
      {
        this.nbPeriod = value;
        this.grid.bComputeGridVec = true;
      }
      break;
    }
  }


  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    float cx = this.grid.x + 0.5*this.grid.w;
    float cy = this.grid.y + 0.5*this.grid.h;
    float dx = dist(x, cy, cx, cy);
    float d = dist(x, y, cx, cy) / (0.5*this.grid.w);
    return map( sin( d * TWO_PI * this.nbPeriod ), -1, 1, 0, 1 );
  }
}
