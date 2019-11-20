// ------------------------------------------------------
void setupControls()
{
  controls = new Controls(this);
  controls.setup();
  grid.createControls();
}


// ------------------------------------------------------
void updateControls()
{
  controls.update();
}

// ------------------------------------------------------
void exportSVG()
{
  bExportSVG = true;
}

// ------------------------------------------------------
class Controls
{
  PApplet parent;
  ControlP5 cp5;

  // ------------------------------------------------------
  Group gGrid;
  Toggle tgDarkMode;
  Slider sliderGridResx, sliderGridResy;
  Toggle tgDrawGrid, tgIsSquare, tgDrawField, tgComputeStripes, tgDrawPolygons;
  DropdownList dlGridCellRender, dlGridField;
  Slider sliderPerturbationAmount, sliderRndCell;
  DropdownList dlStripesAngleStrategy;
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
    int margin = 5;
    int wControl = int(rectColumnLeft.width - 2*margin)-60;
    int hControl = 20;
    int padding = 10;
    int x = 5;
    int y = 10;


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
    gGrid = cp5.addGroup("Grid").setBackgroundHeight(400).setWidth(int(rectColumnLeft.width)).setBackgroundColor(color(0, 190)).setPosition(int(rectColumnLeft.x), 10);

    cp5.setBroadcast(false);
    tgDarkMode = cp5.addToggle("darkMode").setLabel("dark mode").setPosition(x, y).setSize(hControl, hControl).setValue(bDarkMode).setGroup(gGrid).addCallback(cbGrid);
    y+=(hControl+padding+8);
    sliderGridResx = cp5.addSlider("resx").setPosition(x, y).setSize(wControl, hControl).setRange(1, nbGridResMax).setNumberOfTickMarks(nbGridResMax).setGroup(gGrid).addCallback(cbGrid);
    sliderGridResx.setValue(grid.resx);
    y+=(hControl+padding);
    sliderGridResy = cp5.addSlider("resy").setPosition(x, y).setSize(wControl, hControl).setRange(1, nbGridResMax).setNumberOfTickMarks(nbGridResMax).setGroup(gGrid).addCallback(cbGrid);
    sliderGridResy.setValue(grid.resy);
    y+=(hControl+padding);
    tgDrawGrid = cp5.addToggle("drawGrid").setLabel("draw grid").setPosition(x, y).setSize(hControl, hControl).setValue(grid.bDrawGrid).setGroup(gGrid).addCallback(cbGrid);
    tgIsSquare = cp5.addToggle("isSquare").setLabel("is square").setPosition(x+3*hControl, y).setSize(hControl, hControl).setValue(grid.bSquare).setGroup(gGrid).addCallback(cbGrid);
    tgDrawField = cp5.addToggle("drawField").setLabel("draw field").setPosition(x+6*hControl, y).setSize(hControl, hControl).setValue(grid.bDrawField).setGroup(gGrid).addCallback(cbGrid);
    if (bModeDirect == false)
    {
      tgComputeStripes = cp5.addToggle("computeStripes").setLabel("stripes").setPosition(x+9*hControl, y).setSize(hControl, hControl).setValue(grid.bComputeStripes).setGroup(gGrid).addCallback(cbGrid);
      tgDrawPolygons = cp5.addToggle("drawPolygons").setLabel("polygons").setPosition(x+12*hControl, y).setSize(hControl, hControl).setValue(grid.bDrawPolygons).setGroup(gGrid).addCallback(cbGrid);
    }
    y+=(hControl+padding+8);
    dlGridCellRender = cp5.addDropdownList("dlGridCellRender").setPosition(x, y).setWidth(wControl/2-padding).setGroup(gGrid).setLabel("grid cell").addCallback(cbGrid);
    dlGridField = cp5.addDropdownList("dlGridField").setPosition(x+wControl/2, y).setWidth(wControl/2).setGroup(gGrid).setLabel("grid field").addCallback(cbGrid);
    customizeDropdown(dlGridCellRender,hControl);
    customizeDropdown(dlGridField,hControl);
    y+=(hControl+padding);
    if (bModeDirect == false)
    {
      sliderPerturbationAmount =  cp5.addSlider("perturbation").setPosition(x, y).setSize(wControl, hControl).setRange(0.0, 1.0).setValue(grid.perturbationAmount).setGroup(gGrid).addCallback(cbGrid);
      y+=(hControl+padding);
      sliderRndCell =  cp5.addSlider("rndCell").setPosition(x, y).setSize(wControl, hControl).setRange(0.0, 1.0).setValue(grid.rndDrawCell).setGroup(gGrid).addCallback(cbGrid);
      y+=(hControl+padding);
    }

    dlStripesAngleStrategy = cp5.addDropdownList("dlStripesAngleStrategy").setPosition(x, y).setWidth(wControl/2).setGroup(gGrid).setLabel("stripes angle strategy").addCallback(cbGrid);
    customizeDropdown(dlStripesAngleStrategy,hControl);
    
    btnExportSVG = cp5.addButton("exportSVG").setLabel("export svg").setPosition(x, height - hControl - margin);
    
    // Populate Dropdowns
    // DL Grid Cell Render
    int indexItem = 1;
    for (GridCellRender gcr : grid.listRenders)
      dlGridCellRender.addItem(gcr.name, indexItem++);
    // DL Grid field
    indexItem = 1;
    for (GridField gf : grid.listFields)
      dlGridField.addItem(gf.name, indexItem++);
    // DL Stripes angle strategy
    dlStripesAngleStrategy.addItem("constant vertical", 0);
    dlStripesAngleStrategy.addItem("constant horizontal", 1);
    dlStripesAngleStrategy.addItem("random orthogonal", 2);
    dlStripesAngleStrategy.addItem("bound to field value", 2);

    dlGridCellRender.close();
    dlGridField.close();
    dlStripesAngleStrategy.close();
    dlGridCellRender.bringToFront();
    dlGridField.bringToFront();
    dlStripesAngleStrategy.bringToFront();

    cp5.setBroadcast(true);
  }


  // ----------------------------------------------------------
  void customizeDropdown(DropdownList dl, int h)
  {
    dl.setItemHeight(h);
    dl.setBarHeight(h);
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
        
        //println(name + "/"+value);

        if (name.equals("darkMode"))
        {
          bDarkMode = int(value) > 0.0;
          setupColors();
        }
        else if (name.equals("resx"))
        {
          grid.setResx( (int) value  );
          updateControls();
        } else if (name.equals("resy"))
        { 
          grid.setResy( (int) value );
          updateControls();
        } else if (name.equals("drawGrid")) {
          grid.bDrawGrid = value > 0.0;
        } else if (name.equals("isSquare")) 
        {
          boolean is = value > 0.0;
          grid.setSquare(is);
          if (is==false)
            grid.setResy( int(sliderGridResy.getValue()) );
          updateControls();
        } else if (name.equals("drawField")) {
          grid.bDrawField = value > 0.0;
        } else if (name.equals("computeStripes")) {
          grid.bComputeStripes = value > 0.0;
        } else if (name.equals("drawPolygons")) {
          grid.bDrawPolygons = value > 0.0;
        }
        else if (name.equals("dlGridCellRender"))
        {
            grid.selectGridCellRenderWithIndex( int(value) );
        }
        else if (name.equals("dlGridField"))
        {
          grid.selectGridFieldWithIndex(int(value));
        }
        else if (name.equals("dlStripesAngleStrategy"))
        {
          grid.setStripesStrategy(int(value));
        }
        else if (name.equals("rndCell")) { 
          grid.setRndDrawCell( value );
        } else if (name.equals("perturbation")) {
          grid.setPerturbationAmount( value );
        }
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
