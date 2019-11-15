class GridCellRenderEllipse extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  int ellipseRes = 20;
  float ellipseScalex = 1.0, ellipseScaley = 1.0;

  // ----------------------------------------------------------
  // Controls
  Slider sliderEllipseRes, sliderEllipseScalex, sliderEllipseScaley;

  // ----------------------------------------------------------
  GridCellRenderEllipse(Grid grid)
  {
    super("Ellipses", grid);
    this.grid = grid;
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

    cp5.setBroadcast(false);
    sliderEllipseRes = cp5.addSlider( _id("res") ).setLabel("res").setPosition(x, y).setSize(wControl, hControl).setRange(3, 30).setNumberOfTickMarks(30-2).setValue(this.ellipseRes).setGroup(g).addCallback(this);
    y+=(hControl+padding);
    sliderEllipseScalex = cp5.addSlider( _id("scalex") ).setLabel("scalex").setPosition(x, y).setSize(wControl, hControl).setRange(0.2, 2).setValue(this.ellipseScalex).setGroup(g).addCallback(this);
    y+=(hControl+padding);
    sliderEllipseScaley = cp5.addSlider( _id("scaley") ).setLabel("scaley").setPosition(x, y).setSize(wControl, hControl).setRange(0.2, 2).setValue(this.ellipseScaley).setGroup(g).addCallback(this);

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
      if (name.equals( _id("res") ) )
      {
        this.ellipseRes = int(value);
        this.grid.bComputeGridVec = true;
      } else if (name.equals( _id("scalex") ) )
      {
        this.ellipseScalex = value;
        this.grid.bComputeGridVec = true;
      } else if (name.equals( _id("scaley") ) )
      {
        this.ellipseScaley = value;
        this.grid.bComputeGridVec = true;
      }        
      break;
    }
  }


  // ----------------------------------------------------------
  void compute(Rect rect, Polygon2D quad)
  {
    // Center of rect
    Vec2D c = new Vec2D(rect.x+0.5*rect.width, rect.y+0.5*rect.height);

    // Ellipse
    //    for (float f=1.0; f>0.8; f=f-0.2)
    {
      Polygon2D ellipse = new Ellipse(c, new Vec2D(this.ellipseScalex*grid.wCell/2, this.ellipseScaley*grid.hCell/2)).toPolygon2D(this.ellipseRes); 
      listPolygons.add(  constrainIntoQuad(ellipse, rect, quad) );
    }
  }
}

// ----------------------------------------------------------
class GridCellRender
{
  String name;
  Grid grid;
  ArrayList<Polygon2D> listPolygons;
  Group g;


  // ----------------------------------------------------------
  GridCellRender(String name, Grid grid)
  {
    this.name = name;
    this.grid = grid;
  }

  // ----------------------------------------------------------
  void beginCompute()
  {
    listPolygons = new ArrayList<Polygon2D>();
  }

  // ----------------------------------------------------------
  void compute(Rect rect, Polygon2D quad)
  {
  }
  // ----------------------------------------------------------
  String _id(String s)
  {
    return this.name+"_"+s;
  }

  // ----------------------------------------------------------
  void createControls()
  {
  }

  // ----------------------------------------------------------
  void drawPolygon(Polygon2D p)
  {
    beginShape();
    for (Vec2D v : p.vertices)
      vertex(v.x, v.y);
    endShape(CLOSE);
  }

  // ----------------------------------------------------------
  void draw()
  {
    if (listPolygons != null)
    {
      pushStyle();
      noFill();
      stroke(0, 255);
      strokeWeight(1);
      for (Polygon2D p : listPolygons)
      {
        drawPolygon(p);
      }
      popStyle();
    }
  }
}
