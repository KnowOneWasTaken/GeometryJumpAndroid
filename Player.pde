class Player extends Figure {
  boolean grounded;
  float x, y, w, h;
  int blockX, blockY;
  PVector checkpointBlock = new PVector(0, -1);
  //int stepsX = 0;
  //int stepsY = 0;
  ArrayList<Figure> nearbyFigures = new ArrayList<Figure>();

  Player(int x, int y, int w, int h) {
    super(x*blockSize, y*blockSize, w, h);
    this.x = x*blockSize;
    this.y = y*blockSize;
    this.w = w;
    this.h = h;
    this.checkpointBlock = new PVector(0, -1);
    this.grounded = false;
    //this.stepsX = 0;
    //this.stepsY = 0;
  }

  void gravity() {
    if (gravity || editModeOn == false) {
      vy = vy +1;
      if (y>100*blockSize) {
        resetToCheckpoint(true);
      }
    }
  }

  void resetToCheckpoint(boolean animation) {
    resetToCheckpoint(animation, int(x), int(y));
  }

  void resetToCheckpoint(boolean animation, int px, int py) {
    if (animation) {
      deathAnimation(int(px), int(py));
      //reloadFigures("level"+level);
      //coinsCollected = 0;
    }
    if (getFigureAt(int(checkpointBlock.x*blockSize+blockSize/2), int(checkpointBlock.y*blockSize+blockSize+blockSize/2)).getClass() == checkpointClass.getClass()) {
      player.x = checkpointBlock.x*blockSize;
      player.y = checkpointBlock.y*blockSize;
    } else {
      if (!gameFinished) {
        framesSinceStarted = 0;
      }
      player.x = 0;
      player.y = -blockSize;
    }
    if (worldFigures.size() != 0) {
      playSound(reset, 0.5*SoundEffectsSwitch.timer, true);
    }
    vx = 0;
    vy = 0;
  }

  void jump() {
    if (grounded) {
      if (getFigureAt(int(x+w/10f), int(y-h/5f)).hitbox.solid == false && getFigureAt(int(x+w-w/10f), int(y-h/5f)).hitbox.solid == false) {
        if (vy > -16) { //should prevent double jump
          vy = vy - 18;
        }
        playSound(jump, 0.5*SoundEffectsSwitch.timer, true);
      }
    }
  }

  void move(float dx, float dy) {
    x = x + dx*(blockSize/60f);
    y = y + dy*(blockSize/60f);

    hitbox.updateCoord(int(x), int(y), int(w), int(h));
  }

  @Override void show() {
    cam.drawImage(play, int(x), int(y), int(w), int(h));
    stroke(255, 0, 0);
    //displays data on the top left corner
    //if (editModeOn) {
    int text = 4;
    if (debug) {
      fill(255);
      textSize(10*text);
      noStroke();
      text("grounded: "+grounded, 10*text, 10*text);
      text("vx: "+vx, 10*text, 22*text, 10*text);
      text("vy: "+vy, 10*text, 34*text, 10*text);
      text("x: "+x, 10*text, (22+24)*text, 10*text);
      text("y: "+y, 10*text, (34+24)*text, 10*text);
      text("mouseX: "+cam.getInWorldX(mouseX), 10*text, (22+24+24)*text, 10*text);
      text("mouseY: "+cam.getInWorldY(mouseY), 10*text, (34+24+24)*text, 10*text);
      text("BlockX: "+cam.getInWorldCoordBlock(mouseX, mouseY).x, 10*text, (22+24*3)*text, 10*text);
      text("BlockY: "+cam.getInWorldCoordBlock(mouseX, mouseY).y, 10*text, (34+24*3)*text, 10*text);
      text("editModeOn: "+editModeOn, 10*text, (22+24*4)*text, 10*text);
      text("Coins collected: "+coinsCollected, 10*text, (34+24*4)*text, 10*text);
      text("frameRate: "+frameRate, 10*text, (34+24*4+12)*text, 10*text);
      if (editModeOn) {
        text("gravity: "+gravity, 10*text, (34+24*5)*text, 10*text);
      }
    }
  }

  @Override void update() {
    gravity();
    nearbyFigures.clear();
    for (Figure f : worldFigures) {
      if (dist(f.x+f.w, f.y+f.h, x+w, y+h) < 4*blockSize) {
        nearbyFigures.add(f);
      }
    }

    float iterations = floor(sqrt(sq(vx)+sq(vy))/20f)+2f;
    for (int i = 0; i < iterations; i++) {
      move(vx*(blockSize/60f)/iterations, vy*(blockSize/60f)/iterations);
      if (i+1<iterations) {
        hitbox(false);
      }
    }
    //move(vx/2f, vy/2f);
    //hitbox(false);
    //move(vx/2f, vy/2f);
    hitbox(true);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).x);
    blockY = int(cam.getInWorldCoordBlock(int(x), int(y)).y);
    show();
  }

  void hitbox(boolean last) {
    boolean playerKilled = false;
    grounded = false;
    int delID = -1;
    for (Figure f : nearbyFigures) {
      if (hitbox.overlap(f.hitbox)) {
        if (f.hitbox.solid == false) {
          if (f.getClass() == sikeClass.getClass()) { //if player touches spikes
            if (editModeOn == false && !playerKilled) {
              resetToCheckpoint(true, int(f.x+f.w/2f), int(f.y+f.h/2f));
              playerKilled = true;
            }
          }
          if (f.getClass() == coinClass.getClass()&& editModeOn == false) { //if player touches a coin
            delID = f.id;
          }
        } else {
          PVector move = hitbox.findNearestExit(f.hitbox, vx, vy);
          if (move.y != 0) {
            if (move.y < 0) {
              grounded = true;
              if (abs(vx) > 1 && random(0, 10) > 8) {
                wallAnimation(int(x+w/2), int(y+h));
              }
            }
            vy = 0;
            //vx = vx*0.9; //apply friction on moving left/right when walking on block (0.6 in v.1.0 and 0.8 for maxSpeed x walking = maxSpeed x flying)
            if (abs(vx) < 0.00001) {
              vx = 0;
            }
          }
          if (move.x != 0) {
            vx = 0;
            vy = vy*0.95;
            if (abs(vy) < 0.00001) {
              vy = 0;
            }
          }

          if (f.getClass() == slimeClass.getClass()) {
            if (grounded && last) {
              vy = vy - 50;
              if (coolDownTimer <= 0) {
                playSound(jumpSlime, 0.5*SoundEffectsSwitch.timer, true);
                slimeAnimation(int(x+w/2), int(y+h));
                coolDownTimer = 5;
              }
            }
          }
          if (grounded) { //lets the player walk to the sides when the player is grounded (without reset position)
            move.x = 0;
          }
          move(move.x, move.y);
        }
      }
      for (int i = -1; i < 2; i++) { //checks beneath the player for checkpoint/goal even if it is slightly beneath the player and player.grounded == false
        if (f.hitbox.pointInHitbox(int((x+w/2)+i*w/3), int(y+h+h/16))) {
          if (f.getClass() == checkpointClass.getClass() || f.getClass() == goalClass.getClass()) { //if player touces Checkpoint or Goal
            checkpoint(f);
          }
        }
      }
    }
    if (delID!= -1 && editModeOn == false && last) { //removes a Coin when you are not in editMode
      coinAnimation(int(worldFigures.get(delID).x+worldFigures.get(delID).w/2), int(worldFigures.get(delID).y+worldFigures.get(delID).h));
      removeCoin(delID);
      if (!gameFinished) {
        coinsCollected++;
        if (level <= levelAmount) {
          coins++;
        }
      }
      playSound(collectCoin, 0.7*SoundEffectsSwitch.timer, true);
      println("Player: hitbox(): Coin collected");
    }
    try {
      int removeProjectileID = -1;
      for (int i = 0; i < projectiles.size(); i++) {
        if (projectiles.get(i).getClass() == bulletClass.getClass()) {
          if (hitbox.overlap(projectiles.get(i).hitbox) && !editModeOn && !playerKilled) {
            explosionAnimation(projectiles.get(i));
            resetToCheckpoint(true, int(projectiles.get(i).x), int(projectiles.get(i).y));
            playerKilled = true;
            removeProjectileID = i;
          }
        }
      }
      if (removeProjectileID != -1) {
        projectiles.remove(removeProjectileID);
      }
    }
    catch(Exception e) {
      println("Error in player.hitbox(): Error while testing projectiles for a hit");
      e.printStackTrace();
    }
  }

  void checkpoint(Figure f) {
    if (!editModeOn && !gameFinished) {
      if (int(checkpointBlock.x) != int(f.x/blockSize) || int(checkpointBlock.y) != int((f.y/blockSize)-1)) {
        if (f.getClass() == goalClass.getClass()) {
          playSound(goalSound, 0.6*SoundEffectsSwitch.timer);
          println("Goal reached! Level " + level+" finished. You have collected "+coinsCollected+" Coins and took "+framesSinceStarted+" frames!");
          loadTimes();
          int frames = getTime(level);
          if (frames != -1) {
            if (framesSinceStarted < frames) {
              println("player.checkpoint(): Setting time because faster time found");
              setTime(level, framesSinceStarted);
            }
          } else {
            println("player.checkpoint(): Setting time because no time found");
            setTime(level, framesSinceStarted);
          }
          saveJSONArray(times, "times.json");
          println("Saved times");
          checkpointAnimation(int(x+w/2), int(y+h));
          gameFinished = true;
          coinsInWorld = 0;
          for (Figure fig : worldFigures) {
            if (fig.getClass() == coinClass.getClass()) {
              coinsInWorld++;
            }
          }
        } else {
          checkpointBlock = new PVector(int(f.x/blockSize), int((f.y/blockSize)-1));
          println("player.checkpoint(): Checkpoint reached: "+checkpointBlock.x + ", "+checkpointBlock.y+ "; Vector: "+new PVector(int(f.x/blockSize), int((f.y/blockSize)-1)));
          playSound(collectCoin, 0.7*SoundEffectsSwitch.timer, true);
          checkpointAnimation(int(x+w/2), int(y+h));
        }
      }
    }
  }

  int getTime(int level) {
    if (times != null) {
      for (int i = 0; i < times.size(); i++) {
        try {
          if (times.getJSONObject(i).getInt("level") == level) {
            println("player.checkpoint(): Found time: "+ times.getJSONObject(i).getInt("frames"));
            return  times.getJSONObject(i).getInt("frames");
          }
        }
        catch(Exception e) {
          println("Error in Player.getTime()");
          e.printStackTrace();
        }
      }
    } else {
      println("player.checkpoint(): array == null");
    }
    println("player.checkpoint(): No time found in array");
    return -1;
  }

  void setTime(int level, int time) {
    JSONObject o = new JSONObject();
    o.setInt("level", level);
    o.setInt("frames", time);
    boolean saved = false;
    for (int i = 0; i < times.size(); i++) {
      if (times.getJSONObject(i).getInt("level") == level) {
        times.setJSONObject(i, o);
        saved = true;
        println("player.setTime(): Saved in array at position "+i);
      }
    }
    if (!saved) {
      times.setJSONObject(times.size(), o);
      println("player.setTime(): level: Saved in array at position "+times.size()+"; no entry found and created a new entry");
    }
  }
}
