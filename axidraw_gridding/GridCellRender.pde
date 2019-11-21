

// ----------------------------------------------------------
class GridCellRender
{
  String name;
  Grid grid;
  ArrayList<Polygon2D> listPolygons;
  Group g;
  boolean bDrawDirect = true;
  boolean bDrawPolygon = true;
  Stripes stripes;

  // ----------------------------------------------------------
  GridCellRender(String name, Grid grid)
  {
    this.name = name;
    this.grid = grid;
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
  void computeDirect()
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
    g.show();
  }

  // ----------------------------------------------------------
  void hideControls()
  {
    g.hide();
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
  void drawDirect(Rect rect, int i, int j)
  {
  }
}
