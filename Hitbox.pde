class Hitbox {
  int x1, y1, x2, y2, x3, y3, x4, y4, w, h;
  boolean solid = true;

  Hitbox(int x, int y, int w, int h) {
    this.x1 = x; //top left corner
    this.y1 = y;
    this.x2 = x + w; //top right corner
    this.y2 = y;
    this.x3 = x + w; //bottom right corner
    this.y3 = y+h;
    this.x4 = x; //bottom left corner
    this.y4 = y + h;
    this.w = w;
    this.h = h;
  }

  void updateCoord(int x, int y, int w, int h) {
    this.x1 = x; //top left corner
    this.y1 = y;
    this.x2 = x + w; //top right corner
    this.y2 = y;
    this.x3 = x + w; //bottom right corner
    this.y3 = y+h;
    this.x4 = x; //bottom left corner
    this.y4 = y + h;
    this.w = w;
    this.h = h;
    if (debug) {
      show();
    }
  }

  void show() {
    fill(0, 0, 0, 0);
    stroke(0, 255, 0);
    strokeWeight(1);
    cam.drawRect(x1, y1, w, h);
    strokeWeight(2);
  }

  //returns true, if the specified hitbox is within the hitbox of itself
  boolean overlap(Hitbox h) {
    if (h.x2 > x1 && h.x1 < x2) {
      if (h.y3 > y1 && h.y1 < y3) {
        return true;
      }
    }
    return false;
  }



  PVector findNearestExit(Hitbox hitbox, float vx, float vy) {
    if (overlap(hitbox)) {
      boolean xMovement = abs(vx) > 0.01; //true
      boolean yMovement = abs(vy) > 0.01; //false
      boolean right = vx > 0; //false
      boolean down = vy > 0; //false
      int xExit = 0;
      int yExit = 0;
      if (xMovement && right) { //false
        xExit = hitbox.x1 - x2;
      }
      if (xMovement && !right) { //true
        xExit = hitbox.x2 - x1;
      }
      if (yMovement && down) {
        yExit = hitbox.y1 - y3;
      }
      if (yMovement && !down) {
        yExit = hitbox.y3 - y1;
      }
      if (yMovement && xMovement) {
        if (abs(xExit) < abs(yExit)) {
          return new PVector(xExit, 0);
        } else {
          return new PVector(0, yExit);
        }
      } else if (xMovement) {
        return new PVector(xExit, 0);
      } else {
        return new PVector(0, yExit);
      }
    } else {
      return null;
    }
  }

  boolean[] findCornerInHitbox(Hitbox h) {
    boolean[] corners = new boolean[4];
    for (boolean b : corners) {
      b = false;
    }
    if (pointInHitbox(h.x1, h.y1)) {
      corners[0] = true;
    }
    if (pointInHitbox(h.x2, h.y2)) {
      corners[1] = true;
    }
    if (pointInHitbox(h.x3, h.y3)) {
      corners[2] = true;
    }
    if (pointInHitbox(h.x4, h.y4)) {
      corners[3] = true;
    }
    return corners;
  }

  boolean pointInHitbox(int px, int py) {
    return px > x1 && px < x2 && py > y1 && py < y3;
  }

  boolean pointInHitbox(PVector v) {
    return pointInHitbox(int(v.x), int(v.y));
  }
}
