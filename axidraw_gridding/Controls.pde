
// ------------------------------------------------------
void setupControls()
{
  cf = new ControlFrame(this, 500, height, "Controls");
  surface.setLocation(500, 10);
}

// ------------------------------------------------------
class ControlFrame extends PApplet 
{

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  Textlabel lblDessin, lblExport, lblParams, lblAnimations;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) 
  {
    super();   
    parent = _parent;
    w=_w;
    h=_h;

    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() 
  {
    size(w, h);
  }

  public void setup() 
  {
    surface.setLocation(0, 10);

//    cp5 = new ControlP5(this, new ControlFont(font15, 13));
    cp5 = new ControlP5(this);
    cp5.setColorCaptionLabel( color(#4c5575) );
    //    cp5.setColorLabel( color(255) );
    cp5.setColorActive(color(#98aab9));
    cp5.setColorForeground(color(#4c5575));
    //    cp5.setColorBackground(color(#e1a48c));
  }

  void draw() 
  {
    background( 0 );
  }


  void controlEvent(ControlEvent theEvent) 
  {
    /*    if (theEvent.isFrom(radioRender)) 
     {
     }
     */
  }

  void btnExport()
  {
  }
}
