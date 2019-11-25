class GridCellRenderVera extends GridCellRender{
  
  GridCellRenderVera()
  {
    super("Vera");
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
    float v = this.grid.getFieldValue(x, y);
    randomSeed(floor(v));
    int rndIndex = floor(random(0, 4));
    int rndIndex2 = floor(random(0, 4));
    while (rndIndex == rndIndex2) {
      rndIndex2 = floor(random(0, 4));
    }

    if (rndIndex != 0 && rndIndex2 != 0) {
      line(x, y, x+w, y);
    } 

    if (rndIndex != 1 && rndIndex2 != 1) {
      line(x+w, y, x+w, y+h);
    } 

    if (rndIndex != 2 && rndIndex2 != 2) {
      line(x, y+h, x+w, y+h);
    } 

    if (rndIndex != 3 && rndIndex2 != 3) {
      line(x, y, x, y+h);
    }
  }
}
