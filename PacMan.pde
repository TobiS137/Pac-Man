class PacMan extends Actor {

  Integer inputBuffer = null;
  
  int pauseFrames = 0;

  PacMan(Board b, float x, float y) {
    super(b, x, y);
  }

  PacMan(Board b, PVector pos) {
    super(b, pos.x, pos.y);
  }

  void move() {
    if (pauseFrames > 0){
      pauseFrames--;
      return;
    }// if
    if (inputBuffer != null) {
      PVector bufferFacingVector = b.getDirectionVector(inputBuffer);
      PVector bufferIndex = PVector.add(index, bufferFacingVector);
      bufferIndex.x = (bufferIndex.x + 28) % 28;
      Cell bufferCell = b.getCell(bufferIndex.x, bufferIndex.y);
      if (bufferCell instanceof Tile) {
        facing = inputBuffer;
        inputBuffer = null;
      }// if
    }// if

    PVector facingVector = b.getDirectionVector(facing);
    PVector nextIndex = PVector.add(index, facingVector);
    nextIndex.x = (nextIndex.x + 28) % 28;
    Cell nextTile = b.getCell(nextIndex.x, nextIndex.y);
    if (nextTile instanceof Wall) {
      pos = PVector.add(pos, PVector.sub(b.boardToWorldSpace(index.x, index.y), pos).limit(moveSpeed));
    } else {
      pos = PVector.add(pos, facingVector.setMag(moveSpeed));
      pos.x = (pos.x + width) % width;
      index = b.worldToBoardSpace(pos.x, pos.y);
      index.x = (index.x + 28) % 28;
    }// if

    if (facing == LEFT || facing == RIGHT) {
      float desiredY = b.boardToWorldSpace(index.x, index.y).y;
      if (pos.y < desiredY) {
        pos.y += min(abs(desiredY - pos.y), moveSpeed);
      }// if
      if (pos.y > desiredY) {
        pos.y -= min(abs(desiredY - pos.y), moveSpeed);
      }// if
    }// if

    if (facing == UP || facing == DOWN) {
      float desiredX = b.boardToWorldSpace(index.x, index.y).x;
      if (pos.x < desiredX) {
        pos.x += min(abs(desiredX - pos.x), moveSpeed);
      }// if
      if (pos.x > desiredX) {
        pos.x -= min(abs(desiredX - pos.x), moveSpeed);
      }// if
    }// if

    Tile currentTile = (Tile)b.getCell(index.x, index.y);
    currentTile.collectPellet();
  }

  void draw() {
    push();
    fill(255, 255, 0);
    noStroke();
    circle(pos.x, pos.y, 50);
    if (pos.x < 25) {
      circle(width + pos.x, pos.y, 50);
    }// if

    if (pos.x > width - 25) {
      circle(pos.x - width, pos.y, 50);
    }// if
    pop();
  }

  void keyPressed(int code) {
    if (code != UP && code != LEFT && code != DOWN && code != RIGHT) {
      return;
    }// if

    PVector facingVector = b.getDirectionVector(code);
    PVector facingCellPos = PVector.add(pos, facingVector.mult(b.getCellSize()));
    PVector facingCellIndex = b.worldToBoardSpace(facingCellPos.x, facingCellPos.y);
    facingCellIndex.x = (facingCellIndex.x + 28) % 28;
    Cell facingCell = b.getCell(facingCellIndex.x, facingCellIndex.y);
    if (facingCell instanceof Tile) {
      facing = code;
      inputBuffer = null;
      return;
    }// if
    inputBuffer = code;
  }

  void kill() {
    noLoop();
  }

  void setMoveSpeed(float moveSpeed) {
    this.moveSpeed = moveSpeed;
  }
  
  void pelletPause(int frames) {
    pauseFrames += frames;
  }
}
