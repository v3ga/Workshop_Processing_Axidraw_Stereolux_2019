// ----------------------------------------------------------
class GridCellRender
{
  String name;
  Grid grid;
  ArrayList<Polygon2D> listPolygons;
  Stripes stripes;
  Group g;
  int marginControl = 5;
  int wControl = int(rectColumnRight.width - 2*marginControl)-60;
  int hControl = 20;
  int paddingControl = 10;
  int xControl = 5;
  int yControl = 10;

  // ----------------------------------------------------------
  GridCellRender(String name)
  {
    this.name = name;
    this.stripes = new Stripes();
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
  void beginCreateControls()
  {
    ControlP5 cp5 = controls.cp5;
    g = cp5.addGroup(this.name).setBackgroundHeight(400).setWidth(int(rectColumnRight.width)).setBackgroundColor(color(0, 190)).setPosition(rectColumnRight.x, 10);
  }

  // ----------------------------------------------------------
  void endCreateControls()
  {
    ControlP5 cp5 = controls.cp5;
    cp5.setBroadcast(true);
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
  void beginComputeStripes()
  {
    this.stripes.beginCompute();
  }

  // ----------------------------------------------------------
  void computeStripes(Polygon2D p, int stripesAngleStrategy, float value)
  {
    float angle = 0.0;
    if (stripesAngleStrategy == 0)
    {
      angle = 0.0;
    } else if (stripesAngleStrategy == 1)
    {
      angle = 90.0;
    } else if (stripesAngleStrategy == 2)
    {
      angle = random(1) < 0.5 ? 0.0 : 90.0;
    } else if (stripesAngleStrategy == 3)
    {
      angle = map( value, 0, 1, -180.0, 180.0);
    }

    this.stripes.computeWithDistance(p, radians(angle), 0, 0, map( value, 0, 1, 3, 12) );
  }

  // ----------------------------------------------------------
  void drawStripes()
  {
    this.stripes.draw();
  }

  // ----------------------------------------------------------
  void draw()
  {
    if (listPolygons != null)
    {
      pushStyle();
      noFill();
      stroke(colorStroke, 255);
      strokeWeight(1);
      for (Polygon2D p : listPolygons)
      {
        drawPolygon(p);
      }
      popStyle();
    }
  }

  // ----------------------------------------------------------
  void beginDrawDirect()
  {
    pushStyle();
    stroke(colorStroke);
    noFill();
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
  }

  // ----------------------------------------------------------
  void endDrawDirect()
  {
    popStyle();
  }

  // ----------------------------------------------------------
  float getGridFieldValue(float x, float y)
  {
    return this.grid.getFieldValue(x, y);
  }

  // ----------------------------------------------------------
  float getGridFieldValue(Vec2D p)
  {
    return this.getGridFieldValue(p.x, p.y);
  }
}
