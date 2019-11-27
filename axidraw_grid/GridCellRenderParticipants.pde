class GridCellRenderArnaud extends GridCellRender 
{
  float scale = 0.10;  
  float scale2 = 0.10;  
  float scale3= 1;

  Slider sliderScale;
  Slider sliderScale2;
  Slider sliderScale3;

  GridCellRenderArnaud()
  {
    super("Arnaud");
  }

  // ----------------------------------------------------------
  int getValueInt(float rx, float ry, float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }

  // ----------------------------------------------------------
  void createControls()
  {
    beginCreateControls();
    ControlP5 cp5 = controls.cp5; 
    sliderScale = cp5.addSlider( _id("scale") ).setLabel("rotation").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.1, 0.50).setValue(this.scale).setGroup(g);
    yControl+=hControl+paddingControl;
    sliderScale2 = cp5.addSlider( _id("scale2") ).setLabel("abime").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.1, 17).setValue(this.scale).setGroup(g);
    yControl+=hControl+paddingControl; // saut de deligne
    sliderScale3 = cp5.addSlider( _id("scale3") ).setLabel("nbC").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(1, 17).setValue(this.scale).setGroup(g);
    cp5.setBroadcast(true);

    endCreateControls();
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j )
  {
    pushMatrix();
    translate(rect.x + rect.width/2, rect.y + rect.height/2);

    scale = sliderScale.getValue();
    scale2 = sliderScale2.getValue();
    scale3 = sliderScale3.getValue();
    float value = getGridFieldValue(rect.x, rect.y);
    float l = value*scale*max(rect.width, rect.height);
    float pas = scale2;

    int abime = 0 ;
    for (abime = 1; abime <= scale3; abime = abime +1 ) 
    {
      rect(0-rect.width/4*(value*10), 0-rect.width/4 * (value*10), rect.width/2 - (abime * pas), rect.width/2 -(abime * pas));
      rotate(scale);
      noFill();
    }
    popMatrix();

    //float pas = map(value, 0, 1, 20, 40);
    /* for (float rot=0; rot<=360; rot =rot+pas)
     {
     
     rotate( radians(rot) );
     line(0, 0, l, 0);
     popMatrix();
     }
     
     */
    /*
    boolean n = grid.bDrawCell[i+grid.resx*j];
     if (!n) return;
     
     pushMatrix();
     translate(rect.x + rect.width/2, rect.y + rect.height/2);
     
     fill(55);
     
     float value = getGridFieldValue(rect.x, rect.y);
     scale = sliderScale.getValue();
     int rot = 1;
     */
    /* for (rot=0; rot<=360; rot =rot+20)
     {
     pushMatrix();
     rotate( radians(rot) );
     line(0, 0, rect.width*scale*value*noise(rot+i*10+j*2), 0); 
     popMatrix();
     }
     
     ellipse(0, 0, scale*rect.width*noise(i*100+j*2) , scale*rect.width*noise(+i*10+j*2));
     
     rectMode(CENTER);
     rotate( radians(i * j*rot) );
     rect( 0, 0, -scale*20 +50*noise(i*10+j*2), -scale*20+50*noise(i*10+j*2) );
     //fill(255);
     ellipse(0, 0, 1, 1);
     popMatrix();*/
  }
}
class GridCellRenderTruchetCaroA extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  // Scale along x,y axis

  // ----------------------------------------------------------
  // Controls

  // ----------------------------------------------------------
  GridCellRenderTruchetCaroA()
  {
    super("CaroA");
  }

  // ----------------------------------------------------------
  GridCellRenderTruchetCaroA(String name)
  {
    super(name);
  }

  // ----------------------------------------------------------
  int getValueInt(float rx, float ry,  float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    int r = getValueInt(rect.x,rect.y,0.0,3.0);

    pushMatrix();
    translate(x,y);
    
    //if (r == 0)
    //{
    //  line(0, 0, w, h);
    //} else if (r == 1)
    //{
    //  line(0, h, w, 0);
    //} else if (r == 2)
    //{
    //  line(w/2, 0, w/2, h);
    //} else if (r == 3)
    //{
    //  line(0, h/2, w, h/2);
    //}

    //variable non stop
    float a = random(0,1);
//    println(a);
    
    //variable liée à la couleur
    float c = getGridFieldValue (x,y);

    if (r == 0)
    {
      triangle(0,0, w,h*a, 0,h*c);
    } else if (r == 1)
    {
      triangle(w*c,0, w,0, w*a,h);
    } else if (r == 2)
    {
      triangle(w,h*c, w,h, 0,h*a);
    } else if (r == 3)
    {
      triangle(0,h, w*a,0, w*c,h);
    }
    popMatrix();
  }

  // ----------------------------------------------------------
  public void controlEvent(CallbackEvent theEvent) 
  {
  }
}


class GridCellRenderTruchetCaroD extends GridCellRender implements CallbackListener
{
  // ----------------------------------------------------------
  // Parameters
  // Scale along x,y axis

  // ----------------------------------------------------------
  // Controls

  // ----------------------------------------------------------
  GridCellRenderTruchetCaroD()
  {
    super("CaroD");
  }

  // ----------------------------------------------------------
  GridCellRenderTruchetCaroD(String name)
  {
    super(name);
  }

  // ----------------------------------------------------------
  int getValueInt(float rx, float ry,  float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    int r = getValueInt(rect.x,rect.y,0.0,3.0);
    int nbLinesy = 8;
    int nbLinesx = 3;

    //variable non stop
    float a = random(0,1);
//    println(a);
    
    //variable liée à la couleur
    float c = getGridFieldValue (x,y);

    pushMatrix();
    translate(x,y);

    

    if (r == 0)
    {
      float stepy = h / float( nbLinesy-1 );
      for ( float y1 = 0; y1 <= h; y1+=stepy)
      {
        line(w*a,h*a, 0,y1);
      }
    } 
    else if (r == 1)
    {
      float stepx = w / float( nbLinesx-1 );
      for ( float x1 = 0; x1 <= w; x1+=stepx)
      {
        line(w*a,h*a, x1,0);
      }
    } 
    else if (r == 2)
    {
      float stepy = h / float( nbLinesy-1 );
      for ( float y2 = 0; y2 <= h; y2+=stepy)
      {
        line(w*a,h*a, w,y2);
      }
    } 
    else if (r == 3)
    {
      float stepx = w / float( nbLinesx-1 );
      for ( float x2 = 0; x2 <= w; x2+=stepx)
      {
        line(w*a,h*a, x2,h);
      }
    }
    

    
    popMatrix();
  }

  // ----------------------------------------------------------
  public void controlEvent(CallbackEvent theEvent) 
  {
  }
}

class GridCellRenderStereolux1 extends GridCellRender 
{
  
  float scale = 1.0;
  boolean bTruchet = false;
  boolean bColor1 = true;
  boolean bColor2 = true;
  
  Slider sliderScale;
  Toggle toggleTruchet;
  Toggle toggleColor1;
  Toggle toggleColor2;
  
  GridCellRenderStereolux1()
  {
    super("Stereolux1");
  }

  int getValueInt(float rx, float ry, float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }

void createControls()
  {
    beginCreateControls();

    ControlP5 cp5 = controls.cp5;
    sliderScale = cp5.addSlider( _id("scale") ).setLabel("scale").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.1, 4.0).setValue(this.scale).setGroup(g);
    toggleTruchet = cp5.addToggle("enableTruchet").setLabel("truchet").setPosition(xControl, yControl+2*hControl).setSize(hControl, hControl).setValue(this.bTruchet).setGroup(g);
    toggleColor1 = cp5.addToggle("enableColor1").setLabel("color1").setPosition(xControl+2*hControl, yControl+2*hControl).setSize(hControl, hControl).setValue(this.bColor1).setGroup(g);
    toggleColor2 = cp5.addToggle("enableColor2").setLabel("color2").setPosition(xControl+4*hControl, yControl+2*hControl).setSize(hControl, hControl).setValue(this.bColor2).setGroup(g);

    endCreateControls();

  }
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    boolean b = grid.bDrawCell[i+grid.resx*j];
    
    pushMatrix();
    translate(rect.x, rect.y);
    scale(sliderScale.getValue());
    strokeWeight(0);
    //    line(0, 0, rect.width/2, rect.height/2);
    //    line(0, rect.height, rect.width/2, 0);
    ellipseMode(CENTER);

    translate(rect.width/2, rect.height/2);
    
    int r = getValueInt(rect.x, rect.y, 0.0, rect.width);

    int truc = getValueInt(rect.x, rect.y, 0.0, 3.0);
    
    rotate(2*PI*noise(i*10+j*2));
    
    if (toggleTruchet.getState())
      rotate(PI/2*truc);

    if (b)
      drawSymbol(rect, truc);
    popMatrix();
  }

  void drawSymbol(Rect rect, float value)
  {
    //   float x = rect.x;
    //float y = rect.y;
    float w = rect.width;
    float h = rect.height;

    int nbRays = getValueInt(rect.x, rect.y, 1.0, 4.0);
    nbRays = (int)pow(2, (float)nbRays);

    rectMode(CENTER);
    strokeWeight(0.5);
    stroke(255,255,255);
    
    
    
    for (int i=0;i < w; i +=nbRays)
    {
      if (toggleColor1.getState())
      {
        stroke(color(230,60,50));
        rect(0,0,i,i);
      }
      if (toggleColor2.getState())
      {
        stroke(color(70,40,230));
        rect(0,0,i+nbRays/2,i+nbRays/2);
      }
    }
    
    
/*  
  
    for (int i = 0; i < nbRays; i++)
    {
      ellipse(0,0,i*(w)/nbRays,i*(h)/nbRays*sliderScale.getValue());
    }
*/  
    
/*
    for (float y=0; y <= min(h,w)/2; y = y + (min(h,w)/nbRays))
    {
      line(0, 0, max(h/2,w/2), y);
    }
    
    for (float y= -min(h,w)/2; y <= 0; y = y + (min(h,w)/nbRays))
    {
      line(0, 0, max(h/2,w/2), y);
    }
  */  

}


  void drawSnail(Rect rect)
  {
    pushMatrix();

    int r = getValueInt(rect.x, rect.y, 0.0, rect.width);
    //ellipse(rect.width/2, rect.height/2,r,r);

    float angle = 0.0;
    float maxRadius = getValueInt(rect.x, rect.y, 0.0, rect.width);
    PVector vecStart = new PVector(0, 0);
    PVector vecEnd = new PVector(0, 0);

    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    float radius = 0;


    int nbSteps = 20;
    float angleStep = 2*PI/nbSteps;
    int nbTours = 1;
    float radiusStep = maxRadius / (nbSteps*nbTours);

    translate(rect.width/2, rect.height/2);

    for (int index = 0; index < nbSteps*nbTours; index++)
    {
      vecStart.x = radius * cos(angle);
      vecStart.y = radius * sin(angle);
      angle += angleStep;
      radius += radiusStep;
      vecEnd.x = radius * cos(angle);
      vecEnd.y = radius * sin(angle);
      line(vecStart.x, vecStart.y, vecEnd.x, vecEnd.y);
      line(0, 0, vecEnd.x, vecEnd.y);
    }

    popMatrix();
  }
}

class GridCellRenderThomas extends GridCellRender 
{
  float[] len = {5, 5};
  float angle = PI/32;
  int start = 10000000;
  int num = 200;
  PVector origin;
  int n_sets = 1;
  
  Slider sliderAngle;
  Slider sliderNum;
  Slider sliderLength;

  GridCellRenderThomas()
  {
    super("Thomas");
  }


  // ----------------------------------------------------------
  void createControls()
  {
    beginCreateControls();
    
    sliderAngle = controls.cp5.addSlider( _id("scaleangle") ).setLabel("angle").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0, PI/2).setValue(this.angle).setGroup(g);
    sliderNum = controls.cp5.addSlider( _id("scalenum") ).setLabel("num").setPosition(xControl, yControl+30).setSize(wControl, hControl).setRange(0, 1000).setValue(this.num).setGroup(g);
    sliderLength = controls.cp5.addSlider( _id("scaleLength") ).setLabel("length").setPosition(xControl, yControl+60).setSize(wControl, hControl).setRange(1, 20).setValue(this.num).setGroup(g);
    yControl+=(hControl+paddingControl);


    endCreateControls();
  }
  // https://en.wikipedia.org/wiki/Collatz_conjecture
  long collatz(long n) {
    if (n % 2 == 0) {
      return n / 2;
    } else {
      return (3*n + 1) / 2;
    }
  }

  void cycle(int s, int e, float a, float r, PVector o)
  {
    for (int i = s; i < e; i++) {
      LongList seq = new LongList();
      resetMatrix();
      translate(o.x, o.y);
      rotate(r);
      long n = i;
      int steps = 0;
      do {
        seq.append(n);
        n = collatz(n);
        steps++;
      } while (n != 1);
      seq.append(1);
      seq.reverse();
      beginShape(LINES);
      for (int j = 0; j < seq.size(); j++)
      {
        long value = seq.get(j);
        if (value % 2 == 0) {
          rotate(a);
        } else {
          rotate(-a);
        }
        float l = random(len[0], len[1]);

       // line(0, 0, 0, l);
       vertex(0,0);
        vertex(0,l);
        translate(0, l);
      }
      endShape();
    }
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float r = getGridFieldValue(rect.x, rect.y);
    this.angle = sliderAngle.getValue();
    this.num = int(sliderNum.getValue());
    this.len[0] = sliderLength.getValue();
    this.len[1] = sliderLength.getValue();
   // this.angle = map(r,0.4,0.7,0,PI/2);
    pushMatrix();
    origin = new PVector(rect.x+rect.width/2, rect.y+rect.height/2);
   //origin = new PVector(rect.x+rect.width/2, rect.y);
    cycle(start, start+num, angle, 0, origin);
    popMatrix();
  }
}

class GridCellRenderCedric extends GridCellRender 
{
  float scale = 2.0;
  Slider sliderScale;
  
  float radius;
  Slider sliderRadius;
  
  GridCellRenderCedric()
  {
    super("Cedric");
  }
  
  int getValueInt(float rx, float ry,  float vMin, float vMax)
  {
    return  int(map( getGridFieldValue(rx, ry), 0.0, 1.0, vMin, vMax+1.0 ));
  }
  
  void createControls() 
  {
    beginCreateControls();
    ControlP5 cp5 = controls.cp5;

    sliderScale = cp5.addSlider( _id("scale") ).setLabel("scale").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.1, 2.0).setValue(this.scale).setGroup(g);
    yControl+=(hControl+paddingControl);
    sliderRadius = cp5.addSlider( _id("radius") ).setLabel("radius").setPosition(xControl, yControl).setSize(wControl, hControl).setRange(0.1, 2.0).setValue(this.radius).setGroup(g);

    endCreateControls();
  }
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    pushMatrix();
    translate(rect.x, rect.y);
    
    float value = getGridFieldValue( rect.x, rect.y );
    
    scale = sliderScale.getValue();

     //ellipse(rect.width/2, rect.height/2, value*scale*rect.width, value*scale*rect.height);
    
    //arc(rect.width/2, rect.height/2, rect.x, rect.y, 0, HALF_PI);
    //ellipse((rect.width/2)*rand, (rect.height/2)*rand, value*scale*rect.width, value*scale*rect.height);
    
    
    
    int circleResolution = (int) map(value, 0,1, 2,25);
    // int(sliderCircleResolution.getValue());
    
    //int circleResolution = 10; //(int) map(mouseY, 0,height, 2,80);
    //float radius = rect.width/2 + 0.5; //mouseX-width/2 + 0.5;
    float radius = sliderRadius.getValue() * (rect.width/2);
    float angle = TWO_PI/circleResolution;
  
    beginShape();
    for (int k=0; k<=circleResolution; k++){
      float x = cos(angle*k) * radius;
      float y = sin(angle*k) * radius;
      //line(0, 0, x, y);
      //line(rect.width/2, rect.height/2, (rect.width/2)+x, (rect.height/2)+y);
     // vertex(x, y);
    }
    endShape();

    int circleCount;
    float endSize, endOffset;

    circleCount = 5;
    endSize = 0; 
    endOffset = (rect.width-endSize)/2; //map(valY, 0,rect.height, 0,(tileWidth-endSize)/2);
  
    int toggle = getValueInt(rect.x,rect.y,0.0,3.0);
      //println(toggle);
    if (toggle == 0) rotate(-HALF_PI);  
      if (toggle == 1) rotate(0);  
      if (toggle == 2) rotate(HALF_PI);  
      if (toggle == 3) rotate(PI);  
      
      // draw module
      for(int k=0; k<circleCount; k++) {
        float diameter = map(k, 0,circleCount-1, rect.width,endSize);
        float offset = map(k, 0,circleCount-1, 0,endOffset);
        
        if (toggle == 0) ellipse(offset-(rect.width/2),  (rect.height/2) + 0, diameter,diameter);
        if (toggle == 1) ellipse(offset+(rect.width/2),  rect.height/2, diameter,diameter);
        if (toggle == 2) ellipse(offset+(rect.width/2),  -rect.height/2, diameter,diameter);
        if (toggle == 3) ellipse(offset-(rect.width/2),  -rect.height/2, diameter,diameter);
        //ellipse(offset-(rect.width/2),  0 - (rect.height/2), diameter,diameter);
      }
      
    
    /*
    
    translate(rect.width/2, rect.height);
    
    int r = getValueInt( rect.x, rect.y, 0.0, 3.0 );
    int nbLines = 5;

    if (r == 0)
    {
      float stepx = rect.width / float( nbLines-1 );
      for ( float x = -rect.width/2; x <= rect.width/2+1; x+=stepx)
      {
        line(0, 0, x, -rect.height/2);
      }
    } else if (r == 1)
    {
      float stepx = rect.width / float( nbLines-1 );
      for ( float x = -rect.width/2; x <= rect.width/2+1; x+=stepx)
      {
        line(0, 0, x, rect.height/2);
      }
    } else if (r == 2)
    {
      float stepy = rect.height / float( nbLines-1 );
      for ( float y = -rect.height/2; y <= rect.height/2+1; y+=stepy)
      {
        line(0, 0, rect.width/2, y);
      }
    } else if (r == 3)
    {
      float stepy = rect.height / float( nbLines-1 );
      for ( float y = -rect.height/2; y <= rect.height/2+1; y+=stepy)
      {
        line(0, 0, -rect.width/2, y);
      }
    }*/
    
    

    //line(0, 0, rect.width/2, rect.height/2);
    //line(0, rect.height, rect.width, 0);
    
    
    
    /*point(rect.width/2, rect.height/2);
    line(rect.width/2,rect.height/2, rect.width,0);
    line(rect.width/2,rect.height/2, rect.width,rect.height);
    //ellipse(width/2,height/2, 30,30);
    rect(0,0, value * rect.width/2, value * rect.height/2);*/


    
    popMatrix();
  }
}
