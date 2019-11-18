class Grid
{
  // Viewport
  Rect rectViewport;
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
  float margin = gridMargin;
  float wCell, hCell;
  // Parameters
  float rndDrawCell = 0.0;
  // State flags
  boolean bComputeGridVec = true;
  boolean bDrawGrid = true;
  boolean bSquare = false;
  boolean bDrawField = false;
  boolean bComputeStripes = true;
  boolean bDrawPolygons = true;
  // Perturbation strategy
  float perturbationAmount = 0.0;
  String perturbation = "random";
  float rndPerturbationMax = 40.0;
  // Cells rendering
  ArrayList<GridCellRender> listRenders = new ArrayList<GridCellRender>();
  GridCellRender gridCellRender;
  // Fields
  ArrayList<GridField> listFields = new ArrayList<GridField>();
  GridField gridField;
  // Stripes
  Stripes stripes;

  // ----------------------------------------------------------
  Grid(int resx, int resy, Rect rectViewport)
  {
    this.resx = resx;
    this.resy = resy;
    this.rectViewport = rectViewport;

    this.adjustResolutionSquare();

    this.stripes = new Stripes();

    listRenders.add( new GridCellRenderEllipse(this)  );
    listRenders.add( new GridCellRenderTruchet (this)  );
    listFields.add( new GridFieldSine(this)  );
    listFields.add( new GridFieldNoise(this)  );
  }

  // ----------------------------------------------------------
  void createControls()
  {
    for (GridCellRender gcr : listRenders)
    {
      gcr.createControls();
    }

    for (GridField gf : listFields)
    {
      gf.createControls();
    }
    showGridCellRenderControls(null);
    showGridFieldControls(null);
  }

  // ----------------------------------------------------------
  void showGridCellRenderControls(GridCellRender selected)
  {
    for (GridCellRender gcr : listRenders)
      gcr.g.hide();
    if (selected != null) selected.g.show();
  }

  // ----------------------------------------------------------
  void showGridFieldControls(GridField selected)
  {
    for (GridField gf : listFields)
      gf.g.hide();
    if (selected != null) selected.g.show();
  }

  // ----------------------------------------------------------
  void selectGridCellRenderWithIndex(int index)
  {
    if (index < this.listRenders.size())
    {
      this.gridCellRender = listRenders.get(index);
      showGridCellRenderControls(this.gridCellRender);
      
      this.bComputeGridVec = true;
    }
  }
  
  // ----------------------------------------------------------
  void selectGridFieldWithIndex(int index)
  {
    if (index < this.listFields.size())
    {
      this.gridField = listFields.get(index);
      showGridFieldControls(this.gridField);
      
      this.bComputeGridVec = true;
    }
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
    float wGrid=0, hGrid=0;
    // ratio = w / h; w = ratio * h; h = w / ratio;
    float ratio = rectViewport.width / rectViewport.height;

    if (bSquare == false)
    {
      // Paysage viewport
      if (rectViewport.width >= rectViewport.height)
      {
        hGrid = rectViewport.height - 2*margin;
        wGrid = hGrid * ratio;
      } else 
      {
        wGrid = rectViewport.width - 2*margin;          
        hGrid = wGrid / ratio;
      }
    } else
    {
      this.resy = this.resx;

      // Paysage viewport
      if (rectViewport.width >= rectViewport.height)
      {
        wGrid = hGrid = rectViewport.height - 2*margin;
      } else 
      {
        wGrid = hGrid = rectViewport.width - 2*margin;
      }
    }

    this.setSize(wGrid, hGrid);
    this.setPosition(rectViewport.x + (rectViewport.width-wGrid)/2, rectViewport.y + (rectViewport.height-hGrid)/2);
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
      if (bComputeStripes)
        stripes.beginCompute();

      int i, j, offset;
      for (j=0; j<this.resy; j++)
      {
        for (i=0; i<this.resx; i++)
        {
          offset = i + this.resx*j;
          if (bDrawCell[offset])
          {
            this.gridCellRender.compute( this.rects[offset], this.cells[offset] );
          }
        }
      }
    }

    if (bComputeStripes)
    {
      ArrayList<Polygon2D> polygons = this.gridCellRender.listPolygons;
      for (Polygon2D p : polygons)
      {
        stripes.computeWithDistance(p, 6, 0, 0, 9);
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
      return this.cells[i+(resx)*j];
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


    if (bDrawPolygons && gridCellRender != null)
      gridCellRender.draw();

    if (bComputeStripes)
    {
      stripes.draw();
    }
  }

  // ----------------------------------------------------------
  void drawField()
  {
    if (this.rects == null || !bDrawField) return;
    pushStyle();
    noStroke();
    rectMode(CENTER);
    float value = 0.0;
    Rect rect;
    Vec2D c;
    float f = 1.0;
    for (int j=0; j<this.resy; j++)
    {
      for (int i=0; i<this.resx; i++)
      {
        rect = this.rects[i+this.resx*j];
        if (rect != null)
        {
          value = gridField.getValue(rect.x+0.5*rect.width, rect.y+0.5*rect.height);
          fill(value*255, 100);
          rect(rect.x+0.5*rect.width, rect.y+0.5*rect.height, f*rect.width, f*rect.height);
        }
      }
    }
    popStyle();
  }
}
