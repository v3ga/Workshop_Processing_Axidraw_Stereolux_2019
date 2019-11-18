

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
