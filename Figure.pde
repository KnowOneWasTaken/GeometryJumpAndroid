class Figure {
  float x, y;
  int w, h;
  float vx;
  float vy;
  int id = 0;
  Hitbox hitbox;
  Figure(int x, int y, int w, int h, int id) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
    this.id = id;
    this.vx = 0;
    this.vy = 0;
    hitbox = new Hitbox(x, y, w, h);
  }
  Figure(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
    this.id = -1;
    this.vx = 0;
    this.vy = 0;
    this.hitbox = new Hitbox(x, y, w, h);
  }

  //creates empty Figure with id = -1 and unsolid hitbox
  Figure() {
    x = 0;
    y = 0;
    w = -1;
    h = -1;
    id = -1;
    this.vx = 0;
    this.vy = 0;
    hitbox = new Hitbox(int(x), int(y), w, h);
    hitbox.solid = false;
  }

  void show() {
    fill(255);
    stroke(255, 0, 0);
    strokeWeight(2);
    cam.drawRect(int(x), int(y), w, h);

    if (editModeOn) {
      hitbox.show();
    }
  }



  void update() {
    move(vx, vy);
    show();
  }

  void move(float dx, float dy) {
    x = x + dx;
    y = y + dy;
    hitbox.updateCoord(int(x), int(y), w, h);
  }

  void showGlow() {
  }

  PImage rotateImage(PImage img, int degree) {
    PGraphics pg = createGraphics(img.width*2, img.height*2);
    pg.pushMatrix();
    pg.beginDraw();
    pg.translate(pg.width/2, pg.height/2);
    pg.rotate(degree*TWO_PI/360f);
    pg.imageMode(CENTER);
    pg.image(img, 0, 0);
    pg.endDraw();
    pg.popMatrix();
    return pg;
  }
}
