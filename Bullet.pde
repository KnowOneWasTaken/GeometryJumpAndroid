class Bullet extends Figure {
  PImage img;
  Bullet(int x, int y, int w, int h, float vx, float vy, int id, PImage img) {
    super(x, y, w, h, id);
    this.vx = vx;
    this.vy = vy;
    this.img = img;
  }

  Bullet() {
    super();
  }

  void update() {
    move(vx, vy);
    show();
  }

  @Override
    void show() {
    cam.drawImage(img, int(x), int(y), w, h);
    if (int(random(0, 5)) == 0) {
      bulletAnimation(int(x)+w/2, int(y)+h/2, int(-vx*4+2), int(-vx*4-2), int(-vy*4+2), int(-vy*4-2));
    }
  }

  boolean mustRemove() {
    if (dist(x, y, player.x, player.y) > 100*blockSize) {
      return true;
    }
    return false;
  }
  boolean hit() {
    for (Figure f : worldFigures) {
      if (f.hitbox.solid == true && f.getClass() != missileLauncherClass.getClass()) {
        if (hitbox.overlap(f.hitbox)) {
          return true;
        }
      }
    }
    return false;
  }
}
