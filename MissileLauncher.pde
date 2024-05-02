class MissileLauncher extends Wall {
  int direction = 0;
  int interval = 100;
  int timer = 0;
  int offset = 0;
  int bulletLength = 40;
  int bulletHeight = 20;
  float bulletSpeed = 10;
  PImage img = missileLauncher;
  //0: right
  //1: left
  //2: up
  //3: down
  MissileLauncher(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    this.glow = missileLauncherGlow;
    this.offset = framesSinceStarted % interval;
  }
  MissileLauncher(int x, int y, int w, int h, int id, int interval, int offset, int direction) {
    super(x, y, w, h, id);
    this.glow = missileLauncherGlow;
    this.offset = offset;
    this.direction = direction;
    this.interval = interval;
    if (framesSinceStarted == 0) {
      this.timer = offset;
    } else {
      this.timer = 0;
    }
    if (direction == 0) {
      img = rotateImage(missileLauncher, 0);
    } else if (direction == 1) {
      img = rotateImage(missileLauncher, 180);
    } else if (direction == 2) {
      img = rotateImage(missileLauncher, -90);
    } else if (direction == 3) {
      img = rotateImage(missileLauncher, +90);
    } else {
      img = rotateImage(missileLauncher, 0);
    }
  }

  MissileLauncher() {
    super();
  }

  void shoot() {
    if (direction == 0) { //right
      projectiles.add(new Bullet(int(x+w-bulletLength), int(y)+(h-bulletHeight)/2, bulletLength, bulletHeight, bulletSpeed, 0, projectiles.size(), Bullet1));
    } else if (direction == 1) { //left
      projectiles.add(new Bullet(int(x), int(y)+(h-bulletHeight)/2, bulletLength, bulletHeight, -bulletSpeed, 0, projectiles.size(), Bullet2));
    } else if (direction == 2) { //up
      projectiles.add(new Bullet(int(x+(w-bulletHeight)/2), int(y), bulletHeight, bulletLength, 0, -bulletSpeed, projectiles.size(), Bullet3));
    } else if (direction == 3) { //down
      projectiles.add(new Bullet(int(x+(w-bulletHeight)/2), int(y)+h-bulletLength, bulletHeight, bulletLength, 0, bulletSpeed, projectiles.size(), Bullet4));
    } else {
      println("MissileLauncher: id: "+id+"; Wrong direction: "+direction);
      direction = 0;
      interval = 100;
      timer = 0;
    }
  }

  @Override
    void show() {
    cam.drawImage(img, int(x - w/2), int(y-h/2), w*2, h*2);
    textAlign(CENTER);
    fill(255);
    textSize(blockSize/2);
    if (direction == 0) {
      cam.drawText(str(timer), int(x+w/2+w/4), int(y+h/2+blockSize/7.7));
    } else if (direction == 1) {
      cam.drawText(str(timer), int(x+w/2-w/4), int(y+h/2+blockSize/7.7));
    } else if (direction == 2) {
      cam.drawText(str(timer), int(x+w/2), int(y+h/4+blockSize/7.7));
    } else if (direction == 3) {
      cam.drawText(str(timer), int(x+w/2), int(y+h/2+blockSize/7.7 + h/4));
    } else {
      cam.drawText(str(timer), int(x+w/2+w/4), int(y+h/2+blockSize/7.7));
    }
    textAlign(LEFT);
    if (timer > 0) {
      timer--;
    } else {
      shoot();
      timer = interval;
    }
  }
}
