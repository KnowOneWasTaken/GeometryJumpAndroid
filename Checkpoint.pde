class Checkpoint extends Wall {
  Checkpoint(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    box = checkpoint;
    glow = checkpointGlow;
  }
  Checkpoint() {
    super(0,0,0,0,-1);
  }
}
