class Cam {
  int x, y;
  float camDampener = 0.72; //1 -> infinite large dampener; 0-> no dampener
  Cam(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void drawRect(int px, int py, int pw, int ph) {
    rect((px-x)*gameZoom, (py-y)*gameZoom, (pw)*gameZoom, (ph)*gameZoom);
  }

  void drawLine(int x1, int y1, int x2, int y2) {
    line((x1-x)*gameZoom, (y1-y)*gameZoom, (x2-x)*gameZoom, (y2-y)*gameZoom);
  }

  void update() {
    int playerX = int((player.x + player.w/2) - (width/2)/gameZoom);
    int playerY = int((player.y + player.h/2) - (height/2)/gameZoom);
    x = int(camDampener *(x-playerX) + playerX);
    y = int(camDampener * (y-playerY) + playerY);
  }

  void drawImage(PImage img, int x1, int y1, int w1, int h1) {
    image(img, (x1-x)*gameZoom, (y1-y)*gameZoom, w1*gameZoom, h1*gameZoom);
  }
  
  void drawText(String s, int x1, int y1) {
    text(s, (x1-x)*gameZoom, (y1-y)*gameZoom);
  }

  PVector getInImageCoord(int px, int py) {
    return new PVector((px-x)*gameZoom, (py-y)*gameZoom);
  }
  
  int getInWorldX(int px) {
    return int(((x+(px)/gameZoom)*1f)*gameZoom);
  }
  int getInWorldY(int py) {
    return int(((y+(py)/gameZoom)*1f)*gameZoom);
  }

  PVector getInWorldCoord(int px, int py) {
    return new PVector(int((x+(px)/gameZoom)*1f), int((y+(py)/gameZoom)*1f));
  }
  PVector getInWorldCoord(PVector v) {
    return new PVector(int(((x+(v.x)/gameZoom)*1f)*gameZoom), int(((y+(v.y)/gameZoom)*1f)*gameZoom));
  }
  
  int getInWorldXbyBlock(int px) {
   return int(getInWorldCoordBlock(int(getInImageCoord(px,0).x),0).x);
  }
  int getInWorldYbyBlock(int py) {
   return int(getInWorldCoordBlock(0,int(getInImageCoord(py,0).x)).y);
  }
  
  int getDisplayCoordX(int px) {
     return px-x;
  }
  int getDisplayCoordY(int py) {
     return py-y;
  }

//Returns the coordinates of the block that is at the specified on-screen-coordinates
  PVector getInWorldCoordBlock(int px, int py) {
    float rx = ((x+(px)/gameZoom)*1f/blockSize);
    float ry = ((y+(py)/gameZoom)*1f/blockSize);
    if (rx<0) {
      rx = -ceil(-rx); //rounds up
    } else {
      rx = int(rx); //rounds down
    }
    if (ry<0) {
      ry = -ceil(-ry);
    } else {
      ry = int(ry);
    }
    return new PVector(rx, ry);
  }
  
  
  //Returns the rotated image (to the left): currently not called / used
  PImage rotateImage(PImage img) {
    PImage img2 = img;
    img = new PImage(img.height, img.width);
    img2.loadPixels();
    img.loadPixels();
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        img.pixels[x+img2.width*y] = img2.pixels[(img2.height-y-1)+img2.height*x];
      }
    }
    img.updatePixels();
    return img;
  }
}
