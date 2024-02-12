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
    grounded = false;
    checkpointBlock = new PVector(0, -1);
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
    }
    if (getFigureAt(int(checkpointBlock.x*blockSize+blockSize/2), int(checkpointBlock.y*blockSize+blockSize+blockSize/2)).getClass() == ch.getClass()) {
      player.x = checkpointBlock.x*blockSize;
      player.y = (checkpointBlock.y)*blockSize;
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
      if (getFigureAt(int(x+w/15f), int(y-blockSize/2)).hitbox.solid == false && getFigureAt(int(x+w-w/15f), int(y-blockSize/2)).hitbox.solid == false) {
        if (vy > -16) { //should prevent double jump
          vy = vy - 18;
        }
        playSound(jump, 0.5*SoundEffectsSwitch.timer, true);
      }
    }
  }

  void move(float dx, float dy) {
    x = x + dx*(blockSize/60f);
    y = y + dy;

    hitbox.updateCoord(int(x), int(y), int(w), int(h));
  }

  @Override void show() {
    cam.drawImage(play, int(x), int(y), int(w), int(h));

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
      text("BlockX: "+cam.getInWorldCoordBlock(mouseX, mouseY).x, 10*text, (22+24+24+24)*text, 10*text);
      text("BlockY: "+cam.getInWorldCoordBlock(mouseX, mouseY).y, 10*text, (34+24+24+24)*text, 10*text);
      text("editModeOn: "+editModeOn, 10*text, (22+24+24+24+24)*text, 10*text);
      text("Coins collected: "+coinsCollected, 10*text, (34+24+24+24+24)*text, 10*text);
      if (editModeOn) {
        text("gravity: "+gravity, 10*text, (34+24+24+24+24+12)*text, 10*text);
      }
    }
    //text("StepsX: "+stepsX, 10*text, (34+24+24+24+24+12+12)*text, 10*text);
    //text("StepsY: "+stepsY, 10*text, (34+24+24+24+24+12+12+12)*text, 10*text);
    //}
  }

  @Override void update() {
    gravity();
    nearbyFigures.clear();
    for (Figure f : worldFigures) {
      if (dist(f.x+f.w, f.y+f.h, x+w, y+h) < 4*blockSize) {
        nearbyFigures.add(f);
        //if (f.hitbox.solid == true && hitbox.overlap(f.hitbox)) {
        //  PVector m = hitbox.findNearestExit(f.hitbox);
        //  move(m.x, m.y);
        //}
      }
    }

    //boolean touch = false;
    //stepsX = 0;
    //stepsY = 0;
    //while (touch == false && stepsX <100) {
    //  move(vx*0.01, 0);
    //  for (Figure f : nearbyFigures) {
    //    if (f.hitbox.solid == true && hitbox.overlap(f.hitbox)) {
    //      touch = true;
    //    }
    //  }
    //  stepsX--;
    //  stepsX++;
    //}

    //while (touch == false && stepsY <100) {
    //  move(0, vy*0.01);
    //  for (Figure f : nearbyFigures) {
    //    if (f.hitbox.solid == true && hitbox.overlap(f.hitbox)) {
    //      touch = true;
    //      stepsY--;
    //    }
    //  }
    //  stepsY++;
    //}

    move(vx/2, vy*(blockSize/60f)/2);
    hitbox(false);
    move(vx/2, vy*(blockSize/60f)/2);
    hitbox(true);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).x);
    blockY = int(cam.getInWorldCoordBlock(int(x), int(y)).y);
    show();
  }

  void hitbox(boolean last) {
    grounded = false;
    int delID = -1;
    //PVector move = new PVector(-vx*0.01, -vy*0.01);
    //if(stepsX == 0) {
    // move.x = 0;
    //}
    //if(stepsY == 0) {
    // move.y = 0;
    //}
    for (Figure f : nearbyFigures) {
      if (hitbox.overlap(f.hitbox)) {
        if (f.hitbox.solid == false) {
          if (f.getClass() == s.getClass()) { //if player touches spikes
            if (editModeOn == false) {
              resetToCheckpoint(true, int(f.x+f.w/2f), int(f.y+f.h/2f));
            }
          }
          if (f.getClass() == co.getClass()&& editModeOn == false) { //if player touches a coin
            delID = f.id;
          }
        } else {
          PVector move = f.hitbox.findNearestExit(hitbox);
          if (move.y != 0) {
            if (move.y < 0) {
              grounded = true;
              if (abs(vx) > 1 && random(0, 10) > 9) {
                wallAnimation(int(x+w/2), int(y+h));
              }
            }
            vy = 0;
            vx = vx*0.6; //apply friction on moving left/right when walking on block (0.6 in v.1.0 and 0.8 for maxSpeed x walking = maxSpeed x flying)
            if (abs(vx) < 0.00001) {
              vx = 0;
            }
          }
          if (move.x != 0) { //I don't understand what that does??
            vx = 0;
            vy = vy*0.95;
            if (abs(vy) < 0.00001) {
              vy = 0;
            }
          }

          if (f.getClass() == sl.getClass()) {
            if (grounded) {
              vy = vy - 50;
              if (coolDownTimer <= 0) {
                playSound(jumpSlime, 0.5*SoundEffectsSwitch.timer, true);
                coolDownTimer = 5;
              }
              slimeAnimation(int(x+w/2), int(y+h));
              //println("Player: hitbox(): Slime jump");
            }
          }
          if (f.getClass() == ch.getClass() || f.getClass() == go.getClass()) { //if player touces Checkpoint or Goal
            checkpoint(f);
          }
          if (grounded) { //lets the player walk to the sides when the player is grounded (without reset position)
            move.x = 0;
          }
          if (move.x != 0) {
            //println("Player got shifted due to hitbox");
          }
          move(move.x, move.y);
        }
      }
    }
    if (delID!= -1 && editModeOn == false && last) { //removes a Coin when you are not in editMode
      coinAnimation(int(worldFigures.get(delID).x+worldFigures.get(delID).w/2), int(worldFigures.get(delID).y+worldFigures.get(delID).h));
      removeFigure(delID, false);
      if (!gameFinished) {
        coinsCollected++;
      }
      playSound(collectCoin, 0.7*SoundEffectsSwitch.timer, true);
      println("Player: hitbox(): Coin collected");
    }
  }

  void checkpoint(Figure f) {
    if (grounded && !editModeOn && !gameFinished) {
      if (int(checkpointBlock.x) != int(f.x/blockSize) || int(checkpointBlock.y) != int((f.y/blockSize)-1)) {
        if (f.getClass() == go.getClass()) {
          playSound(goalSound, 0.6*SoundEffectsSwitch.timer);
          println("Goal reached! Level " + level+" finished. You have collected "+coinsCollected+" Coins and took "+framesSinceStarted+" frames!");
          JSONObject levelTimes;
          try {
            times = loadJSONArray("times.json");
            println("player: hitbox(): times.json found and loaded");
            try {
              levelTimes = times.getJSONObject(level);
              println("time loaded");
            }
            catch(Exception e2) {
              println("Error in: Player: checkpoint(): ");
              println("Exception 2: "+e2);
              levelTimes = new JSONObject();
              levelTimes.setInt("frames", 2147483647);
            }
            levelTimes.setInt("level", level);
            int frames = levelTimes.getInt("frames");
            println("Player: checkpoint(): frames Count in times.json found");
            if (framesSinceStarted < frames) {
              levelTimes.setInt("frames", framesSinceStarted);
              times.setJSONObject(level, levelTimes);
              saveJSONArray(times, "times.json");
              println("Player: checkpoint(): JSONArray for Times saved");
            }
          }
          catch(Exception e) {
            println("Error in: Player: checkpoint(): ");
            e.printStackTrace();
            JSONArray times = new JSONArray();
            levelTimes = new JSONObject();
            levelTimes.setInt("frames", framesSinceStarted);
            levelTimes.setInt("level", level);
            times.setJSONObject(level, levelTimes );
            saveJSONArray(times, "times.json");
            println("Player: checkpoint(): New times.json made");
          }
          checkpointAnimation(int(x+w/2), int(y+h));
          gameFinished = true;
          coinsInWorld = 0;
          for(Figure fig : worldFigures) {
           if(fig.getClass() == co.getClass()) {
             coinsInWorld++;
           }
          }
        } else {
          checkpointBlock = new PVector(int(f.x/blockSize), int((f.y/blockSize)-1));
          println("Player: checkpoint(): Checkpoint reached: "+checkpointBlock.x + ", "+checkpointBlock.y+ "; Vector: "+new PVector(int(f.x/blockSize), int((f.y/blockSize)-1)));
          playSound(collectCoin, 0.7*SoundEffectsSwitch.timer, true);
          checkpointAnimation(int(x+w/2), int(y+h));
        }
      }
    }
  }
}
