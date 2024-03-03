class Ghost extends Actor {

  GhostBehavior defaultBehavior;
  PVector corner;

  float corridorSpeedFraction = 0.5;

  GhostBehavior currentBehavior;
  Tile movingTo;
  PVector currentMovement;

  Ghost(Board b, PVector pos, GhostBehavior defaultBehavior, PVector corner) {
    super(b, pos.x, pos.y);
    this.defaultBehavior = defaultBehavior;
    currentBehavior = defaultBehavior;
    this.corner = corner;
    movingTo = currentBehavior.getNextMove(this).getTile();
    PVector nextTileIndex = movingTo.getIndex();
    PVector nextTilePos = b.boardToWorldSpace(nextTileIndex.x, nextTileIndex.y);
    currentMovement = PVector.sub(nextTilePos, pos).limit(moveSpeed);
  }

  void move() {
    PVector nextMoveIndex = movingTo.getIndex();
    PVector tilePos = b.boardToWorldSpace(nextMoveIndex.x, nextMoveIndex.y);
    currentMovement.limit(dist(pos.x, pos.y, tilePos.x, tilePos.y));
    pos = PVector.add(pos, currentMovement);
    pos.x = (pos.x + width) % width;
    index = b.worldToBoardSpace(pos.x, pos.y);
    float distToTile = dist(pos.x, pos.y, tilePos.x, tilePos.y);
    if (distToTile < moveSpeed) {
      Move nextMove = currentBehavior.getNextMove(this);
      movingTo = nextMove.getTile();
      PVector nextTileIndex = movingTo.getIndex();
      PVector nextTilePos = b.boardToWorldSpace(nextTileIndex.x, nextTileIndex.y);
      currentMovement = PVector.sub(nextTilePos, pos).limit(moveSpeed);
      if ((index.x == 0 && nextTileIndex.x == 27) || (index.x == 27 && nextTileIndex.x == 0)) {
        currentMovement.mult(-1);
      }// if
      
      if (index.y == 14 && nextTileIndex.y == 14 &&
        ((index.x < 6 && nextTileIndex.x < 6)
        || (index.x > 21 && nextTileIndex.x > 21))
        ){
        currentMovement.mult(corridorSpeedFraction);
      }// if
      facing = nextMove.getFacing();
    }// if
  }

  void draw() {
    currentBehavior.draw(pos.x, pos.y);
  }

  PVector getCorner() {
    return corner;
  }
}
