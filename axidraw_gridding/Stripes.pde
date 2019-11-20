class Stripes
{
  // ----------------------------------------------------------
  ArrayList<Line2D> lines;

  // ----------------------------------------------------------
  Stripes()
  {
  }

  // ----------------------------------------------------------
  float getPolygonRadius(Polygon2D p)
  {
    Vec2D centroid = p.getCentroid();
    float r = 0.0;
    float rmax = 0.0f;
    for (Vec2D v : p.vertices) 
    {
      r = centroid.distanceTo(v);
      if (r > rmax) {
        rmax = r;
      }
    }
    return rmax;
  }

  // ----------------------------------------------------------
  ArrayList<Line2D> getIntersectionLines(Polygon2D p, Line2D line)
  {
    ArrayList<Line2D> lines = new ArrayList<Line2D>();
    ArrayList<Vec2D> points = getIntersectionPoints(p, line);
    Vec2D dir = line.getDirection();
    final Line2D l = line.copy();
    Collections.sort(points, new Comparator<Vec2D>() 
    {
      @Override
        public int compare(Vec2D A, Vec2D B)
      {
        return l.a.distanceTo(A) < l.a.distanceTo(B) ? 1 : -1;
      }
    }
    );

    if (points.size() % 2 == 0)
    {
      for (int i=0; i<points.size(); i=i+2)
      {
        lines.add( new Line2D(points.get(i).copy(), points.get(i+1).copy()) );
      }
    }

    return lines;
  }

  // ----------------------------------------------------------
  ArrayList<Vec2D> getIntersectionPoints(Polygon2D p, Line2D line)
  {
    int nbPoints = p.getNumPoints();
    Vec2D A, B;
    Line2D AB;
    ArrayList<Vec2D> points = new ArrayList<Vec2D>();
    for (int i=0; i<nbPoints; i++)
    {
      A = p.vertices.get(i);
      B = p.vertices.get((i+1)%nbPoints);
      AB = new Line2D(A, B);
      Line2D.LineIntersection intersection = line.intersectLine(AB);
      if (intersection.getType() == toxi.geom.Line2D.LineIntersection.Type.INTERSECTING)
      {
        points.add( intersection.getPos().copy() );
      }
    }
    return points;
  }

  // ----------------------------------------------------------
  void beginCompute()
  {
    lines = new ArrayList<Line2D>();
  }

  // ----------------------------------------------------------
  void computeWithDistance(Polygon2D p, float angle, float angleRndMin, float angleRndMax, float dist)
  {
    if (lines == null) 
      return;

    float radius = getPolygonRadius(p);
    float stepx = dist;
    int nbLines = int( 2*radius/stepx ) + 1;
    Vec2D i = new Vec2D(1, 0); // unit vector
    i.rotate(angle);
    Vec2D j = new Vec2D(-i.y, i.x);
    Vec2D c = p.getCentroid();

    float s = radius;
    Vec2D A = new Vec2D();
    Vec2D B = new Vec2D();
    Line2D line = new Line2D(A, B);
    for (int ii=0; ii<nbLines; ii++)
    {
      i.rotate( random(angleRndMin, angleRndMax) );
      j.set(-i.y, i.x);
      A.set(c.x+s*i.x + radius*j.x, c.y+s*i.y + radius*j.y);
      B.set(c.x+s*i.x - radius*j.x, c.y+s*i.y - radius*j.y);
      line.a = A;
      line.b = B;

      lines.addAll( getIntersectionLines(p, line) );

      s-=stepx;
    }
  }

  // ----------------------------------------------------------
  void draw()
  {
    drawWithMode("normal");
  }

  // ----------------------------------------------------------
  void drawWithMode(String mode)
  {
    pushStyle();
    stroke(colorStroke);
    strokeWeight(1);

    if (mode.equals("normal"))
    {
      beginShape(LINES);
      for (Line2D ll : lines)
      {
        vertex(ll.a.x, ll.a.y);
        vertex(ll.b.x, ll.b.y);
      }    
      endShape();
    } else if (mode.equals("zigzag1"))
    {
      beginShape();
      int iLine = 0;
      for (Line2D ll : lines)
      {
        Vec2D A = iLine%2 == 0 ? ll.a : ll.b;    
        Vec2D B = iLine%2 == 0 ? ll.b : ll.a;    
        vertex(A.x, A.y);
        vertex(B.x, B.y);
        iLine++;
      }
      endShape();
    } else if (mode.equals("zigzag2"))
    {
      beginShape();
      int iLine = 0;
      for (Line2D ll : lines)
      {
        Vec2D A = ll.a;    
        Vec2D B = ll.b;    
        vertex(A.x, A.y);
        vertex(B.x, B.y);
        iLine++;
      }
      endShape();
    }  

    popStyle();
  }
}
