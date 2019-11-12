// ------------------------------------------------------



// ------------------------------------------------------
void setupControls()
{
  //  cf = new ControlFrame(this, 500, height, "Controls");
  //  surface.setLocation(500, 10);
  controls = new Controls(this);
  controls.setup();
}


// ------------------------------------------------------
void updateControls()
{
  controls.update();
}

// ------------------------------------------------------
void exportSVG()
{
  println("exportSVG");
  bExportSVG = true;
}

// ------------------------------------------------------
class Controls
{
  PApplet parent;
  ControlP5 cp5;

  // ------------------------------------------------------
  Group gGrid;
  Slider sliderGridResx, sliderGridResy;
  Toggle tgDrawGrid, tgIsSquare;
  Button btnExportSVG;

  public Controls(PApplet _parent)
  {
    parent = _parent;
  }

  // ----------------------------------------------------------
  void customizeDropdown(DropdownList dl)
  {
    dl.setItemHeight(20);
    dl.setBarHeight(20);
  }

  // ------------------------------------------------------
  public void setup() 
  {
    int wControl = 250;
    int hControl = 20;
    int padding = 10;
    int x = 5;
    int y = 10;

    int nbGridMax = 10;

    surface.setLocation(0, 10);

    //    cp5 = new ControlP5(this, new ControlFont(font15, 13));
    cp5 = new ControlP5(parent);
    cp5.setAutoDraw(false);

    /*
    cp5.setColorCaptionLabel( color(#4c5575) );
     cp5.setColorLabel( color(255) );
     cp5.setColorActive(color(#98aab9));
     cp5.setColorForeground(color(#4c5575));
     cp5.setColorBackground(color(#e1a48c));
     */
    // GRID
    gGrid = cp5.addGroup("Grid").setBackgroundHeight(400).setWidth(330).setBackgroundColor(color(0, 190)).setPosition(5, 15);

    cp5.setBroadcast(false);
    sliderGridResx = cp5.addSlider("resx").setPosition(x, y).setSize(wControl, hControl).setRange(1, nbGridMax).setNumberOfTickMarks(nbGridMax).setGroup(gGrid).addCallback(cbGrid);
    sliderGridResx.setValue(grid.resx);
    y+=(hControl+padding);
    sliderGridResy = cp5.addSlider("resy").setPosition(x, y).setSize(wControl, hControl).setRange(1, nbGridMax).setNumberOfTickMarks(nbGridMax).setGroup(gGrid).addCallback(cbGrid);
    sliderGridResy.setValue(grid.resy);
    y+=(hControl+padding);
    tgDrawGrid = cp5.addToggle("drawGrid").setLabel("draw grid").setPosition(x, y).setSize(hControl, hControl).setValue(grid.bDrawGrid).setGroup(gGrid).addCallback(cbGrid);
    tgIsSquare = cp5.addToggle("isSquare").setLabel("is square").setPosition(x+3*hControl, y).setSize(hControl, hControl).setValue(grid.bSquare).setGroup(gGrid).addCallback(cbGrid);

    btnExportSVG = cp5.addButton("exportSVG").setLabel("export svg").setPosition(x, 400 - hControl - padding).setGroup(gGrid);

    cp5.setBroadcast(true);
  }

  // ----------------------------------------------------------
  void update()
  {
    cp5.setBroadcast(false);
    sliderGridResx.setValue( grid.resx );
    sliderGridResy.setValue( grid.resy );
    cp5.setBroadcast(true);
  }

  // ----------------------------------------------------------
  CallbackListener cbGrid = new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      switch(theEvent.getAction()) 
      {
      case ControlP5.ACTION_RELEASED: 
      case ControlP5.ACTION_RELEASEDOUTSIDE: 
        String name = theEvent.getController().getName();
        float value = theEvent.getController().getValue();
        //      println(name + "/"+value);
        if (name.equals("resx"))
        {
          grid.setResx( (int) value  );
          updateControls();
        } else if (name.equals("resy"))
        { 
          grid.setResy( (int) value );
          updateControls();
        } else if (name.equals("distort")) 
          grid.setDistort( value );
        else if (name.equals("drawGrid")) 
          grid.bDrawGrid = value > 0.0;
        else if (name.equals("isSquare")) 
        {
          boolean is = value > 0.0;
          grid.setSquare(is);
          if (is==false)
            grid.setResy( int(sliderGridResy.getValue()) );
          updateControls();
        } else if (name.equals("rndCell")) 
          grid.setRndDrawCell( value );
        break;
      }
    }
  };



  // ------------------------------------------------------
  void draw() 
  {
    //    background( 0 );
    cp5.draw();
  }

  // ----------------------------------------------------------
  void close()
  {
    gGrid.close();
    //grid.closeControls();
  }

  // ----------------------------------------------------------
  void open()
  {
    gGrid.open();
    //grid.openControls();
  }
  // ------------------------------------------------------
  void controlEvent(ControlEvent theEvent) 
  {
    /*    if (theEvent.isFrom(radioRender)) 
     {
     }
     */
  }
}
