class Button {
  PImage img, img2, img3, img4, storage;
  boolean bigB;
  int picture;
  int x;
  int y;
  int x2;
  int y2;
  int widthB;
  int heightB;
  boolean round;
  boolean help;
  int clicked;
  float groesse = 1;
  float bigTouch = 1.1;
  float bigClick = 0.9;
  float smallTouch=0.95;
  float smallClick=0.85;
  float step = 0.07;
  boolean hitbox = true;
  boolean secondImg = false;
  color c = color(150, 150, 200);
  color d = color(200, 150, 200);
  boolean isHovered = false, isPressed = false, wasReleased = false, wasPressed = false, isMouseRealease = false, isMousePressed = false;
  boolean glow = false;
  String print = "[Button-Library] ";

  void update() {
    isHovered = touch() && hitbox;
    isPressed = touch() && mousePressed && hitbox && mouseButton==LEFT;
    boolean wasMousePressed = isMousePressed;
    isMousePressed = mousePressed && mouseButton == LEFT;
    boolean wasMouseRealease = isMouseRealease;
    isMouseRealease = !wasMouseRealease && wasMousePressed && !isMousePressed;
  }
  void show() {
    x = x2;
    y = y2;
    update();
    show2();
  }

  void showMove(int xa, int ya) {
    x = xa;
    y = ya;
    show2();
    if (help) {
      println(print+"showMove(): Button shown on: "+x+", "+y);
    }
  }

  void show2() {
    float Touch, Click;
    int w=widthB;
    int h = heightB;
    PImage pic;
    if (bigB) {
      Touch = bigTouch;
      Click = bigClick;
    } else {
      Touch = smallTouch;
      Click = smallClick;
    }
    switch (picture) {
    case 2:
      pic = img2;
      break;
    default:
      pic =img;
      break;
    }
    tint(c);
    if (touch() && touch) {
      if (mousePressed && touch) {
        if (groesse<Click) {
          if (groesse+step<Click) {
            groesse+=step;
          } else {
            groesse=Click;
          }
        } else {
          if (groesse>Click) {
            if (groesse-step>Click) {
              groesse-=step;
            } else {
              groesse=Click;
            }
          }
        }
      } else {
        noTint();
        if (groesse<Touch) {
          if (groesse+step<Touch) {
            groesse+=step;
          } else {
            groesse=Touch;
          }
        } else {
          if (groesse>Touch) {
            if (groesse-step>Touch) {
              groesse-=step;
            } else {
              groesse=Touch;
            }
          }
        }
      }
    } else {
      noTint();
      if (groesse<1) {
        if (groesse+step<1) {
          groesse+=step;
        } else {
          groesse=1;
        }
      } else {
        if (groesse>1) {
          if (groesse-step>1) {
            groesse-=step;
          } else {
            groesse=1;
          }
        }
      }
    }
    if (secondImg==false) {
      try {
        if (glow == false) {
          image(pic, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        } else {
          image(img2, (x+w*((1-groesse)/2)) - (w-(1-groesse)*w)/2, (y+(h*(1-groesse)/2)) - (h-(1-groesse)*h)/2, (w-(1-groesse)*w)*2, (h-(1-groesse)*h)*2);
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
      }
      catch(Exception e) {
        e.printStackTrace();
      }
    } else {
      if (glow == false) {
        noTint();
        if (picture==1&&mousePressed==false) {
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==1&&mousePressed==true&&touch()) {
          image(img2, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==false) {
          image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==true&&touch()) {
          image(img4, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==1&&mousePressed==true&&touch()==false) {
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==true&&touch()==false) {
          image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
      }
    }
    noTint();
  }


  boolean touch() {
    for (TouchEvent.Pointer pointer : touches) {
      if (touch(PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)) && touch) {
        return true;
      }
    }
    if (touch(mouseX, mouseY) && touch) {
      noTint();
      return true;
    }

    return false;
  }

  boolean touch(int touchX, int touchY) {
    if (hitbox) {
      if (!round) {
        int r = x+widthB;
        int b=y+heightB;
        return (touchX<r && touchX>x && touchY<b&& touchY>y);
      } else {
        return (dist(touchX, touchY, x+widthB/2, y+heightB/2) < widthB/2);
      }
    } else {
      return false;
    }
  }

  void setImg(PImage Pimage) {
    img = Pimage;
    if (help) {
      println(print+"setImg(): img set to a new PImage");
    }
  }

  PImage getImg() {
    return img;
  }

  PImage getImg2() {
    return img2;
  }
  void setImg2(PImage Pimage) {
    img2 = Pimage;
    if (help) {
      println(print+"setImg2(): img2 set to a new PImage");
    }
  }
  void setImg(PImage Pimage, PImage Pimage2) {
    img = Pimage;
    img2 = Pimage2;
    if (help) {
      println(print+"setImg(): img and img2 set to new PImage(s)");
    }
  }

  void setBig(float c, float t) {
    bigClick=c;
    bigTouch=t;
  }

  void setSmall(float c, float t) {
    smallClick=c;
    smallTouch=t;
  }

  void setStep(float c) {
    step=c;
  }

  void setHitbox(boolean b) {
    hitbox=b;
  }

  void setXY(int xa, int ya) {
    x = xa;
    y = ya;
    x2=xa;
    y2=ya;
    if (help) {
      println(print+"setXY(): x and y set to: "+x+", "+y);
    }
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  void setX(int xa) {
    x = xa;
    x2=xa;
    if (help) {
      println(print+"setX(): x set to: "+x);
    }
  }

  void setY(int ya) {
    y = ya;
    y2=ya;
    if (help) {
      println(print+"setY(): y set to: "+y);
    }
  }

  void setW(int w) {
    widthB=w;
    if (help) {
      println(print+"setW(): width set to: "+w);
    }
  }

  int getW() {
    return widthB;
  }
  void setH(int h) {
    heightB=h;
    if (help) {
      println(print+"setH(): height set to: "+y);
    }
  }
  int getH() {
    return heightB;
  }

  void setWH(int w, int h) {
    widthB = w;
    heightB = h;
    if (help) {
      println(print+"setWH(): width and height set to: "+w+", "+h);
    }
  }

  void pictureChange() {//switches the picture
    if (picture == 1) {
      picture = 2;
    } else {
      picture = 1;
    }
    if (help) {
      println(print+"pictureChange(): picture set to: "+picture);
    }
  }

  int getPicture() {
    return picture;
  }

  boolean getBig() {
    return bigB;
  }

  void setBig(boolean b) {
    bigB = b;
    if (help) {
      println(print+"setBig(): bigB set to: "+bigB);
    }
  }

  boolean getRound() {//returns round
    return round;
  }

  void setRound(boolean b) {//sets the variable round to true or false
    round = b;
    if (help) {
      println(print+"setRound(): round set to: "+round);
    }
  }

  void setPicture(int i) {//sets the picture to the integer
    if (i==1||i==2) {
      if ((picture == 1 && i == 1) || (picture == 2 && i ==2)) {
        if (help) {
          println(print+"setPicture(): picture didn't changed");
        }
      } else {
        picture = i;
        if (help) {
          println(print+"setPicture(): picture set to: "+picture);
        }
      }
    } else {
      if (help) {
        println(print+"setPicture(): The picture can not be changed to "+i+ ", it must be 1 or 2");
      }
    }
  }

  void imgChange() {//switches the pictures
    storage = img;
    img = img2;
    img2=storage;
    if (help) {
      println(print+"imgChange(): Images switched");
    }
  }
  void clickedReset() {
    clicked = 0;
  }

  void clicked() {
    println(print+"clicked(): Button clicked "+(clicked+1)+" time(s)");
    clicked++;
  }

  void clicked(boolean b) {
    if (b) {
      println(print+"clicked(): Button clicked "+(clicked+1)+" time(s)");
    }
    clicked++;
  }

  int getClicked() {
    return clicked;
  }

  void setClicked(int i) {
    clicked = i;
  }

  void standard() {
    secondImg=false;
    img3=img2;
    img4=img3;
  }

  Button(PImage imgc, PImage img2c, PImage img3c, PImage img4c, int xc, int yc, int widthBc, int heightBc, boolean roundc, boolean secondImg) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture=1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = false;
    this.secondImg=secondImg;
    img3=img3c;
    img4=img4c;
  }

  Button(PImage imgc, int xc, int yc) {//standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, int xc, int yc, int widthBc, int heightBc) {//standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc) {//standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc) {//standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int picturec) {//standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help==true) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec) {//standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(PImage imgc, int xc, int yc, boolean roundc) {//standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, boolean roundc) {//standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int picturec, boolean roundc) {//standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, int xc, int yc) {//bigB,standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc) {//bigB,standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int picturec) {//bigB,standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec) {//bigB,standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, int xc, int yc, boolean roundc) {//bigB,standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, boolean roundc) {//bigB,standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int picturec, boolean roundc) {//bigB,standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2&&help==true) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc) {//standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc) {//standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec) {//standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec) {//standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(PImage imgc, boolean helpc, int xc, int yc, boolean roundc) {//standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, boolean roundc) {//standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec, boolean roundc) {//standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc) {//bigB,standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc) {//bigB,standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec) {//bigB,standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec) {//bigB,standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, boolean roundc) {//bigB,standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, boolean roundc) {//bigB,standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec, boolean roundc) {//bigB,standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc, boolean glow) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(print+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
    this.glow = glow;
  }
}
