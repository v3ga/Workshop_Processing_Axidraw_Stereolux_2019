class GridCellRender
{
  Grid grid;
  ArrayList<Polygon2D> listPolygons;

  // ----------------------------------------------------------
  GridCellRender(Grid grid)
  {
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
    // Center of rect
    Vec2D c = new Vec2D(rect.x+0.5*rect.width, rect.y+0.5*rect.height);
    // Ellipse
    for (float f=1.0 ; f>0.8; f=f-0.2)
    {
      Polygon2D ellipse = new Ellipse(c,new Vec2D(f*grid.wCell/2,f*grid.hCell/2)).toPolygon2D(20); 
      // Add polygon
      listPolygons.add(  constrainIntoQuad(ellipse, rect, quad) );
    }
/*
    int indexRandom = int(random( quad.vertices.size() ));
    Vec2D p = quad.vertices.get(indexRandom);

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
      stroke(0,255);
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
    beginShape();
    for (Vec2D v : p.vertices)
      vertex(v.x,v.y);
    endShape(CLOSE);
  }
}
