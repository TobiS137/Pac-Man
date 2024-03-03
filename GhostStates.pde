abstract class GhostBehavior {

  Board b;

  Pathfinder pathfinder;

  color placeHolderColor;

  GhostBehavior(Board b) {
    this.b = b;
    pathfinder = new BasicPathfinder(b);
  }

  void draw(float x, float y) {
    push();
    fill(placeHolderColor);
    noStroke();
    circle(x, y, 50);
    if (x < 25) {
      circle(width + x, y, 50);
    }// if

    if (x > width - 25) {
      circle(x - width, y, 50);
    }// if
    pop();
  }
  Move getNextMove(Ghost ghost) {
    PVector targetIndex = getTarget(ghost);
    return pathfinder.getNextTile(ghost, targetIndex);
  }

  Move[] getFullPath(Ghost ghost) {
    PVector targetIndex = getTarget(ghost);
    return pathfinder.getFullPathToTarget(ghost, targetIndex);
  }

  abstract PVector getTarget(Ghost ghost);
}

class BlinkyBehavior extends GhostBehavior {

  BlinkyBehavior(Board b) {
    super(b);
    placeHolderColor = color(255, 0, 0);
  }

  PVector getTarget(Ghost ghost) {
    return b.getPacMan().getIndex();
  }
}

class PinkyBehavior extends GhostBehavior {

  PinkyBehavior(Board b) {
    super(b);
    placeHolderColor = color(255, 181, 255);
  }

  PVector getTarget(Ghost ghost) {
    PVector pacManIndex = b.getPacMan().getIndex();
    PVector pacManPos = b.boardToWorldSpace(pacManIndex.x, pacManIndex.y);
    PVector facingVector = b.getDirectionVector(b.getPacMan().getFacing());
    facingVector.mult(b.getCellSize() * 4);
    PVector targetPos = PVector.add(pacManPos, facingVector);
    return b.worldToBoardSpace(targetPos.x, targetPos.y);
  }
}

class InkyBehavior extends GhostBehavior {

  InkyBehavior(Board b) {
    super(b);
    placeHolderColor = color(0, 255, 255);
  }

  PVector getTarget(Ghost ghost) {
    PVector pacManIndex = b.getPacMan().getIndex();
    PVector facingVector = b.getDirectionVector(b.getPacMan().getFacing()).mult(2);
    PVector pivotIndex = PVector.add(pacManIndex, facingVector);
    PVector blinkyIndex = b.getBlinky().getIndex();
    PVector pointer = PVector.sub(blinkyIndex, pivotIndex);
    pointer.rotate(PI);
    PVector targetIndex = PVector.add(pivotIndex, pointer);
    return targetIndex;
  }
}

class ClydeBehavior extends GhostBehavior {

  ClydeBehavior(Board b) {
    super(b);
    placeHolderColor = color(255, 185, 82);
  }

  PVector getTarget(Ghost ghost) {
    PVector pacManIndex = b.getPacMan().getIndex();
    PVector ghostIndex = ghost.getIndex();
    float distToPacMan = dist(ghostIndex.x, ghostIndex.y, pacManIndex.x, pacManIndex.y);
    if (distToPacMan > 8) {
      return pacManIndex;
    }// if
    return ghost.getCorner();
  }
}
