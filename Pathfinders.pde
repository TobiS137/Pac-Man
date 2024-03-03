abstract class Pathfinder {

  Board b;

  Pathfinder(Board b) {
    this.b = b;
  }

  abstract Move getNextTile(Ghost ghost, float gx, float gy);

  Move getNextTile(Ghost ghost, PVector goal) {
    return getNextTile(ghost, goal.x, goal.y);
  }

  abstract Move[] getFullPathToTarget(Ghost ghost, float gx, float gy);

  Move[] getFullPathToTarget(Ghost ghost, PVector goal) {
    return getFullPathToTarget(ghost, goal.x, goal.y);
  }
}

class BasicPathfinder extends Pathfinder {

  BasicPathfinder(Board b) {
    super(b);
  }
  
  Move getNextTile(Ghost ghost, float gx, float gy) {
    int facing = ghost.getFacing();
    PVector pos = ghost.getPos();
    Move[] nonBackwardMoves = new Move[3];

    PVector facingVector = b.getDirectionVector(facing);
    int index = ((facing == UP) ? 2 : (facing == RIGHT) ? 1 : 0);
    facingVector.rotate(HALF_PI);
    for (int i = 0; i < 3; i++) {
      PVector tilePos = PVector.add(pos, facingVector.copy().mult(b.getCellSize()));
      PVector tileIndex = b.worldToBoardSpace(tilePos.x, tilePos.y);
      tileIndex.x = (tileIndex.x + 28) % 28;
      Cell cell = b.getCell(tileIndex.x, tileIndex.y);
      if (cell instanceof Tile) {
        nonBackwardMoves[index] = new Move((Tile)cell, b.directionToFacing(facingVector.copy()));
      }// if
      facingVector.rotate(-HALF_PI);
      index = (index + 1) % 3;
    }// for i

    Move closestMove = null;
    Float closestDist = null;
    for (Move move : nonBackwardMoves) {
      if (move == null) {
        continue;
      }// if
      Tile t = move.getTile();
      PVector tileIndex = t.getIndex();
      float dist = dist(tileIndex.x, tileIndex.y, gx, gy);
      if (closestDist == null || dist < closestDist) {
        closestMove = move;
        closestDist = dist;
      }// if
    }// for each
    return closestMove;
  }

  Move[] getFullPathToTarget(Ghost ghost, float gx, float gy) {
    return null;
  }
}

class Move {
  Tile tile;
  int facing;

  Move(Tile tile, int facing) {
    this.tile = tile;
    this.facing = facing;
  }

  Tile getTile() {
    return tile;
  }

  int getFacing() {
    return facing;
  }
}
