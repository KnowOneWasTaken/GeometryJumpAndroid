class Wall extends Figure {
  int blockX, blockY, blockW, blockH;
  PImage box = wall, glow = wallGlow;
  Wall(int x, int y, int w, int h, int id) {
    super(x*blockSize, y*blockSize, w*blockSize, h*blockSize);
    this.blockX = x;
    this.blockY = y;
    this.blockW = w;
    this.blockH = h;
    this.id = id;
    box = wall;
    glow = wallGlow;
  }
  
  Wall() {
    super();
    this.blockX = 0;
    this.blockY = 0;
    this.blockW = -1;
    this.blockH = -1;
    this.id = -1;
    box = wall;
    glow = wallGlow;
  }

  @Override void show() {
    show(box);
  }

  @Override void showGlow() {
    showGlow(glow);
  }
  void show(PImage img) {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(img, int(x)+i*blockSize, int(y)+j*blockSize, blockSize, blockSize);
      }
    }
  }
  
  void showGlow(PImage img) {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(img, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize), blockSize*2, blockSize*2);
      }
    }
  }
}
