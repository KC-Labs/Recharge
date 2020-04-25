
// device ratio with respect to iPhone 11 18:9 screen

double designWidth = 375.0;
double designHeight = 812.0;

double currentWidth;
double currentHeight;

double widthRatio = currentWidth / designWidth;
double heightRatio = currentHeight / designHeight;

double iPhoneXRatio() {
  if ((currentHeight / currentWidth) < (16 / 9)) {
    //if screen is shorter than design (android w bottom navigation)
    return heightRatio;
  } else if ((currentHeight / currentWidth) > (16 / 9)) {
    //if screen is longer than design (iPhone X, galaxy, etc.)
    return widthRatio;
  } else {
    //design size (default)
    return widthRatio;
  }
}
