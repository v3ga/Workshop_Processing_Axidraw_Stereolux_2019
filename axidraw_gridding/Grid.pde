class Grid
{
  // Vertices
  Vec2D[] vertices, verticesRect;
  // List of cells (quads)
  Polygon2D[] cells;
  Rect[] rects;
  boolean[] bDrawCell;
  // nb of cells along each axis
  int resx, resy, nb;   
  // Dimensions
  float x, y, w, h;
  float margin;
  float wCell, hCell;
  // Parameters
  float rndDrawCell = 0.0;
  // State flags
  boolean bComputeGridVec = true;
  boolean bDrawGrid = true;
  boolean bSquare = false;
  // Perturbation strategy
  float perturbationAmount = 0.0;
  String perturbation = "random";
  float rndPerturbationMax = 40.0;
  // Cells rendering
  ArrayList<GridCellRender> listRenders = new ArrayList<GridCellRender>();
  GridCellRender gridCellRender;

  // ----------------------------------------------------------
  Grid(int resx, int resy, float margin)
  {
    this.resx = resx;
    this.resy = resy;
    this.margin = margin;
    this.setSize(width-2*margin, height-2*margin);
    this.setPosition(margin, margin);

    // TEMP
    this.gridCellRender = new GridCellRenderEllipse("Ellipses",this);
  }

  // ----------------------------------------------------------
  void createControls()
  {
    this.gridCellRender.createControls();
  }

  // ----------------------------------------------------------
  void setPosition(float x, float y)
  {
    this.x = x;
    this.y = y;
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  void setSize(float w, float h)
  {
    this.w = w;
    this.h = h;
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  void setResx(int resx)
  {
    this.resx = resx;
    this.adjustResolutionSquare();
  }

  // ----------------------------------------------------------
  void setResy(int resy)
  {
    this.resy = resy;
    this.adjustResolutionSquare();
  }

  // ----------------------------------------------------------
  void setSquare(boolean is)
  {
    this.bSquare = is;
    this.adjustResolutionSquare();
  }

  // ----------------------------------------------------------
  void setDrawGrid(boolean is)
  {
    this.bDrawGrid = is;
  }

  // ----------------------------------------------------------
  void setRndDrawCell(float rnd_)
  {
    this.rndDrawCell = rnd_;
    this.setRandomDrawCell(rnd_);
  }

  // ----------------------------------------------------------
  void adjustResolutionSquare()
  {
    if (bSquare == false)
    {
      this.setSize(width-2*margin, height-2*margin);
      this.setPosition(margin, margin);
    } else
    {
      this.resy = this.resx;

      this.setSize(height-2*margin, height-2*margin);
      this.setPosition((width-this.w)/2, (height-this.h)/2);
    }
    this.bComputeGridVec = true;
  }


  // ----------------------------------------------------------
  void computeGridVec()
  {
    if (bComputeGridVec == false) return;
    bComputeGridVec = false;

    int nbVertices = (this.resx+1)*(this.resy+1);
    int nbCells = getNbCells();

    this.vertices = new Vec2D[nbVertices];
    this.verticesRect = new Vec2D[nbVertices];
    this.cells = new Polygon2D[nbCells];
    this.rects = new Rect[nbCells];


    this.wCell = this.w / float(resx);
    this.hCell = this.h / float(resy);

    float xx = this.x;
    float yy = this.y;
    int offset = 0;
    for (int j=0; j<this.resy+1; j++)
    {
      xx = this.x;
      for (int i=0; i<this.resx+1; i++)
      {
        offset = i + (this.resx+1)*j;

        Vec2D v = new Vec2D(xx, yy); 
        this.verticesRect[offset] = v.copy();

        v.addSelf( this.getPerturbation(perturbation) );
        this.vertices[offset] = v;

        xx += wCell;
      }
      yy += hCell;
    }

    yy = this.y;
    for (int j=0; j<this.resy; j++)
    {
      xx = this.x;
      for (int i=0; i<this.resx; i++)
      {
        offset = i + this.resx*j;

        Polygon2D p = new Polygon2D();
        p.add( getVec2D(i, j) );
        p.add( getVec2D(i+1, j) );
        p.add( getVec2D(i+1, j+1) );
        p.add( getVec2D(i, j+1) );

        this.cells[offset] = p;
        this.rects[offset] = new Rect(xx, yy, wCell, hCell);

        xx += wCell;
      }
      yy += hCell;
    }    

    setRandomDrawCell(rndDrawCell);

    computeCells();
  }

  // ----------------------------------------------------------
  void setPerturbationAmount(float value)
  {
    this.perturbationAmount = value;
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  Vec2D getPerturbation(String perturbation)
  {
    Vec2D p = new Vec2D();
    if (perturbation.equals("random"))
    {
      p.x = perturbationAmount * random(-rndPerturbationMax, rndPerturbationMax);
      p.y = perturbationAmount * random(-rndPerturbationMax, rndPerturbationMax);
    }
    return p;
  }

  // ----------------------------------------------------------
  void computeCells()
  {
    if ( this.gridCellRender != null)
    {
      this.gridCellRender.beginCompute();

      int i, j, offset;
      for (j=0; j<this.resy; j++)
      {
        for (i=0; i<this.resx; i++)
        {
          offset = i + this.resx*j;
          if (bDrawCell[offset])
            this.gridCellRender.compute( this.rects[offset], this.cells[offset] );
        }
      }
    }
  }

  // ----------------------------------------------------------
  void setRandomDrawCell(float r)
  {
    int nbCells = getNbCells();
    bDrawCell = new boolean[nbCells];
    for (int i=0; i<nbCells; i++) 
      bDrawCell[i] = ( random(1) >= r ) ? true : false;
    computeCells();
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

    if (gridCellRender != null)
      gridCellRender.draw();

    if (bDrawGrid)
    {
      pushStyle();
      stroke(0, 100);
      strokeWeight(1);
      noFill();
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

      stroke(0, 20);
      Rect r;
      for (int i=0; i<this.rects.length; i++)
      {
        r = this.rects[i];
        rect(r.x, r.y, r.width, r.height);
      }

      popStyle();
    }
  }
}
