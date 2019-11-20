class GridCellRenderPola extends GridCellRenderTruchet
{
  // ----------------------------------------------------------
  GridCellRenderPola(Grid grid)
  {
    super(grid);
    this.name = "Pola";
  }  
  
  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    float x = rect.x;
    float y = rect.y;
    float w = rect.width;
    float h = rect.height;
  
    if (random[i][j] == 0)
    {
    }
    else if (random[i][j] == 1)
    {
    }
    else if (random[i][j] == 2)
    {
    }
    else if (random[i][j] == 3)
    {
    }
  }  
}
