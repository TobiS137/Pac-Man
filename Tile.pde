class Tile extends Cell {

  String collectible = "";

  Tile(Board b, float x, float y, float size) {
    super(b, x, y, size);

    if (
      (index.x == 1 && index.y == 3) ||
      (index.x == 26 && index.y == 3) ||
      (index.x == 1 && index.y == 22) ||
      (index.x == 26 && index.y == 22)
      ) {
      collectible = "P";
      b.addPellet();
    } else if (!tileInMiddleRing() &&
      !tileInSideCorridors() &&
      !(index.x == 13 && index.y == 23) &&
      !(index.x == 14 && index.y == 23)) {
      collectible = "p";
      b.addPellet();
    }// if
  }

  void draw() {
    PVector worldPos = b.boardToWorldSpace(index.x, index.y);
    push();
    fill(255, 255, 150);
    noStroke();
    rectMode(CENTER);
    if (collectible == "P") {
      rect(worldPos.x, worldPos.y, 30, 20);
      rect(worldPos.x, worldPos.y, 20, 30);
    } else if (collectible == "p") {
      rect(worldPos.x, worldPos.y, 10, 10);
    }// if
    pop();
  }

  boolean tileInMiddleRing() {
    return index.x > 7 && index.x < 20 && index.y > 8 && index.y < 20;
  }

  boolean tileInSideCorridors() {
    return index.y == 14 && !(index.x == 6 || index.x == 21);
  }

  void collectPellet() {
    if (collectible != "") {
      collectible = "";
      b.removePellet();
    }// if
  }
}
