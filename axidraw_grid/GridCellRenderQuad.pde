class GridCellRenderQuad extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  // Number of points for the ellipse
  int ellipseRes = 20;
  // Scale along x,y axis
  float scalex = 1.0, scaley = 1.0;

  // ----------------------------------------------------------
  // Controls
  Slider sliderScalex, sliderScaley;

  // ----------------------------------------------------------
  GridCellRenderQuad()
  {
    super("Quads");
  }

  // ----------------------------------------------------------
  void compute(Rect rect, Polygon2D quad)
  {
    // Copy the quad
    Polygon2D quadCopy = quad.copy(); 
    // Apply scale
    quadCopy.scaleSize(this.scalex, this.scaley);
    // Add to polygons list
    listPolygons.add( quadCopy );
  
    // Stripes ? 
    if (grid.bComputeStripes)
      computeStripes(quadCopy, grid.stripesAngleStrategy, grid.getFieldValue( quadCopy.getCentroid() ) );
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

    sliderScalex = cp5.addSlider( _id("scalex") ).setLabel("scalex").setPosition(x, y).setSize(wControl, hControl).setRange(0.2, 2).setValue(this.scalex).setGroup(g).addCallback(this);
    y+=(hControl+padding);
    sliderScaley = cp5.addSlider( _id("scaley") ).setLabel("scaley").setPosition(x, y).setSize(wControl, hControl).setRange(0.2, 2).setValue(this.scaley).setGroup(g).addCallback(this);


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
      if (name.equals( _id("scalex") ) )
      {
        this.scalex = value;
        this.grid.bComputeGridVec = true;
      } else if (name.equals( _id("scaley") ) )
      {
        this.scaley = value;
        this.grid.bComputeGridVec = true;
      }        
      break;
    }
  }
}
