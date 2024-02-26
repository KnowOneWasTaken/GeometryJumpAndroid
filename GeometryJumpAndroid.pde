//This section imports the necessary libraries

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;
import processing.data.JSONArray;
import processing.data.JSONObject;
import processing.event.TouchEvent;
import processing.sound.SoundFile;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import android.content.Intent;
import android.net.Uri;
import android.widget.Toast;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.content.Context;

import androidx.core.content.FileProvider;

import java.io.*;
import java.io.File;
import java.util.ArrayList;
import java.io.IOException;

MediaPlayer click, reset, jump, jumpSlime, collectCoin, goalSound, tabChange, loading, explosion;
MediaPlayer[] backgroundMusicPlayer;

//These are variable declarations used throughout the program. They include objects such as figures, images, player, camera, and various flags and settings.
PImage spike, wall, play, spikeGlow, slime, slimeGlow, wallGlow, remove, coin, coinGlow, checkpoint, checkpointGlow, BEditModeOn, BEditModeOff, BLevel1Glow, right, rightGlow, left, leftGlow, BLevelX, goalGlow, particleStar,
  particleWall, ButtonLEFT, ButtonRIGHT, ButtonUP, clear, ButtonEXIT, particleSlime, particleCheckpoint, bgSwitch, offSwitch, onSwitch, ButtonSwitch, ButtonShare, ButtonImport, ButtonDown, ButtonSettings, ButtonPrivacyPolicy,
  ButtonMusic, Logo, goalAnimationBackground, ButtonOK, emptyCoin, Bullet1, Bullet2, Bullet3, Bullet4, missileLauncherGlow, particleBullet, ButtonSwitchNeg, ButtonRotateRight, ButtonRotateLeft;

Button Edit, SkipRight, SkipLeft, LevelX, Left, Right, Up, Exit, SwitchEdit, SwitchEditNeg, Share, Import, Down, Settings, PrivacyPolicy, Music, OK, RotateRight, RotateLeft;
SwitchButton BgMusicSwitch, SoundEffectsSwitch, DebugSwitch;

ArrayList<Particle> particles = new ArrayList<Particle>();

ArrayList<Figure> worldFigures = new ArrayList<Figure>();
ArrayList<Bullet> projectiles = new ArrayList<Bullet>();

Player player;
Cam cam;
int blockSize = 60; //indicates how many pixels a block is large
boolean[] keysPressed = new boolean[65536]; //used to check if a key is pressed or not

JSONArray world; //The json-Array that contains the figures of the environment
JSONArray times; //contains the times (frame-Counts) in which the player has completed the levels (best scores)
JSONObject time; //contains the time for the currrently selected level
boolean timeFound;

String editMode = "wall"; //default for the world-edit mode: selects box/walls as the default to add to your world in editModeOn
int rotateMode = 0;
int editModeInt = 1;
boolean editModeOn = false; //indicates if the editMode is on or off
boolean gravity = false; //indicates if gravity is in editModeOn active or not
int coinsCollected = 0; //indicates how many coins the player has collected in a level
boolean touch = false; //indicates, if a finger is on the screen or not
float gameZoom = 1.8; //makes the gameplay bigger (zooms in), when you are on a smartphone
boolean useTouchScreen = false;
int coolDownTimer = 0;
String selectedFilePath;

//objects just to get their .getClass()
Spike s;
Slime sl;
Coin co;
Checkpoint ch;
Goal go;
Bullet bu;
MissileLauncher mi;

boolean inGame = false; //indicates if the game is running (true) or if the player is in the menue (false)
int level = 1; //selects level 1 as default
static final int levelAmount = 11; //indicates how many levels there are which should not be altered by in Game editing
int framesSinceStarted = 0; //counts the frames, since the player has started a level (reset by death)
int loaded = 0;

BackgroundFigure[] bgFigures = new BackgroundFigure[20]; //Figures floating in Menue
boolean everythingLoaded = false;
float backgroundMusicAmp = 1;

boolean debug = false;
int backgroundMusicFilesLoaded = 0; //indicates how many of the background-music files are already loaded
boolean gameFinished = false;
boolean inSettings = false;
int coinsInWorld = 0; //Used to show how many coins the player has collected after finishing the game. Indicates how many coins are still in the world.
int backgroundMusicPlays = -1;

//called once at launch
void setup() {
  fullScreen(P2D);
  //size(720, 1600, P2D);

  frameRate(50);
  println("###########################################################################################################");
  println("Start Program");

  loadImages();
  player = new Player(0, -1, blockSize, blockSize);
  loadTimes();
  thread("loadSounds");

  s = new Spike();
  sl = new Slime();
  co = new Coin();
  ch = new Checkpoint();
  go = new Goal();
  bu = new Bullet();
  mi = new MissileLauncher();

  cam = new Cam(0, 0);

  float widthScale;
  float heightScale;

  if (height > width) {
    widthScale = width/1080f;
    heightScale = height/2400f;
    SkipRight = new Button(true, right, rightGlow, false, int(width/2+(640/2+20)*widthScale), int(height/2-(350/2)*heightScale), int(160*widthScale), int(350*heightScale), 1, false, true);
    SkipLeft = new Button(true, left, leftGlow, false, int(width/2-(160+640/2+20)*widthScale), int(height/2-(350/2)*heightScale), int(160*widthScale), int(350*heightScale), 1, false, true);
    LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-(640/2)*widthScale), int(height/2-(440/2)*heightScale), int((640)*widthScale), int(440*heightScale), 1, false, true);

    Left = new Button(true, ButtonLEFT, clear, false, int(width/2f - (400/2 + 300) * widthScale), int(height-(10+450) * heightScale), int(300*widthScale), int(450*heightScale), 1, false, true);
    Right = new Button(true, ButtonRIGHT, clear, false, int(width/2f + (400/2) * widthScale), int(height-(10+450) * heightScale), int(300*widthScale), int(450*heightScale), 1, false, true);

    Up = new Button(true, ButtonUP, clear, false, int(width/2f - (400/2) * width / 1080f), int(height-(10+450) * heightScale), int(400*widthScale), int(450*heightScale), 1, false, true);
    Down = new Button(true, ButtonDown, clear, false, int(width/2f - (400/2) * widthScale), int(height-((10+450) - (450/2)) * heightScale), int(400*widthScale), int(225*heightScale), 1, false, true);

    int size = 140;
    int distance = 20;

    Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-(distance+size)*widthScale), int(distance*heightScale), int(size*widthScale), int(size*heightScale));
    Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-(distance+size)*widthScale), int((distance*2+size)*heightScale), int(size*widthScale), int(size*heightScale));
    SwitchEdit = new Button(true, ButtonSwitch, ButtonSwitch, false, int(width-(distance+size)*widthScale), int((distance*3+size*2)*heightScale), int(size*widthScale), int(size*heightScale));
    RotateRight = new Button(true, ButtonRotateRight, ButtonRotateRight, false, int(width-(distance+size)*widthScale), int((distance*4+size*3)*heightScale), int(size*widthScale), int(size*heightScale));

    Share = new Button(true, ButtonShare, ButtonShare, false, int(width-(size*2+distance*2)*widthScale), int(distance*heightScale), int(size*widthScale), int(size*heightScale));
    Import = new Button(true, ButtonImport, ButtonImport, false, int(width-(size*2+distance*2)*widthScale), int((distance*2+size)*heightScale), int(size*widthScale), int(size*heightScale));
    SwitchEditNeg = new Button(true, ButtonSwitchNeg, ButtonSwitchNeg, false, int(width-(size*2+distance*2)*widthScale), int((distance*3+size*2)*heightScale), int(size*widthScale), int(size*heightScale));
    RotateLeft = new Button(true, ButtonRotateLeft, ButtonRotateLeft, false, int(width-(size*2+distance*2)*widthScale), int((distance*4+size*3)*heightScale), int(size*widthScale), int(size*heightScale));

    Settings = new Button(true, ButtonSettings, ButtonSettings, false, int((20)*widthScale), int(height-(20+size)*heightScale), int(size*widthScale), int(size*heightScale));
    PrivacyPolicy = new Button(true, ButtonPrivacyPolicy, ButtonPrivacyPolicy, false, int(width/2-(86*3)*widthScale), int(height-(20+50*3)*heightScale), int(220*3*widthScale), int(50*3*heightScale));
    Music = new Button(true, ButtonMusic, ButtonMusic, false, int(width/2-(127)*widthScale), int(height-(20*2+50*3*2)*heightScale), int(370*widthScale), int(50*3*heightScale));
    OK = new Button(true, ButtonOK, ButtonOK, false, int((width/2-200*widthScale)), int((height/5+855*heightScale)), int(400*widthScale), int(200*heightScale));
    gameZoom = gameZoom * widthScale;
  } else {
    widthScale = width/2400f;
    heightScale = height/1080f;
    LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-320*widthScale), int(height/2-220*heightScale), int(640*widthScale), int(440*heightScale), 1, false, true);
    SkipRight = new Button(true, right, rightGlow, false, int(width/2+(320+50)*widthScale), int(height/2-150*heightScale), int(150*widthScale), int(300*heightScale), 1, false, true);
    SkipLeft = new Button(true, left, leftGlow, false, int(width/2+(-320-50-150)*widthScale), int(height/2-150*heightScale), int(150*widthScale), int(300*heightScale), 1, false, true);

    Left = new Button(true, ButtonLEFT, clear, false, int(width/(4.53)+(-320-40)*widthScale), int(height-(90+320)*heightScale), int(320*widthScale), int(320*heightScale), 1, false, true);
    Right = new Button(true, ButtonRIGHT, clear, false, int(width/(4.53)+(40)*widthScale), int(height-(90+320)*heightScale), int(320*widthScale), int(320*heightScale), 1, false, true);
    Up = new Button(true, ButtonUP, clear, false, int(width-(240+320)*widthScale), int(height-(90+320)*heightScale), int(320*widthScale), int(320*heightScale), 1, false, true);
    Down = new Button(true, ButtonDown, clear, false, int(width-(240+320)*widthScale), int(height-(90+160)*heightScale), int(320*widthScale), int(160*heightScale), 1, false, true);

    int size = 160;
    int distance = 20;
    Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-(size+distance)*widthScale), int(distance*heightScale), int(160*widthScale), int(160*heightScale));
    Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-(size+distance)*widthScale), int((size+distance*2)*heightScale), int(size*widthScale), int(size*heightScale));

    SwitchEdit = new Button(true, ButtonSwitch, ButtonSwitch, false, int(width-(size*3+distance*3)*widthScale), int(distance*heightScale), int(size*widthScale), int(size*heightScale));
    RotateRight = new Button(true, ButtonRotateRight, ButtonRotateRight, false, int(width-(size*3+distance*3)*widthScale), int((size+distance*2)*heightScale), int(size*widthScale), int(size*heightScale));

    Share = new Button(true, ButtonShare, ButtonShare, false, int(width-(size*2+distance*2)*widthScale), int(distance*heightScale), int(160*widthScale), int(160*heightScale));
    Import = new Button(true, ButtonImport, ButtonImport, false, int(width-(size*2+distance*2)*widthScale), int((size+distance*2)*heightScale), int(size*widthScale), int(size*heightScale));

    SwitchEditNeg = new Button(true, ButtonSwitchNeg, ButtonSwitchNeg, false, int(width-(size*4+distance*4)*widthScale), int(distance*heightScale), int(size*widthScale), int(size*heightScale));
    RotateLeft = new Button(true, ButtonRotateLeft, ButtonRotateLeft, false, int(width-(size*4+distance*4)*widthScale), int((size+distance*2)*heightScale), int(size*widthScale), int(size*heightScale));

    Settings = new Button(true, ButtonSettings, ButtonSettings, false, int(20*widthScale), int(height-(20+160)*heightScale), int(160*widthScale), int(160*heightScale));
    PrivacyPolicy = new Button(true, ButtonPrivacyPolicy, ButtonPrivacyPolicy, false, int(width/2-(110*3)*widthScale), int(height-(20+50*3)*heightScale), int(220*3*widthScale), int(50*3*heightScale));
    Music = new Button(true, ButtonMusic, ButtonMusic, false, int(width/2-(370/2)*widthScale), int(height-(20*2+50*3*2)*heightScale), int(370*widthScale), int(50*3*heightScale));
    OK = new Button(true, ButtonOK, ButtonOK, false, int((width/2-200*widthScale)), int((855*heightScale)), int(400*widthScale), int(200*heightScale));
    gameZoom = gameZoom * heightScale;
  }
  BgMusicSwitch = new SwitchButton(bgSwitch, offSwitch, onSwitch, width/2-int(80*widthScale), int(height/4f), int(160*widthScale), int(80*heightScale));
  SoundEffectsSwitch = new SwitchButton(bgSwitch, offSwitch, onSwitch, width/2-int(80*widthScale), int(height/4f)+int((80*2+40)*heightScale), int(160*widthScale), int(80*heightScale));
  DebugSwitch = new SwitchButton(bgSwitch, offSwitch, onSwitch, width/2-int(80*widthScale), int(height/4f)+int((80*4+40*2)*heightScale), int(160*widthScale), int(80*heightScale));
  //sets the start state of DebugSwitch to the correct position
  DebugSwitch.clickEvent();
  DebugSwitch.timer = 0;

  setupBGAnimation();
  LevelX.img = levelXImage(level);

  loadData();

  if (editModeOn) {
    Down.hitbox = true;
    Up.heightB = Up.heightB/2;
  } else {
    Down.hitbox = false;
    Up.heightB = Up.heightB*2;
  }
  for (int i = 0; i < backgroundMusicPlayer.length; i++) {
    if (backgroundMusicPlayer[i] != null) {
      backgroundMusicPlayer[i].stop();
      backgroundMusicPlayer[i].setVolume(0, 0);
    }
  }
}

//called in loop: It is responsible for continuously updating and rendering the graphics and animations of the program.
void draw() {
  float widthScale;
  float heightScale;
  if (height > width) {
    widthScale = width/1080f;
    heightScale = height/2400f;
  } else {
    widthScale = width/2400f;
    heightScale = height/1080f;
  }
  touchCheck();
  background(0);

  if (inGame) {
    if (!gameFinished) {
      framesSinceStarted++;
    }
    ButtonTouchCheck();
    cam.update();
    player.update();
    keyListener();

    //Calls show() and showGlow() for every Figure of the worldFigures
    for (Figure f : worldFigures) {
      f.showGlow();
    }
    for (Figure f : worldFigures) {
      f.show();
    }

    try {
      boolean[] removeProjectile = new boolean[projectiles.size()];
      for (int i = 0; i < projectiles.size(); i++) {
        projectiles.get(i).update();
        removeProjectile[i] = false;
        if (projectiles.get(i).hit()) {
          explosionAnimation(projectiles.get(i));
          removeProjectile[i] = true;
        } else if (projectiles.get(i).mustRemove()) {
          removeProjectile[i] = true;
        }
      }

      for (int i = projectiles.size()-1; i>-1; i--) {
        if (removeProjectile[i]) {
          projectiles.remove(i);
        }
      }
    }
    catch(Exception e) {
      println("Error in draw: Error in projectiles for-loop");
      e.printStackTrace();
    }
    //updates the player: adds Gravity to speed, moves the player while checking the hitboxes and displaying it when position is calculated


    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).update();
    }
    //displays the block, which is currently selected for edit,if you are in editModeOn
    showEditMode();

    if (editModeOn) {
      SwitchEdit.show();
      SwitchEditNeg.show();
      RotateLeft.show();
      RotateRight.show();
    }


    //plays the backgroundMusic[] sounds when they are loaded
    playBackgroundMusic();
    Left.show();
    Right.show();
    Up.show();
    if (editModeOn) {
      Down.show();
    }
    Exit.show();
    if (level > levelAmount ||debug) {
      Edit.show();
      Share.show();
      Import.show();
    }
    if (!editModeOn) {
      fill(255);
      textSize(30*2);
      text("Timer: "+(framesSinceStarted/50f), width/2 - (textWidth("Timer: "+10.00f))/2, 50*2);
    }
    if (gameFinished) {
      int startHeight = 0;
      if (height > width) {
        startHeight = height/5;
      } else {
        startHeight = 0;
      }
      textAlign(CENTER);
      image(goalAnimationBackground, width/2-540*widthScale, startHeight, 1080*widthScale, 1080*heightScale);
      fill(255);
      textSize(75*heightScale);
      text("Game Finished!", width/2f, startHeight+200*heightScale);
      text("You took "+(framesSinceStarted/50f)+" seconds!", width/2f, startHeight+200*2*heightScale);
      if ((coinsCollected+coinsInWorld) > 0) {
        if ((coinsCollected+coinsInWorld)>1  || coinsCollected == 0) {
          text("You have collected "+coinsCollected+"/"+(coinsCollected+coinsInWorld)+" coins!", width/2f, startHeight+200f*3*heightScale);
        } else {
          text("You have collected 1/"+(coinsCollected+coinsInWorld)+" coin!", width/2f, startHeight+200f*3*heightScale);
        }
      }
      textAlign(LEFT);
      for (int i = 0; i < (coinsCollected+coinsInWorld); i++) {
        if (i >= coinsCollected) {
          image(emptyCoin, width/2f-((((coinsCollected+coinsInWorld)*120 + (coinsCollected+coinsInWorld-1)*20)/2f) - i*(120+20))*widthScale, startHeight+665*heightScale, 120*widthScale, 120*heightScale);
        } else {
          image(coin, width/2f-((((coinsCollected+coinsInWorld)*120 + (coinsCollected+coinsInWorld-1)*20)/2f) - i*(120+20))*widthScale, startHeight+665*heightScale, 120*widthScale, 120*heightScale);
        }
      }
      OK.show();
    }
  } else {
    backgroundAnimation();
    if (everythingLoaded) {
      try {
        try {
          playBackgroundMusic();
        }
        catch(Exception e2) {
          println("Error in Draw() while playing background - music: ");
          e2.printStackTrace();
        }
        if (!inSettings) {
          if (timeFound) {
            try {
              fill(255);
              textSize(80*heightScale);
              //int(height/2-(440/2)*heightScale)
              text("Personal Best: "+(time.getInt("frames")/50f), width/2f-textWidth("Personal Best: "+(time.getInt("frames")/50f))/2, int(height/2+(440/2+120)*heightScale));
            }
            catch(Exception e2) {
              println("Error in Draw() while trying to draw time");
              e2.printStackTrace();
            }
          }

          if (height < width) {
            image(Logo, width/2-1024*widthScale/2, height/4-160*heightScale-420*heightScale/2, 1024*widthScale, 420*heightScale);
          } else {
            image(Logo, width/2-1024*widthScale/2, height/4-420*heightScale/2, 1024*widthScale, 420*heightScale);
          }
          LevelX.show();
          SkipRight.show();
          SkipLeft.show();
          Settings.show();
          if (level > levelAmount) {
            fill(255);
            textSize(55*heightScale);
            //textAlign(CENTER);
            if (height > width) {
              text("Build your own level!\nHere you can be creative,\nbuild worlds and share\nthem with your friends!\nYou can also import existing\nlevels from the community", width/2f-textWidth("Build your own level!")/2, height-450*heightScale);
            } else {
              text("Build your own level! Here you can be creative, build worlds and share\nthem with your friends! You can also import existing levels from the community", width/2f-textWidth("Build your own level!")/2, height-220*heightScale);
            }
          }
        } else {//inSettings
          Settings.show();
          PrivacyPolicy.show();
          Music.show();
          fill(255);
          textSize(30*2*heightScale);
          text("Background-Music", width/2-textWidth("Background-Music")/2, int(height/4f)-20*heightScale);
          text("Sound-Effects", width/2-textWidth("Sound-Effects")/2, int(height/4f)+(80+40+60)*heightScale);
          text("Debug", width/2-textWidth("Debug")/2, int(height/4f)+(80*3+40*2+60)*heightScale);
          BgMusicSwitch.show();
          SoundEffectsSwitch.show();
          DebugSwitch.show();
          backgroundMusicAmp = BgMusicSwitch.timer;
        }
      }
      catch(Exception e) {
        println("Error in Draw() while displaying UI and playing background - music: ");
        e.printStackTrace();
      }
    } else {
      playSound(loading, 0.7*SoundEffectsSwitch.timer);
      fill(255-loaded*2.55, loaded*2.55, 0);
      textSize(200*heightScale);
      text(loaded+"%", width/2-180*widthScale, height/2+67*heightScale);
      stroke(255);
      fill(0, 0, 0, 0);
      rect(width/2-200*widthScale, height/2+100*heightScale, 4*100*widthScale, 50*heightScale);
      fill(255-loaded*2.55, loaded*2.55, 0);
      rect(width/2-200*widthScale, height/2+100*heightScale, 4*loaded*widthScale, 50*heightScale);
      //line(width/2,0,width/2,height);
      //line(0,height/2,width,height/2);
    }
  }
  if (debug) {
    int text = 4;
    fill(255);
    textSize(10*text);
    noStroke();
    text("touch: "+touch, 10*text, height-10*text);
    fill(255);
    textSize(10*text);
    noStroke();
    for (int i = 0; i < touches.length; i++) {
      float tx = touches[i].x;
      float ty = touches[i].y;
      text("touches["+i+"]: "+tx+", "+ty, 10*text, height-(10*text+12*text*(i+1)));

      //Causes performance issues
      //fill(255, 0, 0);
      //stroke(255, 0, 0);
      //line(tx-5*text, ty-5*text, tx+5*text, ty+5*text);
      //line(tx+5*text, ty-5*text, tx-5*text, ty+5*text);
      //stroke(255);
      //fill(0, 0, 0, 0);
      //ellipseMode(CENTER);
      //circle(tx, ty, 120);
    }
    fill(0, 255, 0);
    stroke(0, 255, 0);
    line(mouseX-5*text, mouseY-5*text, mouseX+5*text, mouseY+5*text);
    line(mouseX+5*text, mouseY-5*text, mouseX-5*text, mouseY+5*text);
    stroke(255);
    fill(0, 0, 0, 0);
    ellipseMode(CENTER);
    circle(mouseX, mouseY, 120);
  }
  if (coolDownTimer > 0) {
    coolDownTimer--;
  }

  saveData();
}

void ButtonTouchCheck() {
  float speed = 2;
  if (!player.grounded) {
    speed = 1.3;
  }
  float maxSpeed = 12;
  boolean touchedLeft = false;
  boolean touchedRight = false;
  if (touch) {

    //for (TouchEvent.Pointer pointer : touches) {
    // boolean leftT = Left.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
    //boolean rightT = Right.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
    //boolean upT = Up.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
    if (!editModeOn) {
      for (TouchEvent.Pointer pointer : touches) {
        if (Left.touch(int(pointer.x), int(pointer.y)) && !touchedLeft) {
          touchedLeft = true;
          if (player.vx > -maxSpeed) {
            player.vx -= speed;
          }
        }
        if (Right.touch(int(pointer.x), int(pointer.y))  && !touchedRight) {
          touchedRight = true;
          if (player.vx < maxSpeed) {
            player.vx += speed;
          }
        }
        if (Up.touch(int(pointer.x), int(pointer.y))) {
          player.jump();
        }
      }
    } else {
      boolean leftT = Left.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
      boolean rightT = Right.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
      boolean upT = Up.touch(); //PApplet.parseInt(pointer.x), PApplet.parseInt(pointer.y)
      boolean downT = Down.touch();
      player.vx = 0;
      if ((rightT && !leftT) || (!rightT && leftT)) {
        if (leftT) {
          player.vx = -maxSpeed;
        }
        if (rightT) {
          player.vx = +maxSpeed;
        }
      }
      player.vy = 0;
      if ((downT && !upT) || (!downT && upT)) {
        if (upT) {
          player.vy = -maxSpeed;
        }
        if (downT) {
          player.vy = +maxSpeed;
        }
      }
    }
  } else {
    if (editModeOn) {
      player.vy = player.vy*0.6;
      player.vx = player.vx*0.6;
    }
  }
  if (abs(player.vx) > maxSpeed) {
    player.vx = maxSpeed * (player.vx/abs(player.vx));
  }
  if (player.grounded) {//((touchedLeft && touchedRight) || (!touchedLeft && !touchedRight)) &&
    player.vx = player.vx*0.8;
  }
}

void touchCheck() {
  if (touches.length == 0) {
    touch = false;
  } else {
    mouseX = int(touches[0].x);
    mouseY = int(touches[0].y);
    touch = true;
  }
}

void touchStarted() {
  useTouchScreen = true;
}


void backgroundAnimation() {
  for (BackgroundFigure bgFigure : bgFigures) {
    bgFigure.move();
    bgFigure.checkPosition();
    bgFigure.show();
    bgFigure.update();
  }
}

void setupBGAnimation() {
  for (int i = 0; i < bgFigures.length; i++) {
    int size = int(random(20, 70));
    bgFigures[i] = new BackgroundFigure(int(random(0, width)), int(random(0, height)), size, size);
  }
}

//This function is responsible for displaying the current edit mode on the screen. It uses different images based on the selected edit mode.
//It is called in draw()
void showEditMode() {
  try {
    if (editModeOn) {
      if (editMode == null) {
        println("Error in showEditMode(): editMode is null");
        editMode = "wall";
      }
      PImage img, imgGlow;
      switch(editMode) {
      case "spike":
        img = spike;
        imgGlow = spikeGlow;
        break;
      case "slime":
        img = slime;
        imgGlow = slimeGlow;
        break;
      case "remove":
        img = null;
        imgGlow = remove;
        break;
      case "coin":
        img = coin;
        imgGlow = coinGlow;
        break;
      case "checkpoint":
        img = checkpoint;
        imgGlow = checkpointGlow;
        break;
      case "goal":
        img = checkpoint;
        imgGlow = goalGlow;
        break;
      case "missileLauncher":
        img = wall;
        imgGlow = missileLauncherGlow;
        break;
      default:
        img = wall;
        imgGlow = wallGlow;
        break;
      }
      if (img != null) {
        image(img, blockSize*1.5, blockSize*1.5, blockSize*1.5, blockSize*1.5);
      }
      if (imgGlow != null) {
        image(imgGlow, blockSize*1.5-blockSize*1.5/2, blockSize*1.5-blockSize*1.5/2, blockSize*2*1.5, blockSize*2*1.5);
      }
    }
  }
  catch(Exception e) {
    println("Error in showEditMode():");
    e.printStackTrace();
  }
}

//This function creates a new instance of a Figure object based on the given parameters. The object's class is determined by the ObjectClass parameter.
//If an error occured, a Figure with id = -1 gets returned
Figure createFigure(String ObjectClass, int x, int y, int w, int h, int id) {
  switch(ObjectClass) {
  case "wall":
    return new Wall(x, y, w, h, id);
  case "spike":
    return new Spike(x, y, w, h, id);
  case "slime":
    return new Slime(x, y, w, h, id);
  case "coin":
    return new Coin(x, y, w, h, id);
  case "checkpoint":
    return new Checkpoint(x, y, w, h, id);
  case "goal":
    return new Goal(x, y, w, h, id);
  case "missileLauncher":
    return new MissileLauncher(x, y, w, h, id);
  default:
    println("createFigure(): Error: ObjectClass could'nt be resolved");
    return new Figure(0, 0, 0, 0, -1);
  }
}

Figure createFigure(String ObjectClass, int x, int y, int w, int h, int id, int extra1, int extra2, int extra3) {
  if (ObjectClass.equals("missileLauncher")) {
    return new MissileLauncher(x, y, w, h, id, extra1, extra2, extra3);
  }
  println("Error in createFigure(String, int, int, int, int, int, int, int, int): Could not recognize ObjectClass: "+ObjectClass);
  return null;
}


/* This function adds a new figure to the world. It creates a JSON object representing the figure and adds it to the world JSONArray.
 The figure is also added to the worldFigures ArrayList. */
void addFigure(String ObjectClass, int x, int y, int w, int h, int extra1, int extra2) {
  JSONObject figure = new JSONObject();
  int id;
  if (world != null) {
    id = world.size();
  } else {
    id = 0;
  }
  figure.setInt("id", id);
  figure.setString("class", ObjectClass);
  figure.setInt("x", x);
  figure.setInt("y", y);
  if (ObjectClass.equals("missileLauncher")) {
    println("addFigure() found missileLauncher");
    figure.setInt("interval", extra1);
    figure.setInt("offset", framesSinceStarted % extra1);
    figure.setInt("direction", extra2);
    worldFigures.add(createFigure(ObjectClass, x, y, w, h, id, extra1, framesSinceStarted % extra1, extra2));
  } else {
    worldFigures.add(createFigure(ObjectClass, x, y, w, h, id));
  }
  world.setJSONObject(id, figure);


  if (level > levelAmount) {
    try {
      saveJSONArray(world, "level"+level+".json");
      println("Saved world in level"+level+".json");
    }
    catch(Exception e) {
      println("Error in addFigure() while saving world into "+level+".json");
      e.printStackTrace();
      delay(500);
      try {
        saveJSONArray(world, "level"+level+".json");
      }
      catch(Exception e2) {
        println("Couldn't save world after delay loading time");
        e2.printStackTrace();
      }
    }
  }
  println("addFigure(): Added Figure of class: "+ObjectClass);
  println("addFigure(): New Figure saved in worldFigures, world and world.json: id: "+id);
}

void addFigure(String ObjectClass, int x, int y, int w, int h) {
  addFigure(ObjectClass, x, y, w, h, -1, -1);
}


//This function removes a figure from the world based on its ID. It removes the corresponding JSON object from the world JSONArray and removes the figure from the worldFigures ArrayList.
void removeFigure(int id, boolean permanent) {
  try {
    world.remove(id);
    worldFigures.remove(id);
    saveJSONArray(world, "world.json");
    //reloadFigures("world");
    updateIDs();
    if (level > levelAmount && permanent) {
      saveJSONArray(world, "level"+level+".json");
    }
  }
  catch(Exception e) {
    println("removeFigure(): Error while removing a Figure: id: "+id+", worldFigures.size():"+worldFigures.size());
    println("removeFigure(): Error catched:");
    e.printStackTrace();
    reloadFigures("world");
  }
}

void startLevel(int lvl) {
  projectiles.clear();
  coinsCollected = 0;
  println("startLevel(): world and worldFigures cleared");
  player.checkpointBlock = new PVector(0, -1);
  player.resetToCheckpoint(false);
  try { // trys to load the world.json file
    String fileName = "";
    switch (lvl) {
    case 0:
      fileName = "world";
      break;
    default:
      fileName = "level"+level;
      break;
    }
    println("startLevel(): Try to load "+fileName);
    try {
      reloadFigures(fileName);
    }
    catch(Exception e2) {
      println("startLevel(): Error while reloading Figures");
      e2.printStackTrace();
      world = new JSONArray();
      addFigure("wall", 0, 0, 1, 1);
      saveJSONArray(world, "level"+lvl+".json");
    }
  }
  catch(Exception e) { //if the file couldn't be loaded: adds one block beneath the player
    println("startLevel(): No world map found");
    e.printStackTrace();
    world = new JSONArray();
    addFigure("wall", 0, 0, 1, 1);
    saveJSONArray(world, "level"+lvl+".json");
  }
}

//This function reloads the figures from the world.json file into the worldFigures ArrayList. It is called at the start of the program and after updating the IDs.
void reloadFigures(String fileName) {
  try {
    world = new JSONArray();
    world = loadJSONArray(fileName+".json");
    println("reloadFigures(): world cleared and then loaded "+fileName+" into world");

    for (int i = 0; i < world.size(); i++) {
      JSONObject jsn = world.getJSONObject(i);
      jsn.setInt("id", i);
    }

    try {
      saveJSONArray(world, "world.json");
      println("reloadFigures(): Saved world (JSONArray) in world.json");
    }
    catch(Exception e2) {
      println("Error in reloadFigures(): could'nt save temp into world.json");
      e2.printStackTrace();
      println("After a delay, it will try again");
      delay(500);
      try {
        saveJSONArray(world, "world.json");
      }
      catch(Exception e3) {
        println("Error in reloadFigures(): could'nt save temp into world.json after delay");
        e3.printStackTrace();
      }
    }
    println("reloadFigures(): updated IDs into world and world.json");
  }
  catch(Exception e) {
    println("reloadFigures(): World-File not found: "+fileName);
    println("Exception: "+e);
    world = new JSONArray();
    worldFigures.clear();
    addFigure("wall", 0, 0, 1, 1);

    try {
      saveJSONArray(world, "world.json");
      println("reloadFigures(): New generated empty world saved as world.json");
    }
    catch(Exception e2) {
      println("Error in reloadFigures() while saving world into world.json");
      e2.printStackTrace();
      delay(500);
      try {
        saveJSONArray(world, "world.json");
      }
      catch(Exception e3) {
        println("Couldn't save world after delay loading time");
        e3.printStackTrace();
      }
    }
  }
  worldFigures.clear();
  println("reloadFigures(): worldFigures cleard");
  for (int i = 0; i < world.size(); i++) {
    JSONObject jsn = world.getJSONObject(i);
    if (!jsn.getString("class").equals("missileLauncher")) {
      worldFigures.add(createFigure(jsn.getString("class"), jsn.getInt("x"), jsn.getInt("y"), 1, 1, jsn.getInt("id")));
    } else {
      worldFigures.add(createFigure(jsn.getString("class"), jsn.getInt("x"), jsn.getInt("y"), 1, 1, jsn.getInt("id"), jsn.getInt("interval"), jsn.getInt("offset"), jsn.getInt("direction")));
    }
  }
  println("Reloaded Figures of level: "+fileName);
  //println(level);
}

void updateIDs() {
  for (int i = 0; i < worldFigures.size(); i++) {
    worldFigures.get(i).id = i;
  }
}

//android
void touchEnded() {
  click(true);
}

//This function is called when the mouse button is released. It determines the action based on the current edit mode and mouse position.
void mouseReleased() {
  click(false);
}

//This function is called when the mouse button is released. It determines the action based on the current edit mode and mouse position.
void click(boolean touch) {
  if (inGame) {
    //if (touch == false) {
    //println("click(): "+getFigureAt(cam.getInWorldCoord(mouseX, mouseY)).getClass());
    //}
    if (editModeOn && !Right.touch() && !Left.touch() && !Up.touch() && !(editModeOn && Down.touch()) && !(mouseX+10 > RotateLeft.x && mouseY-10 < RotateLeft.y+RotateLeft.heightB) && mouseY<Left.y+Left.heightB && !(mouseX+10>Left.x && mouseX-10<Right.x+Right.widthB && mouseY+10>Left.y && mouseY-10<Left.y+Left.heightB)) {
      if (editMode != "remove") {
        Figure f = getFigureAt(cam.getInWorldCoord(mouseX, mouseY));
        if (f.id == -1) {
          if (editMode != "missileLauncher") {
            addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1);
          } else {
            println("Add Missilelauncher with rotation "+rotateMode);
            addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1, 100, rotateMode);
          }
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
        }
      } else {
        Figure f = getFigureAt(cam.getInWorldCoord(mouseX, mouseY));
        if (f.id != -1) {
          println("click(): Trying to remove Figure, id: "+f.id);
          removeFigure(f.id, true);
          println("click(): Figure removed");
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
        } else {
          println("click(): RemoveFigure: No Figure at this position found!");
        }
      }
    }
    if (editModeOn) {
      if (SwitchEdit.touch() &&(mouseButton==LEFT || touch)) {
        if (editModeOn) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          if (editModeInt < 7) {
            editModeInt++;
          } else {
            editModeInt = 0;
          }
          updateEditMode();
        }
      }
      if (SwitchEditNeg.touch() &&(mouseButton==LEFT || touch)) {
        if (editModeOn) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          if (editModeInt > 0) {
            editModeInt--;
          } else {
            editModeInt = 7;
          }
          updateEditMode();
        }
      }
      if (RotateLeft.touch() &&(mouseButton==LEFT || touch)) {
        if (editModeOn) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          switch(rotateMode) {
          case 0:
            rotateMode = 2;
            break;
          case 1:
            rotateMode = 3;
            break;
          case 2:
            rotateMode = 1;
            break;
          case 3:
            rotateMode = 0;
            break;
          }
        }
      }
      if (RotateRight.touch() &&(mouseButton==LEFT || touch)) {
        if (editModeOn) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          switch(rotateMode) {
          case 0:
            rotateMode = 3;
            break;
          case 1:
            rotateMode = 2;
            break;
          case 2:
            rotateMode = 0;
            break;
          case 3:
            rotateMode = 1;
            break;
          }
        }
      }
    }
    if (Exit.touch()&&(mouseButton==LEFT || touch || useTouchScreen)) {
      inGame = false;
      BgMusicSwitch.hitbox = true;
      SoundEffectsSwitch.hitbox = true;
      cam.x = 0;
      cam.y = 0;
      println("keyReleased(): Left Game, level: "+level);
      playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
      particles.removeAll(particles);
      gameFinished = false;
      loadTimes();
    }
    if (level > levelAmount || debug) {
      if (Edit.touch()&&(mouseButton==LEFT || touch)) {
        playSound(click, 0.7*SoundEffectsSwitch.timer, true);
        editModeOn = !editModeOn;
        Edit.pictureChange();
        player.vx = 0;
        player.vy = 0;
        if (height > width) {
          float widthScale = width/1080f;
          float  heightScale = height/2400f;

          Up = new Button(true, ButtonUP, clear, false, int(width/2f - (400/2) * width / 1080f), int(height-(10+450) * heightScale), int(400*widthScale), int(450*heightScale), 1, false, true);
          Down = new Button(true, ButtonDown, clear, false, int(width/2f - (400/2) * widthScale), int(height-((10+450) - (450/2)) * heightScale), int(400*widthScale), int(225*heightScale), 1, false, true);
        } else {
          float widthScale = width/2400f;
          float heightScale = height/1080f;
          Up = new Button(true, ButtonUP, clear, false, int(width-(240+320)*widthScale), int(height-(90+320)*heightScale), int(320*widthScale), int(320*heightScale), 1, false, true);
          Down = new Button(true, ButtonDown, clear, false, int(width-(240+320)*widthScale), int(height-(90+160)*heightScale), int(320*widthScale), int(160*heightScale), 1, false, true);
        }
        if (editModeOn) {
          Down.hitbox = true;
          Up.heightB = Up.heightB/2;
        } else {
          Down.hitbox = false;
          Up.heightB = Up.heightB*2;
        }
      }
      if (Share.touch()&&(mouseButton==LEFT || touch || useTouchScreen)) {
        if (coolDownTimer <= 0) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          // Save the JSONArray file to the device's internal storage
          String path = saveJSONArrayInternal(world, "exportlevel"+level+".json");

          // Share the JSONArray file
          shareFile(path);
          coolDownTimer=5;
          userMessage("Share this world with your friends!");
          userMessage("Export the.JSON-File and send it to them. They can import this file to their worlds.");
        }
      }
      if (Import.touch()&&(mouseButton==LEFT || touch || useTouchScreen)) {
        if (coolDownTimer <= 0) {
          userMessage("Import previously exported worlds. The file should be a.json file.");
          userMessage("If you import them to preinstalled worlds, the change will not be saved.");
          userMessage("You can import them to empty worlds to permanently save them.");
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          try {
            Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
            intent.setType("application/json");
            ((Activity) this.getActivity()).startActivityForResult(intent, 0);
          }
          catch(Exception e) {
            e.printStackTrace();
          }
          coolDownTimer=5;
        }
      }
    }
    if (gameFinished) {
      if (OK.touch()&&(mouseButton==LEFT || touch || useTouchScreen)) {
        coolDownTimer = 5;
        inGame = false;
        cam.x = 0;
        cam.y = 0;
        println("checkpoint(): Left Game, level: "+level);
        BgMusicSwitch.hitbox = true;
        SoundEffectsSwitch.hitbox = true;
        playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
        level++;
        LevelX.img = levelXImage(level);
        gameFinished = false;
        loadTimes();
      }
    }
  } else { //inGame == false
    if (everythingLoaded) {
      if (Settings.touch()&&(mouseButton==LEFT || touch)) {
        inSettings = !inSettings;
        playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
      }
      if (!inSettings) {
        if (LevelX.touch()&&(mouseButton==LEFT || touch)) {
          if (coolDownTimer <= 0) {
            println("click(): Button pressed: Start Level "+level);
            inGame = true;
            particles.clear();
            particles.removeAll(particles);
            startLevel(level);
            playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
          }
        }
        if (SkipRight.touch()&&(mouseButton==LEFT || touch)) {
          println("click(): Button pressed: SkipRight: "+level);
          level++;
          LevelX.img = levelXImage(level);
          playSound(click, 0.7*SoundEffectsSwitch.timer, true);
          updateTime();
        }
        if (SkipLeft.touch()&&(mouseButton==LEFT || touch)) {
          if (level > 1) {
            level--;
            LevelX.img = levelXImage(level);
            println("click(): Button pressed: SkipLeft: "+level);
          }
          playSound(click, 0.7*SoundEffectsSwitch.timer, true);
          updateTime();
        }
      } else {
        if (PrivacyPolicy.touch()&&(mouseButton==LEFT || touch)) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          openWebsiteInBrowser("https://www.notion.so/Privacy-Policy-EN-11fe08485f6a4d6e85765afba71b4006?pvs=4");
        }
        if (Music.touch()&&(mouseButton==LEFT || touch)) {
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
          openWebsiteInBrowser("https://youtube.com/playlist?list=PLwJjxqYuirCLkq42mGw4XKGQlpZSfxsYd");
        }
        if (BgMusicSwitch.touch()&&(mouseButton==LEFT || touch)) {
          BgMusicSwitch.clickEvent();
        }
        if (SoundEffectsSwitch.touch()&&(mouseButton==LEFT || touch)) {
          SoundEffectsSwitch.clickEvent();
        }
        if (DebugSwitch.touch()&&(mouseButton==LEFT || touch)) {
          DebugSwitch.clickEvent();
          debug = !debug;
        }
      }
    }
  }
}

void updateTime() {
  try {
    if (times != null) {
      time= new JSONObject();
      time.setInt("level", level);
      time.setInt("frames", player.getTime(level));
      if (time.getInt("frames") != -1) {
        timeFound = true;
      } else {
        timeFound = false;
      }
    } else {
      println("Error in updateTime(): times is empty");
    }
  }
  catch(Exception e) {
    time = null;
    timeFound = false;
    println("Error in updateTime()");
    e.printStackTrace();
  }
}

String saveJSONObjectInternal(JSONObject json, String filename) {
  String path = sketchPath("") + File.separator + filename;
  saveJSONObject(json, path);
  return path;
}

// Shares a file with the given path
void shareFile(String path) {
  try {
    File file = new File(path);
    println(file);
    JSONArray json = loadJSONArray(path);
    Uri contentUri = FileProvider.getUriForFile(this.getActivity(), "philipp_schroeder.geometryjump", file);

    // Share intent
    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
    shareIntent.setType("application/json");

    // Save intent
    //Intent saveIntent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
    //saveIntent.addCategory(Intent.CATEGORY_OPENABLE);
    //saveIntent.setType("application/json");
    //saveIntent.putExtra(Intent.EXTRA_TITLE, file.getName());

    // Chooser intent
    Intent chooserIntent = Intent.createChooser(shareIntent, "Share or save JSON");
    //chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Intent[] { saveIntent });

    startActivity(chooserIntent);
  }
  catch(Exception e) {
    println("Error in shareFile():");
    e.printStackTrace();
  }
}

// Saves a JSONArray to the device's internal storage and returns the file's path
String saveJSONArrayInternal(JSONArray json, String filename) {
  String path = sketchPath("") + File.separator + filename;
  saveJSONArray(json, path);
  return path;
}


//This function returns the figure at the given coordinates (x, y) in the world. It searches through the worldFigures ArrayList and checks if the player figure is present at the given coordinates as well.
Figure getFigureAt(int x, int y) {
  for (Figure f : worldFigures) {
    if (f.hitbox.pointInHitbox(x, y)) {
      //println("Found Figure of class: "+f.getClass() + ", at: "+x+", "+y+"; id: "+f.id);
      return f;
    }
  }
  if (player.hitbox.pointInHitbox(x, y)) { //Edit: if (player.hitbox.pointInHitbox(cam.getInWorldCoord(x, y))) {
    //println("Found Player Figure at: "+x+", "+y+"; id: "+player.id);
    return player;
  }
  //println("No element of Environment on this position found: "+x+", "+y+"; id: "+"-1");
  return new Figure();
}

//This function returns the Figure at a given Position (in PVector)
Figure getFigureAt(PVector v) {
  return getFigureAt(int(v.x), int(v.y));
}

void keyPressed() {
  keysPressed[keyCode] = true;
  keysPressed[key] = true;
}

void keyReleased() {
  keysPressed[keyCode] = false;
  keysPressed[key] = false;
  if (key == 'r') {
    loadImages();
  }
  if (key == 'b' || key == '1') {
    editModeInt = 1;
  }
  if (key == 'n' || key == '2') {
    editModeInt = 2;
  }
  if (key == 'm' || key == '3') {
    editModeInt = 3;
  }
  if (key == ',' || key == '0') {
    editModeInt = 0;
  }
  if (key == 'c' || key == '6') {
    editModeInt = 6;
  }
  if (key == 'v' || key == '5') {
    editModeInt = 5;
  }
  if (key == 'h' || key == '4') {
    editModeInt = 4;
  }
  if (key == 'l' || key == '7') {
    editModeInt = 7;
  }
  if (key == 'g') {
    gravity = !gravity;
  }
  if (key == 'e') {
    editModeOn = !editModeOn;
    Edit.pictureChange();
  }
  if (key == ENTER) {
    if (inGame) {
      inGame = false;
      BgMusicSwitch.hitbox = true;
      SoundEffectsSwitch.hitbox = true;
      cam.x = 0;
      cam.y = 0;
      println("keyReleased(): Left Game, level: "+level);
      particles.removeAll(particles);
    } else {
      inGame = true;
      BgMusicSwitch.hitbox = false;
      SoundEffectsSwitch.hitbox = false;
      particles.removeAll(particles);
      startLevel(level);
      playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
    }
  }
  if (key == 'u') {
    backgroundMusicAmp = 1-backgroundMusicAmp;
    println("Background Music volume set to: "+backgroundMusicAmp*100+"%");
  }
}

void updateEditMode() {
  switch(editModeInt) {
  case 0:
    editMode = "remove";
    break;
  case 2:
    editMode = "spike";
    break;
  case 3:
    editMode = "slime";
    break;
  case 4:
    editMode = "goal";
    break;
  case 5:
    editMode = "checkpoint";
    break;
  case 6:
    editMode = "coin";
    break;
  case 7:
    editMode = "missileLauncher";
    break;
  default:
    editMode = "wall";
    break;
  }
}

//This function loads the necessary images used in the program.
void loadImages() {
  String folder = "images/";
  spike = loadImage(folder+"spike.png");
  wall = loadImage(folder+"wall.png");
  play = loadImage(folder+"player.png");
  spikeGlow = loadImage(folder+"spikeGlow.png");
  slime = loadImage(folder+"slime.png");
  slimeGlow = loadImage(folder+"slimeGlow.png");
  wallGlow = loadImage(folder+"wallGlow.png");
  remove = loadImage(folder+"remove.png");
  coinGlow = loadImage(folder+"coinGlow.png");
  coin = loadImage(folder+"coin.png");
  checkpointGlow = loadImage(folder+"checkpointGlow.png");
  checkpoint = loadImage(folder+"checkpoint.png");
  BEditModeOff = loadImage(folder+"BEditModeOff.png");
  BEditModeOn = loadImage(folder+"BEditModeOn.png");
  BLevelX = loadImage(folder+"BLevelX.png");
  BLevel1Glow = loadImage(folder+"BLevel1Glow.png");
  loaded = 10;
  right = loadImage(folder+"right.png");
  rightGlow = loadImage(folder+"rightGlow.png");
  left = loadImage(folder+"left.png");
  leftGlow = loadImage(folder+"leftGlow.png");
  goalGlow = loadImage(folder+"goalGlow.png");
  particleStar = loadImage(folder+"particleStar.png");
  particleWall = loadImage(folder+"particleWall.png");
  ButtonLEFT = loadImage(folder+"ButtonLEFT.png");
  ButtonRIGHT = loadImage(folder+"ButtonRIGHT.png");
  ButtonUP = loadImage(folder+"ButtonUP.png");
  clear = loadImage(folder+"clear.png");
  ButtonEXIT = loadImage(folder+"ButtonEXIT.png");
  particleSlime = loadImage(folder+"particleSlime.png");
  particleCheckpoint = loadImage(folder+"particleCheckpoint.png");
  bgSwitch=loadImage(folder+"bg.png");
  offSwitch=loadImage(folder+"off.png");
  onSwitch=loadImage(folder+"on.png");
  ButtonSwitch=loadImage(folder+"switch.png");
  ButtonShare = loadImage(folder+"share.png");
  ButtonImport = loadImage(folder+"ButtonImport.png");
  ButtonDown = loadImage(folder+"ButtonDOWN.png");
  ButtonSettings = loadImage(folder+"settings.png");
  ButtonPrivacyPolicy = loadImage(folder+"privacypolicy.png");
  ButtonMusic = loadImage(folder+"music.png");
  Logo = loadImage(folder+"Logo.png");
  ButtonOK = loadImage(folder+"ok.png");
  goalAnimationBackground = loadImage(folder+"goalAnimationBackground.png");
  emptyCoin = loadImage(folder+"emptyCoin.png");
  Bullet1 = loadImage(folder+"Bullet1.png");
  Bullet2 = loadImage(folder+"Bullet2.png");
  Bullet3 = loadImage(folder+"Bullet3.png");
  Bullet4 = loadImage(folder+"Bullet4.png");
  missileLauncherGlow = loadImage(folder+"missileLauncherGlow.png");
  particleBullet = loadImage(folder+"particleBullet.png");
  ButtonSwitchNeg = loadImage(folder+"switchNeg.png");
  ButtonRotateRight = loadImage(folder+"rotateRight.png");
  ButtonRotateLeft = loadImage(folder+"rotateLeft.png");
  loaded = 20;
  println("loadImages(): all images loaded");
}

void loadTimes() {
  try {
    if (time == null) {
      times = loadJSONArray("times.json");
    }
  }
  catch (Exception e) {
    println("Error in loadTimes(): times.json not found");
    e.printStackTrace();
    times = new JSONArray();
    saveJSONArray(times, "times.json");
  }
  updateTime();
}


//This function loads the necessary sound files used in the program.
void loadSounds() {//backgroundMusicPlayer
  if (backgroundMusicPlayer != null) {
    for (int i = 0; i < backgroundMusicPlayer.length; i++) {
      if (backgroundMusicPlayer[i] != null) {
        backgroundMusicPlayer[i].stop();
        backgroundMusicPlayer[i].setVolume(0, 0);
      }
    }
  }
  String[] filenames = {"A_Night_Of_Dizzy_Spells.mp3", "Night_Shade.mp3", "Underclocked.mp3", "MAZE.mp3", "Powerup.mp3", "Sour Rock.mp3"};
  backgroundMusicPlayer = new MediaPlayer[filenames.length];
  for (int i = 0; i < filenames.length; i++) {
    backgroundMusicPlayer[i] = loadSound("sounds/backgroundMusic/"+filenames[i]);
  }
  backgroundMusicFilesLoaded = filenames.length;
  loaded = 45;
  String folder = "sounds/";
  loading = loadSound(folder+"loading.mp3");
  collectCoin = loadSound(folder+"collectCoin.mp3");
  loaded = 55;
  reset = loadSound(folder+"reset.mp3");
  click = loadSound(folder+"click interface.mp3");
  loaded = 70;
  jump = loadSound(folder+"jump.mp3");
  jumpSlime = loadSound(folder+"jumpSlime.mp3");
  loaded = 85;
  goalSound = loadSound(folder+"goal.mp3");
  tabChange = loadSound(folder+"tabChange.mp3");
  explosion = loadSound(folder+"explosion.mp3");
  loaded = 100;
  println("loadSounds(): all sounds loaded");
  everythingLoaded = true;
  loading.pause();
}

MediaPlayer loadSound(String path) {
  try {
    MediaPlayer m;
    // Load the sound file from the assets folder
    Context context = getActivity().getApplicationContext();
    AssetFileDescriptor afd = context.getAssets().openFd(path);
    m = new MediaPlayer();
    m.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
    m.prepare();
    return m;
  }
  catch (Exception e) {
    e.printStackTrace();
    return null;
  }
}

void playSound(MediaPlayer sound, boolean multiple) {
  playSound(sound, 1, multiple);
}

void playSound(MediaPlayer sound) {
  playSound(sound, 1, false);
}

void playSound(MediaPlayer sound, float amp) {
  playSound(sound, amp, false);
}

//This plays a SoundFile with specified volume ('amp'). If 'multiple' is true, it plays the sound again, even when this sound is already playing (multiple times at the same time)
void playSound(MediaPlayer sound, float amp, boolean multiple) {
  if (sound != null && amp > 0.0001) {
    if (sound.isPlaying() == false || multiple) {
      if (multiple) {
        MediaPlayer sound2 = new MediaPlayer();
        sound2 = sound;
        sound2.seekTo(0);
        sound2.setVolume(amp, amp);
        sound2.start();
      } else {
        sound.start();
        sound.setVolume(amp, amp);
      }
    } else if (sound.isPlaying() == true) {
      sound.setVolume(amp, amp);
    }
  }
}

void playBackgroundMusic() {
  if (everythingLoaded) {
    if (backgroundMusicPlays == -1 || !backgroundMusicPlayer[backgroundMusicPlays].isPlaying()) {
      backgroundMusicPlays = int(random(0, backgroundMusicFilesLoaded));
    }
    if (!backgroundMusicPlayer[backgroundMusicPlays].isPlaying()) {
      playSound(backgroundMusicPlayer[backgroundMusicPlays], 0.3, false);
    }
    if (backgroundMusicAmp == 0 && backgroundMusicPlayer[backgroundMusicPlays].isPlaying()) {
      stopSound(backgroundMusicPlays);
    }
  }
}

// Call this function to start playing the sound
void playSound(int index) {
  if (backgroundMusicPlayer[index] != null) {
    backgroundMusicPlayer[index].start();
  }
}

// Call this function with an integer to stop playing the corresponding sound
void stopSound(int index) {
  if (backgroundMusicPlayer[index] != null) {
    backgroundMusicPlayer[index].stop();
    try {
      // You need to prepare the media player again once it has been stopped
      backgroundMusicPlayer[index].prepare();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

void setVolumeMusic() {
  int n = whatPlays();
  for (int i = 0; i <  backgroundMusicFilesLoaded; i++) {
    try {
      backgroundMusicPlayer[i].setVolume(backgroundMusicAmp*0.3*int(n == i), backgroundMusicAmp*0.3);
    }
    catch(Exception e) {
      println("Error in setVolumeMusic(): "+i);
      e.printStackTrace();
    }
  }
}

boolean isMusicPlaying() {
  for (int i = 0; i <  backgroundMusicFilesLoaded; i++) {
    if ( backgroundMusicPlayer[i].isPlaying()) {
      return true;
    }
  }
  return false;
}

int whatPlays() {
  for (int i = 0; i <  backgroundMusicFilesLoaded; i++) {
    if ( backgroundMusicPlayer[i].isPlaying()) {
      return i;
    }
  }
  return -1;
}

//This function handles the key inputs for movement and other actions in the game.
void keyListener() {
  float speed = 2;
  float maxSpeed = 12;

  if (editModeOn) {
    // Check if 'w' key is pressed
    if (keysPressed['w']) {
      if (player.vy >-maxSpeed) {
        player.vy -= speed;
      }
    }
    // Check if 's' key is pressed
    if (keysPressed['s']) {
      if (player.vy < maxSpeed) {
        player.vy += speed;
      }
    }
  }


  // Check if 'a' key is pressed
  if (keysPressed['a']) {
    if (player.vx >-maxSpeed) {
      player.vx -= speed;
    }
  }



  // Check if 'd' key is pressed
  if (keysPressed['d']) {
    if (player.vx < maxSpeed) {
      player.vx += speed;
    }
  }

  // Check if spacebar (' ') is pressed
  if (keysPressed[' ']) {
    player.jump();
  }
}

void coinAnimation(int x, int y) {
  particleAnimation(x, y, particleStar);
}

void particleAnimation(int x, int y, PImage img, int count, int size) {
  particleAnimation(x, y, img, count, size, 5, -5, -5, -20);
}

void particleAnimation(int x, int y, PImage img, int count, int size, int maxVX, int minVX, int maxVY, int minVY) {
  for (int i = 0; i < count; i++) {
    particles.add(new Particle(x+int(random(-8, 8)), y+int(random(-8, 8)), img, size, maxVX, minVX, maxVY, minVY));
  }
}

void bulletAnimation(int x, int y, int minVX, int maxVX, int minVY, int maxVY) {
  particles.add(new Particle(x+int(random(-8, 8)), y+int(random(-8, 8)), particleBullet, 20, maxVX, minVX, maxVY, minVY));
  particles.get(particles.size()-1).maxTime = int(random(4, 8));
}

void explosionAnimation(Figure f) {
  particleAnimation(int(f.x), int(f.y), particleBullet, 30, 60, int(f.vx)+8, int(f.vx)-8, int(f.vy)+8, int(f.vy)-8);
  playSound(explosion, (blockSize*blockSize*7f/sq(dist(player.x+player.w/2f, player.y+player.h/2f, f.x+f.w/2f, f.y+f.h/2f)))*SoundEffectsSwitch.timer, true);
  //particleAnimation(x, y, particleBullet, 8, 60);
}

void particleAnimation(int x, int y, PImage img, int count) {
  particleAnimation(x, y, img, count, 20);
}
void particleAnimation(int x, int y, PImage img) {
  particleAnimation(x, y, img, 10);
}

void deathAnimation(int x, int y) {
  particleAnimation(x, y, play, 20);
}

void slimeAnimation(int x, int y) {
  particleAnimation(x, y, particleSlime, 7, 35);
}

void checkpointAnimation(int x, int y) {
  particleAnimation(x, y, particleCheckpoint, 25, 20);
}

void wallAnimation(int x, int y) {
  particleAnimation(x, y, particleWall, 1, 15, 5, -5, -2, -7);
}

PImage levelXImage(int printLevel) {
  PImage vorlage = loadImage("images/"+"vorlage.png");
  PGraphics pg= createGraphics(640, 440);
  pg.beginDraw();
  pg.image(vorlage, 0, 0);
  pg.fill(255);
  if (printLevel < 10) {
    pg.textSize(180);
  } else if (printLevel < 100) {
    pg.textSize(150);
  } else if (printLevel < 1000) {
    pg.textSize(140);
  } else {
    pg.textSize(120);
  }
  pg.text("Level "+printLevel, 30, 270);
  pg.endDraw();
  return pg;
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  if (requestCode == 0 && resultCode == Activity.RESULT_OK) {
    Uri uri = data.getData();
    println("Selected file URI: " + uri.toString());
    try {
      InputStream inputStream = getActivity().getContentResolver().openInputStream(uri);
      BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
      StringBuilder stringBuilder = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        stringBuilder.append(line);
      }
      reader.close();
      inputStream.close();
      JSONArray json = JSONArray.parse(stringBuilder.toString());
      if (json == null) {
        println("Could not parse json file.");
      } else {
        world = json;
        try {
          saveJSONArray(world, "world.json");
          if (level > levelAmount) {
            saveJSONArray(world, "level"+level+".json");
          }
        }
        catch(Exception e) {
          println("Error in onActivityResult() while saving world into world.json");
          e.printStackTrace();
          delay(500);
          try {
            saveJSONArray(world, "world.json");
          }
          catch(Exception e2) {
            println("Couldn't save world after delay loading time");
            e2.printStackTrace();
          }
        }
        reloadFigures("world");
      }
    }
    catch (IOException e) {
      println("Error reading file: " + e.getMessage());
    }
  }
}

public static String getPath(Context context, Uri uri) {
  String[] projection = { MediaStore.Images.Media.DATA };
  Cursor cursor = context.getContentResolver().query(uri, projection, null, null, null);
  if (cursor == null) return null;
  int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
  cursor.moveToFirst();
  String s = cursor.getString(column_index);
  cursor.close();
  return s;
}

void importFile() {
  try {
    //handles import of .json file
    Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
    intent.setType("application/json");
    ((Activity) this.getActivity()).startActivityForResult(intent, 0);
  }
  catch(Exception e) {
    println("Error in importFile():");
    e.printStackTrace();
  }
}

void userMessage(String s) {
  try {
    runOnUiThread(new Runnable() {
      public void run() {
        try {
          Toast.makeText(getContext(), s, Toast.LENGTH_LONG).show();
        }
        catch(Exception e) {
          println("Error in userMessage(): Couldn't get context by getContext():");
          e.printStackTrace();
        }
      }
    }
    );
  }
  catch(Exception e2) {
    println("Error in userMessage():");
    e2.printStackTrace();
  }
}

Context getContext() {
  return getActivity();
}

void openWebsiteInBrowser(String url) {
  try {
    // Ensure the URL starts with "http://" or "https://"
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "http://" + url;
    }

    // Create an intent to open the URL in the default web browser
    Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
    startActivity(browserIntent);
  }
  catch (Exception e) {
    // Handle the case where no web browser is installed
    e.printStackTrace();
    try {
      Toast.makeText(getContext(), "No application can handle this request. Please install a web browser.", Toast.LENGTH_LONG).show();
    }
    catch(Exception e2) {
      println("Error in openWebsiteInBrowser(): Couldn't get context by getContext():");
      e2.printStackTrace();
    }
  }
}

void loadData() {
  try {
    player = new Player(0, -1, blockSize, blockSize);
    JSONObject data = loadJSONObject(sketchPath("data.json"));
    level = getIntJSON(data, "level");
    rotateMode = getIntJSON(data, "rotateMode");
    println("Loaded: "+rotateMode);
    editModeInt = getIntJSON(data, "editModeInt");
    editMode = getStringJSON(data, "editMode");
    coinsCollected = getIntJSON(data, "coinsCollected");
    inGame = getBooleanJSON(data, "inGame");
    framesSinceStarted = data.getInt("framesSinceStarted");
    player.x = getFloatJSON(data, "player.x");
    player.y = getFloatJSON(data, "player.y");
    player.vx = getFloatJSON(data, "player.vx");
    player.vy = getFloatJSON(data, "player.vy");
    player.grounded = getBooleanJSON(data, "player.grounded");
    gameFinished = getBooleanJSON(data, "gameFinished");
    player.checkpointBlock = new PVector(getIntJSON(data, "player.checkpointBlock.x"), getIntJSON(data, "player.checkpointBlock.y"));
    backgroundMusicPlays = getIntJSON(data, "backgroundMusicPlays");
    editModeOn = getBooleanJSON(data, "editModeOn");
    println("loadData(): Loaded data.json");
    if (inGame) {
      reloadFigures("world");
    }
    LevelX.img = levelXImage(level);
    updateTime();
    println("loadData(): Data successfully loaded");
  }
  catch(Exception e) {
    println("Error in loadData():");
    e.printStackTrace();
  }
}

int getIntJSON(JSONObject data, String type) {
  try {
    return data.getInt(type);
  }
  catch(Exception e) {
    println("Error in getIntJSON(): type: "+type);
    e.printStackTrace();
  }
  return -1;
}

float getFloatJSON(JSONObject data, String type) {
  try {
    return data.getFloat(type);
  }
  catch(Exception e) {
    println("Error in getIntJSON(): type: "+type);
    e.printStackTrace();
  }
  return -1;
}

boolean getBooleanJSON(JSONObject data, String type) {
  try {
    return data.getBoolean(type);
  }
  catch(Exception e) {
    println("Error in getIntJSON(): type: "+type);
    e.printStackTrace();
  }
  return false;
}

String getStringJSON(JSONObject data, String type) {
  try {
    return data.getString(type);
  }
  catch(Exception e) {
    println("Error in getIntJSON(): type: "+type);
    e.printStackTrace();
  }
  return "wall";
}

void saveData() {
  try {
    JSONObject data = new JSONObject();
    data.setInt("level", level);
    data.setInt("rotateMode", rotateMode);
    data.setInt("editModeInt", editModeInt);
    data.setString("editMode", editMode);
    data.setInt("coinsCollected", coinsCollected);
    data.setBoolean("inGame", inGame);
    data.setInt("framesSinceStarted", framesSinceStarted);
    data.setInt("coinsInWorld", coinsInWorld);
    data.setFloat("player.x", player.x);
    data.setFloat("player.y", player.y);
    data.setFloat("player.vx", player.vx);
    data.setFloat("player.vy", player.vy);
    data.setBoolean("player.grounded", player.grounded);
    data.setFloat("player.checkpointBlock.x", player.checkpointBlock.x);
    data.setFloat("player.checkpointBlock.y", player.checkpointBlock.y);
    data.setBoolean("gameFinished", gameFinished);
    data.setInt("backgroundMusicPlays", backgroundMusicPlays);
    data.setBoolean("editModeOn", editModeOn);
    saveJSONObject(data, sketchPath("data.json"));

    if (world != null) {
      saveJSONArray(world, "world.json");
    }
  }
  catch(Exception e) {
    println("Error in saveData():");
    e.printStackTrace();
  }
}
