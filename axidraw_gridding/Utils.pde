// ------------------------------------------------------
void setupMedias()
{
}

// ------------------------------------------------------
void setupLibraries()
{
}

// ------------------------------------------------------
static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }
}

// ------------------------------------------------------
String timestamp() 
{
  return Utils.timestamp();
}

// ------------------------------------------------------
Polygon2D constrainIntoQuad(Polygon2D polygon, Rect rect, Polygon2D quad)
{
  Polygon2D polygonConstrain = new Polygon2D();
  Vec2D vNorm = new Vec2D();
  for (Vec2D v : polygon.vertices)
  {
    vNorm.set( (v.x-rect.x)/rect.width, (v.y-rect.y)/rect.height );
    polygonConstrain.add( getPointInQuad(quad,vNorm.x,vNorm.y) );
  }

  return polygonConstrain;
}

// ------------------------------------------------------
Vec2D getPointInQuad(Polygon2D quad, float lQuadNorm, float mQuadNorm)
{
  float x1 = quad.vertices.get(0).x;
  float x2 = quad.vertices.get(1).x;
  float x3 = quad.vertices.get(2).x;
  float x4 = quad.vertices.get(3).x;

  float y1 = quad.vertices.get(0).y;
  float y2 = quad.vertices.get(1).y;
  float y3 = quad.vertices.get(2).y;
  float y4 = quad.vertices.get(3).y;

  float a1 = x1;
  float a2 = -x1+x2;
  float a3 = -x1+x4;
  float a4 = x1-x2+x3-x4;

  float b1 = y1;
  float b2 = -y1+y2;
  float b3 = -y1+y4;
  float b4 = y1-y2+y3-y4;

  return new Vec2D
    (
    a1+a2*lQuadNorm+a3*mQuadNorm+a4*lQuadNorm*mQuadNorm, 
    b1+b2*lQuadNorm+b3*mQuadNorm+b4*lQuadNorm*mQuadNorm
    );
}
