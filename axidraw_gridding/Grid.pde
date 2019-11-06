class Grid
{
  // Vertices
  Vec2D[] vertices;
  // List of cells (quads)
  Polygon2D[] cells;
  boolean[] bDrawCell;
  // nb of cells along each axis
  int resx, resy, nb;   
  // Dimensions
  float x, y, w, h;
  float margin;
  // Parameters
  float rndDistort = 0.0;
  float rndDrawCell = 0.0;
  // State flags
  boolean bComputeGridVec = true;
  boolean bDrawGrid = true;

  // ----------------------------------------------------------
  Grid(int resx, int resy, float margin)
  {
    this.resx = resx;
    this.resy = resy;
    this.w = width-2*margin;
    this.h = height-2*margin;
    this.x = margin;
    this.y = margin;

    computeGridVec();
  }

  // ----------------------------------------------------------
  void setResx(int resx)
  {
    this.resx = resx;
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  void setResy(int resy)
  {
    this.resy = resy;
    this.bComputeGridVec = true;
  }

  

  // ----------------------------------------------------------
  void setRndDrawCell(float rnd_)
  {
    this.rndDrawCell = rnd_;
    this.setRandomDrawCell(rnd_);
  }

  // ----------------------------------------------------------
  void setDistort(float rndDistort_)
  {
    this.rndDistort = rndDistort_;
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  void setDrawGrid(boolean is)
  {
    this.bDrawGrid = is;
  }

  // ----------------------------------------------------------
  void computeGridVec()
  {
    if (bComputeGridVec == false) return;
    bComputeGridVec = false;

    int nbVertices = (this.resx+1)*(this.resy+1);
    this.vertices = new Vec2D[nbVertices];

    float xx = this.x;
    float yy = this.y;
    for (int j=0; j<this.resy+1; j++)
    {
      xx = this.x;
      for (int i=0; i<this.resx+1; i++)
      {
        this.vertices[i + (this.resx+1)*j] = new Vec2D(xx + random(-rndDistort, rndDistort), yy + random(-rndDistort, rndDistort));
        xx += this.w / float(resx);
      }
      yy += this.h / float(resy);
    }

    int nbCells = getNbCells();
    this.cells = new Polygon2D[nbCells];
    for (int j=0; j<this.resy; j++)
    {
      for (int i=0; i<this.resx; i++)
      {
        Polygon2D p = new Polygon2D();
        this.cells[i + this.resx*j ] = p;
        p.add( getVec2D(i, j) );
        p.add( getVec2D(i+1, j) );
        p.add( getVec2D(i+1, j+1) );
        p.add( getVec2D(i, j+1) );
      }
    }    

    setRandomDrawCell(rndDrawCell);
  }

  // ----------------------------------------------------------
  void setRandomDrawCell(float r)
  {
    int nbCells = getNbCells();
    bDrawCell = new boolean[nbCells];
    for (int i=0; i<nbCells; i++) 
      bDrawCell[i] = ( random(1) >= r ) ? true : false;
  }

  // ----------------------------------------------------------
  Vec2D getVec2D(int i, int j)
  {
    return vertices[i + (this.resx+1)*j];
  }

  // ----------------------------------------------------------
  Polygon2D getCell(int i, int j)
  {
    if (i < resx && j < resy && bDrawCell[i + resx*j])
      return this.cells[i+(resx-1)*j];
    return null;
  }

  // ----------------------------------------------------------
  int getNbCells()
  {
    return this.resx*this.resy;
  }


  // ----------------------------------------------------------
  ArrayList<Line2D> getGridLines()
  {
    ArrayList<Line2D> lines = new ArrayList<Line2D>();

    for (int j=0; j<resy; j++)
      for (int i=0; i<resx; i++)
        lines.add( new Line2D(getVec2D(i, j), getVec2D(i+1, j)) );

    for (int j=0; j<resy; j++)
      for (int i=0; i<resx; i++)
        lines.add( new Line2D(getVec2D(i, j), getVec2D(i, j+1)) );

    return lines;
  }

  // ----------------------------------------------------------
  void compute()
  {
    computeGridVec();
  }

  // ----------------------------------------------------------
  void draw()
  {
    compute();

    if (bDrawGrid)
    {
      pushStyle();
      stroke(0);
      strokeWeight(1);
//      noFill();
      Vec2D A, B, C, D;
      beginShape(QUADS);
      for (int j=0; j<this.resy; j++)
      {
        for (int i=0; i<this.resx; i++)
        {
          if (getCell(i, j) != null)
          {
            A = getVec2D(i, j);
            B = getVec2D(i+1, j);
            C = getVec2D(i+1, j+1);
            D = getVec2D(i, j+1);

            vertex(A.x, A.y);
            vertex(B.x, B.y);
            vertex(C.x, C.y);
            vertex(D.x, D.y);
          }
        }
      }
      endShape();
      popStyle();
    }
  }

}
