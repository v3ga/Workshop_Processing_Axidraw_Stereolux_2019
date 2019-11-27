class GridField
{
  String name = "";
  Grid grid;
  Group g;

  // ----------------------------------------------------------
  GridField(String name)
  {
    this.name = name;
  }

  // ----------------------------------------------------------
  void createControls()
  {
  }

  // ----------------------------------------------------------
  void showControls()
  {
    if (g!=null)
      g.show();
  }

  // ----------------------------------------------------------
  void hideControls()
  {
    if (g!=null)
      g.hide();
  }

  // ----------------------------------------------------------
  String _id(String s)
  {
    return this.name+"_"+s;
  }

  // ----------------------------------------------------------
  float getValue(Vec2D p)
  {
    return this.getValue(p.x, p.y);
  }

  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    return 0.0;
  }

  // ----------------------------------------------------------
  void prepare()
  {
  }

  // ----------------------------------------------------------
  void draw()
  {
  }
}

// ----------------------------------------------------------
class GridFieldConstant extends GridField implements CallbackListener
{
  float value = 0.5;
  Slider sliderValue;

  // ----------------------------------------------------------
  GridFieldConstant()
  {
    super("Constant");
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
    g = cp5.addGroup(this.name).setBackgroundHeight(hGridFieldControls).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridFieldControls);

    cp5.setBroadcast(false);
    sliderValue = cp5.addSlider( _id("value") ).setLabel("value").setPosition(x, y).setSize(wControl, hControl).setRange(0, 1).setValue(this.value).setGroup(g).addCallback(this);
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
      float val = theEvent.getController().getValue();
      //      println(name + "/"+value);
      if (name.equals( _id("value") ) )
      {
        this.value = val;
        this.grid.bComputeGridVec = true;
      }
      break;
    }
  }


  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    return this.value;
  }
}

// ----------------------------------------------------------
class GridFieldRandom extends GridField implements CallbackListener
{
  float[][] random;

  // ----------------------------------------------------------
  GridFieldRandom()
  {
    super("Random");
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
    g = cp5.addGroup(this.name).setBackgroundHeight(hGridFieldControls).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridFieldControls);

    cp5.setBroadcast(false);
    cp5.addButton(_id("generate")).setLabel("generate").setPosition(x, y).setGroup(g).addCallback(this);
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
      float val = theEvent.getController().getValue();
      //      println(name + "/"+value);
      if (name.equals( _id("generate") ) )
      {
        this.grid.bComputeGridVec = true; // will in turn call prepare()
      }
      break;
    }
  }

  // ----------------------------------------------------------
  void prepare()
  {
    println("GridfieldRandom.prepare(), grid.resx="+this.grid.resx+",grid.resy="+this.grid.resy);
    this.random = new float[this.grid.resx][this.grid.resy];
    int i, j;
    for (j=0; j<this.grid.resy; j++)
      for (i=0; i<this.grid.resx; i++)
      {
        this.random[i][j] = random(1.0);
      }
  }

  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    if (this.random != null)
    {
      int i = int ((x-this.grid.x) / this.grid.wCell);
      int j = int ((y-this.grid.y) / this.grid.hCell);
      if (i>=0 && i < this.grid.resx && j>=0 && j < this.grid.resy)
        return  this.random[i][j];
    }
    return 0.0;
  }
}


// ----------------------------------------------------------
class GridFieldSine extends GridField implements CallbackListener
{
  float nbPeriod = 1;
  Vec2D center = new Vec2D(0.5, 0.5);

  Slider sliderNbPeriod;
  Slider2D slider2Dcenter;

  // ----------------------------------------------------------
  GridFieldSine()
  {
    super("Sine");
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
    g = cp5.addGroup(this.name).setBackgroundHeight(hGridFieldControls).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridFieldControls);

    cp5.setBroadcast(false);
    sliderNbPeriod = cp5.addSlider( _id("nbPeriod") ).setLabel("period").setPosition(x, y).setSize(wControl, hControl).setRange(0.5, 4).setValue(this.nbPeriod).setGroup(g).addCallback(this);
    y+=(hControl+padding);
    slider2Dcenter = cp5.addSlider2D( _id("center") ).setLabel("center").setPosition(x, y).setSize(wControl/2-padding, wControl/2-padding).setMinMax(0.0, 0.0, 1.0, 1.0).setValue(center.x, center.y).setGroup(g).addCallback(this);
    y+=(hControl+padding);

    cp5.setBroadcast(true);
  }

  // ----------------------------------------------------------
  public void controlEvent(CallbackEvent theEvent) 
  {
    String name;
    float value;
    switch(theEvent.getAction()) 
    {
    case ControlP5.ACTION_RELEASED: 
    case ControlP5.ACTION_RELEASEDOUTSIDE: 
      name = theEvent.getController().getName();
      value = theEvent.getController().getValue();
      //      println(name + "/"+value);
      if (name.equals( _id("nbPeriod") ) )
      {
        this.nbPeriod = value;
        this.grid.bComputeGridVec = true;
      } else if (name.equals( _id("center") ) )
      {
        center.set(slider2Dcenter.getArrayValue()[0], slider2Dcenter.getArrayValue()[1]);
        this.grid.bComputeGridVec = true;
      }
      break;
    }
  }


  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    float cx = this.grid.x + center.x*this.grid.w;
    float cy = this.grid.y + center.y*this.grid.h;
    float dx = dist(x, cy, cx, cy);
    float d = dist(x, y, cx, cy) / (0.5*this.grid.w);
    return map( sin( d * TWO_PI * this.nbPeriod ), -1, 1, 0, 1 );
  }
}

// ----------------------------------------------------------
class GridFieldNoise extends GridField implements CallbackListener
{
  float nbPeriod = 1;
  float noiseScale = 0.01;
  Slider sliderNoiseScale;

  // ----------------------------------------------------------
  GridFieldNoise()
  {
    super("Perlin Noise");
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
    g = cp5.addGroup(this.name).setBackgroundHeight(hGridFieldControls).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridFieldControls);

    cp5.setBroadcast(false);
    sliderNoiseScale = cp5.addSlider( _id("noiseScale") ).setLabel("noiseScale").setPosition(x, y).setSize(wControl, hControl).setRange(0.000001, 0.01).setValue(this.noiseScale).setGroup(g).addCallback(this);
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
      float val = theEvent.getController().getValue();
      if (name.equals( _id("noiseScale") ) )
      {
        this.noiseScale = val;
      }
      break;
    }
  }

  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
    return noise(this.noiseScale*x, this.noiseScale*y);
  }
}

// ----------------------------------------------------------
class GridFieldGradientVertical extends GridField implements CallbackListener
{
  boolean bReverse = false;
  Toggle tgReverse;
  // ----------------------------------------------------------
  GridFieldGradientVertical()
  {
    super("vertical gradient");
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
    g = cp5.addGroup(this.name).setBackgroundHeight(hGridFieldControls).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, yGridFieldControls);
    tgReverse = cp5.addToggle(_id("reverse")).setLabel("reverse").setPosition(x, y).setSize(hControl, hControl).setValue(bReverse).setGroup(g).addCallback(this);
    y+=(hControl+padding+8);

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
      float val = theEvent.getController().getValue();
      //      println(name + "/"+value);
      if (name.equals( _id("reverse") ) )
      {
        this.bReverse = val > 0.0;
        this.grid.bComputeGridVec = true;
      }
      break;
    }
  }


  // ----------------------------------------------------------
  float getValue(float x, float y)
  {
      return map(y,grid.y, grid.y + grid.h, bReverse ? 0.0 : 1.0, bReverse ? 1.0 : 0.0);
  }
}
