final float[] angles = {(PI/4)};
class Glyph {

  float w;
  float h;
  float sw;
  float sh;
  PVector ori;
  color col;
  int numLines;
  float resolution;
  float density;
  boolean symmetry;
  boolean enableDiags;

  ArrayList<Line> lines;
  float strokeWidth;

  Glyph(float w, float h, PVector ori, color col, int resolution, int density, boolean symmetry, boolean enableDiags) {
    this.w = w;
    this.h = h;
    this.ori = ori.copy();
    this.col = col;
    this.resolution = resolution;
    this.density = density;
    this.symmetry = symmetry;
    this.enableDiags = enableDiags;

    numLines = density * resolution;
    lines = new ArrayList<Line>();
    strokeWidth = 1;
    this.generate();
    sw = w / resolution;
    sh = h / resolution;
  }

  void generate() {
    for ( int i = 0; i < numLines; ++i ) {
      boolean coinFlip = random(1) > 0.5;
      boolean coinFlip2 = random(1) > 0.5;

      int x1 = floor(random(this.symmetry ? this.resolution / 2 : this.resolution));
      int y1 = ceil(random(this.resolution - 1));
      PVector v1 = new PVector(x1, y1);
      PVector additive = new PVector();
      if (!enableDiags) {
        if (coinFlip ) {
          if ( v1.x == 0 ) {
            additive.x += 1;
          } else if ( v1.x == this.resolution - 1 ) {
            additive.x -= 1;
          } else {
            additive.x += floor(random(-1, 2));
          }
        } else {
          if ( v1.y == 0 ) {
            additive.y += 1;
          } else if ( v1.y == this.resolution - 1 ) {
            additive.y -= 1;
          } else {
            additive.y += floor(random(-1, 2));
          }
        }
      } else {
        additive.x += coinFlip ? floor(random(-1, 2)) : 0;
        additive.y += coinFlip2 ? floor(random(-1, 2)) : 0;
      }

      PVector v2 = v1.copy().add(additive);
      v2.x = ceil(constrain(v2.x, 0, resolution - 1));
      v2.y = ceil(constrain(v2.y, 0, resolution - 1));
      boolean dupe = false;
      for (Line l : lines) {
        if ((l.start.dist(v1) == 0 && l.end.dist(v2) == 0) || (l.start.dist(v2) == 0 && l.end.dist(v1) == 0)) {
          dupe = true;
          break;
        }
      }
      if (!dupe && PVector.dist(v1, v2) > 0) {
        lines.add(new Line(v1, v2));
      }
    }
  }

  void update() {
    for ( Line l : lines ) {
      l.update();
    }
  }

  void render() {
    pushMatrix();

    noFill();
    stroke(colorStroke);
    strokeWeight(strokeWidth);
    for ( Line l : lines ) {
      float x1 = sw / 2 + l.start.x * sw;
      float y1 = sh / 2 + l.start.y * sh;
      float x2 = sw / 2 + l.end.x * sw;
      float y2 = sh / 2 + l.end.y * sh;
      line(x1, y1, x2, y2);
      if ( symmetry ) {
        line(x1 + (w/2-x1)*2, y1, x2 + (w/2-x2)*2, y2);
      }
    }

    popMatrix();
  }
}

class Line {

  PVector start, startTar;
  PVector end, endTar;

  Line(PVector start, PVector end) {
    this.start = start.copy();
    this.end = end.copy();
    startTar = start.copy();
    endTar = end.copy();
  }

  void update() {
    start = PVector.lerp(start, startTar, 0.1);
    end = PVector.lerp(end, endTar, 0.1);
  }

  void moveStart(PVector force) {
    start.add(force);
  }

  void moveEnd(PVector force) {
    end.add(force);
  }
}

class GridCellRenderNoiseGlyphs extends GridCellRender
{
  GridCellRenderNoiseGlyphs() {
    super("Noise glyphs");
  }

  public void drawDirect(Rect rect, int i, int j) {
    pushMatrix();
    float value = getGridFieldValue(rect.x, rect.y);
    translate(rect.x + rect.width/2, rect.y + rect.height/2);
    float h = min(rect.height/2, rect.width/2) * value;
    rotate(value*TAU);
    line(0, 0, 0, h);
    ellipse(0, h, h, h);
    popMatrix();
  }
}



class GridCellRenderSecond extends GridCellRender implements CallbackListener
{
  float[][] vals;
  Slider sliderScale;
  float ns = 1;
  int steps = 5;
  Slider sliderSteps;

  GridCellRenderSecond()
  {
    super("perlin_vases");
  }

  void init() {
    vals = new float[this.grid.resx][this.grid.resy];
    for (int x = 0; x < this.grid.resx; x++) {
      for (int y = 0; y < this.grid.resy; y++) {
        vals[x][y] = noise(x, y);
      }
    }
  }

  void createControls()
  {
    beginCreateControls();
    
    ControlP5 cp5 = controls.cp5;

    sliderScale = cp5.addSlider( _id("scale") ).setLabel("noise scale").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.01, 1).setValue(this.ns).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);

    sliderSteps = cp5.addSlider( _id("steps") ).setLabel("steps").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(2, 100).setValue(this.ns).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);


    endCreateControls();
  }

  void drawDirect(Rect rect, int i, int j)
  {
    if (grid.bComputeGridVec)
    {
      init();
      grid.bComputeGridVec = false;
    }


    float value = getGridFieldValue(rect.x, rect.y);
    float step = rect.height / this.steps;
    ArrayList<PVector> arr = new ArrayList<PVector>();
    for (int k = 1; k < this.steps; k++) {
      arr.add(new PVector((value+noise(i*ns, j*ns, k*ns))/2*rect.width/2, k*step));
    }
    for (int k = this.steps-2; k >=0; k--) {
      arr.add(new PVector(-arr.get(k).x, arr.get(k).y));
    }
    pushMatrix();
    translate(rect.x+rect.width/2, rect.y);
    beginShape();
    for (PVector p : arr) {
      vertex(p.x, p.y);
    }
    endShape(CLOSE);
    popMatrix();
    pushMatrix();
    translate(rect.x+rect.width/2, rect.y+rect.height/2);
    ellipse(0, 0, value*rect.width/2, value*rect.height/2);
    ellipse(map(value, 0, 1, -1, 1)*rect.width/8, 0, value*rect.width/4, value*rect.height/4);
    ellipse(map(value, 0, 1, -1, 1)*rect.width/12, 0, value*rect.width/6, value*rect.height/6);
    popMatrix();
  }

  public void controlEvent(CallbackEvent theEvent) 
  {
    switch(theEvent.getAction()) 
    {
    case ControlP5.ACTION_RELEASED: 
    case ControlP5.ACTION_RELEASEDOUTSIDE:
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();
      if (name.equals(_id("scale")))
      {
        this.ns = value;
        this.init();
      }
      if (name.equals(_id("steps")))
      {
        this.steps = int(value);
        this.init();
      }
      break;
    }
  }
}


class GridCellRenderSpiro extends GridCellRender implements CallbackListener
{
  Slider sliderScale;
  float ns = 1;
  int steps = 1;
  Slider sliderSteps;
  GridCellRenderSpiro()
  {
    super("spiro");
  }

  void createControls()
  {
    beginCreateControls();

    ControlP5 cp5 = controls.cp5;

    sliderScale = cp5.addSlider( _id("scale") ).setLabel("noise scale").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.01, 1).setValue(this.ns).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);

    sliderSteps = cp5.addSlider( _id("steps") ).setLabel("steps").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(1, 10).setValue(this.ns).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);


    endCreateControls();
  }

  void drawDirect(Rect rect, int i, int j)
  {
    if (grid.bComputeGridVec)
    {
      init();
      grid.bComputeGridVec = false;
    }
      
    float value = getGridFieldValue(rect.x, rect.y);
    pushMatrix();
    translate(rect.x + rect.width/2, rect.y + rect.height/2);
    float rStep = TAU / (rect.width/(20*value));
    float dist = 2*value;
    boolean done = false;
    while (!done) {
      pushMatrix();
      float xc = cos(dist*rStep) * dist;
      float yc = sin(dist*rStep) * dist;
      float s = noise(rect.x*this.ns, rect.y*this.ns)*rect.width/4;
      if (dist >= rect.width/2 - s/2) {
        done = true;
      }
      translate(xc, yc);
      ellipse(0, 0, s, s);
      dist+=steps;
      popMatrix();
    }
    popMatrix();
  }

  public void controlEvent(CallbackEvent theEvent) 
  {
    switch(theEvent.getAction()) 
    {
    case ControlP5.ACTION_RELEASED: 
    case ControlP5.ACTION_RELEASEDOUTSIDE:
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();
      if (name.equals(_id("scale")))
      {
        this.ns = value;
        this.init();
      }
      if (name.equals(_id("steps")))
      {
        this.steps = int(value);
        this.init();
      }
      break;
    }
  }
}

class GridCellRenderToinou extends GridCellRender implements CallbackListener
{
  boolean done = false;
  Glyph[][] glyphs;
  int resolution = 8;
  int density = 10;
  Slider sliderResolution;
  Slider sliderDensity;
  boolean symmetry = true;
  boolean enableDiags = false;
  Toggle cbEnableDiags;
  Toggle cbSymmetry;
  GridCellRenderToinou()
  {
    super("Toinou");
  }
  
  void init() {
    this.glyphs =  new Glyph[this.grid.resx][this.grid.resy];
    for (int x = 0; x < this.grid.resx; x++) {
      for (int y = 0; y < this.grid.resy; y++) {
        Glyph g = new Glyph(
          this.grid.wCell, 
          this.grid.hCell, 
          new PVector(this.grid.wCell/2, this.grid.wCell/2), 
          color(0), 
          this.resolution, 
          this.density,
          this.symmetry,
          this.enableDiags
          );
        this.glyphs[x][y] = g;
      }
    }
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    if (grid.bComputeGridVec)
    {
      init();
      grid.bComputeGridVec = false;
    }
    
    pushMatrix();
    translate(rect.x, rect.y);
    if (this.glyphs != null)
      this.glyphs[i][j].render();
    popMatrix();
  }
  void createControls()
  {
    beginCreateControls();
    ControlP5 cp5 = controls.cp5;
    
    sliderResolution = cp5.addSlider( _id("resolution") ).setLabel("resolution").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(3, 18).setValue(this.resolution).setNumberOfTickMarks(16).snapToTickMarks(true).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);

    sliderDensity = cp5.addSlider( _id("density") ).setLabel("density").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(1, 20).setValue(this.density).setNumberOfTickMarks(20).snapToTickMarks(true).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);
    
    cbSymmetry = cp5.addToggle(_id("symmetry")).setLabel("symmetry").setPosition(xControl+3*hControl, yControl).setSize(hControl, hControl).setValue(this.symmetry).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);
    
    cbEnableDiags = cp5.addToggle(_id("enableDiags")).setLabel("diags").setPosition(xControl+3*hControl, yControl).setSize(hControl, hControl).setValue(this.enableDiags).setGroup(g).addCallback(this);
    yControl+=(hControl+paddingControl);

    endCreateControls();
  }
  
  public void controlEvent(CallbackEvent theEvent) 
  {
    switch(theEvent.getAction()) 
    {
    case ControlP5.ACTION_RELEASED: 
    case ControlP5.ACTION_RELEASEDOUTSIDE:
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();
      if (name.equals(_id("density")) || name.equals(_id("resolution")) || name.equals(_id("symmetry"))  || name.equals(_id("enableDiags")))
      {
        if(name.equals(_id("density"))){
          this.density = int(value);
        } else if(name.equals(_id("resolution"))) {
          this.resolution = int(value);
        } else if(name.equals(_id("symmetry"))) {
          this.symmetry = value > 0.0;
        } else if(name.equals(_id("enableDiags"))) {
          this.enableDiags = value > 0.0;
        }
        this.init();
      }
      break;
    }
  }
}
