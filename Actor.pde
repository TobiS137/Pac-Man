class Actor {

  Board b;
  PVector pos;
  PVector index;
  int facing = LEFT;
  final float baseMoveSpeed;
  float moveSpeed;

  Actor(Board b, float x, float y) {
    this.b = b;
    this.pos = new PVector(x, y);
    this.index = b.worldToBoardSpace(x, y);
    baseMoveSpeed = 5.33;
    moveSpeed = baseMoveSpeed;
  }
  
  void move() {
    
  }

  void draw() {
  }
  
  PVector getIndex() {
    return index;
  }
  
  PVector getPos() {
    return pos;
  }
  
  int getFacing() {
    return facing;
  }
}
