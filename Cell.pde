class Cell {

  Board b;
  PVector index;
  float size;

  Cell(Board b, float x, float y, float size) {
    this.b = b;
    this.index = new PVector(x, y);
    this.size = size;
  }
  
  void draw() {
  }
  
  void showTiles() {
    PVector worldPos = b.boardToWorldSpace(index.x, index.y);
    push();
    rectMode(CENTER);
    noFill();
    stroke(255);
    strokeWeight(1);
    rect(worldPos.x, worldPos.y, size, size);
    pop();
  }
  
  PVector getIndex() {
    return index;
  }
}
