class GridCellRenderTemplate extends GridCellRender 
{
  GridCellRenderTemplate()
  {
    super("Template");
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    pushMatrix();
    translate(rect.x, rect.y);

    line(0, 0, rect.width/2, rect.height/2);
    line(0, rect.height, rect.width, 0);
    
    popMatrix();
  }
}
