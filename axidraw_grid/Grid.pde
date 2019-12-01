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
  boolean bUpdateControls = false;
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
  ArrayList<GridCellRender> listRendersPolygon = new ArrayList<GridCellRender>();
  ArrayList<GridCellRender> listRendersDirect = new ArrayList<GridCellRender>();
  ArrayList<GridCellRender> listRenders;
  GridCellRender gridCellRender;
  // Fields
  ArrayList<GridField> listFields = new ArrayList<GridField>();
  GridField gridField;
  // Stripes
  // Stripes / angle strategy
  // 0 = constant vertical
  // 1 = cosntant horizontal
  // 2 = random orthogonal
  // 3 = bound to field value
  int stripesAngleStrategy = 0;  

  // ----------------------------------------------------------
  Grid(int resx, int resy, Rect rectViewport)
  {
    this.resx = resx;
    this.resy = resy;
    this.rectViewport = rectViewport;

    this.adjustResolutionSquare();

    listRenders = bModeDirect ? listRendersDirect : listRendersPolygon;
  }

  // ----------------------------------------------------------
  void addGridCellRenderDirect(GridCellRender gcr)
  {
    listRendersDirect.add(gcr);
    gcr.grid = this;
  }

  // ----------------------------------------------------------
  void addGridCellRenderPolygon(GridCellRender gcr)
  {
    listRendersPolygon.add(gcr);
    gcr.grid = this;
  }

  // ----------------------------------------------------------
  void addGridField(GridField gf)
  {
    listFields.add(gf);
    gf.grid = this;
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
      gcr.hideControls();
    if (selected != null) selected.showControls();
  }

  // ----------------------------------------------------------
  void showGridFieldControls(GridField selected)
  {
    for (GridField gf : listFields)
      gf.hideControls();
    if (selected != null) selected.showControls();
  }

  // ----------------------------------------------------------
  void selectGridCellRenderWithIndex(int index)
  {
    if (index < this.listRenders.size())
    {
      this.gridCellRender = listRenders.get(index);

      this.bComputeGridVec = true;
      this.bUpdateControls = true;
    }
  }

  // ----------------------------------------------------------
  void setGridCellRenderWithName(String name)
  {
    for (GridCellRender gcr : listRenders)
    {
      if (gcr.name.equals(name))
      {
        println("setGridCellRenderWithName("+name+")");

        this.gridCellRender = gcr;
        this.bComputeGridVec = true;
        this.bUpdateControls = true;
      }
    }
  }

  // ----------------------------------------------------------
  void selectGridFieldWithIndex(int index)
  {
    if (index < this.listFields.size())
    {
      this.gridField = listFields.get(index);
      //      this.gridField.prepare();

      this.bComputeGridVec = true;
      this.bUpdateControls = true;
    }
  }  

  // ----------------------------------------------------------
  void setGridFieldWithName(String name)
  {
    for (GridField gf : listFields)
    {
      if (gf.name.equals(name))
      {
        println("setGridFieldWithName("+name+")");

        this.gridField = gf;
        this.bComputeGridVec = true;
        this.bUpdateControls = true;
      }
    }
  }
  // ----------------------------------------------------------
  void setStripesStrategy(int which)
  {
    this.stripesAngleStrategy = which;
    this.bComputeGridVec = true;
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
    //    this.setRandomDrawCell(rnd_);
    this.bComputeGridVec = true;
  }

  // ----------------------------------------------------------
  float getFieldValue(float x, float y)
  {
    return getFieldValue(new Vec2D(x, y));
  }

  // ----------------------------------------------------------
  float getFieldValue(Vec2D p)
  {
    if (this.gridField != null)
      return this.gridField.getValue(p);
    return 0.0;
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
    if (this.gridField != null)  
      this.gridField.prepare();
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

      // Mode "vectoriel"
      if (bModeDirect == false)
      {
        this.gridCellRender.beginCompute();
        this.gridCellRender.beginComputeStripes();

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

      // Mode Direct
      else
      {
        // all is happening in the draw
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
    //    this.bComputeGridVec = true;
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
  void updateControls()
  {
    if (bUpdateControls)
    {
      bUpdateControls = false;

      this.showGridCellRenderControls(this.gridCellRender);
      this.showGridFieldControls(this.gridField);
    }
  }

  // ----------------------------------------------------------
  void draw()
  {
    if (bDrawGrid)
    {
      pushStyle();
      noFill();
      if (bModeDirect == false)
      {
        stroke(colorStroke, 100);
        strokeWeight(1);
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
      }

      endShape();

      stroke(colorStroke, 20);
      Rect r;
      for (int i=0; i<this.rects.length; i++)
      {
        r = this.rects[i];
        rect(r.x, r.y, r.width, r.height);
      }

      popStyle();
    }


    if (gridCellRender != null)
    {
      if (bModeDirect==false)
      {
        if (bDrawPolygons)
        {
          gridCellRender.draw();
        }
        gridCellRender.drawStripes();
      } else
      {
        gridCellRender.beginDrawDirect();

        int i, j, offset;
        for (j=0; j<this.resy; j++)
        {
          for (i=0; i<this.resx; i++)
          {
            offset = i + this.resx*j;
            gridCellRender.drawDirect(rects[offset], i, j);
          }
        }

        gridCellRender.endDrawDirect();
      }
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


  // ----------------------------------------------------------
  void loadConfiguration(String name)
  {
    JSONObject jsonGrid = loadJSONObject("data/configurations/"+name+".json");

    this.setResx( jsonGrid.getInt("resx") );  
    this.setResy( jsonGrid.getInt("resy") );  

    bDarkMode = jsonGrid.getBoolean("bDarkMode");
    setupColors();

    this.bDrawGrid = jsonGrid.getBoolean("bDrawGrid");
    this.setSquare( jsonGrid.getBoolean("bSquare") );
    this.bDrawField = jsonGrid.getBoolean("bDrawField");
    this.bComputeStripes = jsonGrid.getBoolean("bComputeStripes");
    this.bDrawPolygons = jsonGrid.getBoolean("bDrawPolygons");

    this.setRndDrawCell( jsonGrid.getFloat("rndDrawCell") );
    this.setPerturbationAmount( jsonGrid.getFloat("perturbationAmount") );

    this.setGridCellRenderWithName( jsonGrid.getString("gridCellRenderName") );
    this.setGridFieldWithName( jsonGrid.getString("gridFieldName") );
  }

  // ----------------------------------------------------------
  void saveConfiguration(String name)
  {
    JSONObject jsonGrid = new JSONObject();

    jsonGrid.setBoolean("bDarkMode", bDarkMode);
    jsonGrid.setInt("resx", this.resx);
    jsonGrid.setInt("resy", this.resy);
    jsonGrid.setBoolean("bDrawGrid", bDrawGrid);
    jsonGrid.setBoolean("bSquare", bSquare);
    jsonGrid.setBoolean("bDrawField", bDrawField);
    jsonGrid.setBoolean("bComputeStripes", bComputeStripes);
    jsonGrid.setBoolean("bDrawPolygons", bDrawPolygons);
    jsonGrid.setFloat("perturbationAmount", this.perturbationAmount);
    jsonGrid.setFloat("rndDrawCell", this.rndDrawCell);
    jsonGrid.setString("gridCellRenderName", this.gridCellRender.name);
    jsonGrid.setString("gridFieldName", this.gridField.name);

    saveJSONObject(jsonGrid, "data/configurations/"+name+".json");
  }
}
