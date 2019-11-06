// ------------------------------------------------------
void setupMedias()
{
}

// ------------------------------------------------------
void setupLibraries()
{
}

// ------------------------------------------------------
static class Utils
{
  static String timestamp()
  {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
  }

  static float toMM(float px)
  {
    float dpi = 72; // pixels per inch 
    return px / dpi * 25.4;
  }
  
  static int toPixels(float mm)
  {
    float dpi = 72; // pixels per inch 
    return int(dpi * toInches(mm));      
  }

  static float toInches(float mm)
  {
    return mm / 25.4;
  }


}

// ------------------------------------------------------
String timestamp() 
{
  return Utils.timestamp();
}
