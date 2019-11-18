class GridCellRenderTruchet extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters

  // ----------------------------------------------------------
  // Controls

  // ----------------------------------------------------------
  GridCellRenderTruchet(Grid grid)
  {
    super("Truchet", grid);
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
  void compute(Rect rect, Polygon2D quad)
  {
    // Center of rect
    Vec2D c = new Vec2D(rect.x+0.5*rect.width, rect.y+0.5*rect.height);
  }
}
