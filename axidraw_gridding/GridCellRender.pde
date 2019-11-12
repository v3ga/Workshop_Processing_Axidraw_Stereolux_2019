class GridCellRender
{
  Grid grid;
  ArrayList<Polygon2D> listPolygons;

  GridCellRender(Grid grid)
  {
    this.grid = grid;
  }

  void draw(float x, float y, float w, float h)
  {
  }

  void beginCompute()
  {
    listPolygons = new ArrayList<Polygon2D>();
  }

  void compute(Polygon2D quad)
  {

    stroke(0);
    Vec2D c = quad.getCentroid();
    int indexRandom = int(random( quad.vertices.size() ));
    Vec2D p = quad.vertices.get(indexRandom);
    // line(c.x, c.y, p.x, p.y);

/*
    Polygon2D line = new Polygon2D();
    line.add(c.copy());
    line.add(p.copy());
    listPolygons.add(line);
*/
    // Polygon2D circle = new toxi.geom.Circle(c,30.0);
  

  }

  void draw()
  {
    if (listPolygons != null)
    {
      pushStyle();
      noFill();
      stroke(0);
      strokeWeight(1);
      for (Polygon2D p : listPolygons)
      {
        drawPolygon(p);
      }
      popStyle();
    }
  }

  void drawPolygon(Polygon2D p)
  {
    beginShape(LINES);
    for (Vec2D v : p.vertices)
      vertex(v.x,v.y);
    endShape(CLOSE);
  }
}
