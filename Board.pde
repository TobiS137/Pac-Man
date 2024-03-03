class Board {

  PImage bg;
  Array2D<Cell> cells;

  float cellSize;
  Actor[] actors;
  PacMan pm;

  HashMap<Integer, PVector> directions;
  
  int pelletCount;
  
  

  Board(PImage bg, String tileMapFileName) {
    this.bg = bg;
    cellSize = (height - 40.0 - marginTop - marginBottom) / (loadStrings(tileMapFileName).length - 1.0);
    cells = loadTileMap(tileMapFileName);
    directions = new HashMap<Integer, PVector>();
    directions.put(UP, new PVector(0, -1));
    directions.put(LEFT, new PVector(-1, 0));
    directions.put(DOWN, new PVector(0, 1));
    directions.put(RIGHT, new PVector(1, 0));
    actors = new Actor[5];
    createActors(actors);
  }

  void createActors(Actor[] actors) {
    pm = new PacMan(this, boardToWorldSpace(13.5, 23));
    actors[0] = pm;

    actors[1] = new Ghost(this, boardToWorldSpace(9, 11), new BlinkyBehavior(this), new PVector(25, -4));
    actors[2] = new Ghost(this, boardToWorldSpace(12, 11), new PinkyBehavior(this), new PVector(2, -4));
    actors[3] = new Ghost(this, boardToWorldSpace(15, 11), new InkyBehavior(this), new PVector(27, 31));
    actors[4] = new Ghost(this, boardToWorldSpace(18, 11), new ClydeBehavior(this), new PVector(1, 31));
  }
  
  void update() {
    for (int i = 1; i < actors.length; i++) {
      if (checkCollision(pm, (Ghost)actors[i])){
        pm.kill();
      }// if
    }// for i
  }

  void draw() {
    translate(0, marginTop);
    image(bg, 0, 0);
    cells.forEach((cell) -> {
      cell.draw();
      //cell.showTiles();
    }
    );

    for (Actor a : actors) {
      if (a == null) {
        continue;
      }// if
      a.move();
      a.draw();
    }// for each
  }
  
  boolean checkCollision(PacMan pm, Ghost ghost) {
    return pm.getIndex().equals(ghost.getIndex());
  }

  void keyPressed(int code) {
    pm.keyPressed(code);
  }

  Array2D<Cell> loadTileMap(String fileName) {
    String[] lines = loadStrings(fileName);
    Array2D<Cell> cells = new Array2D<Cell>(lines[0].length(), lines.length);
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      for (int j = 0; j < line.length(); j++) {
        switch(line.charAt(j)) {
        case '#':
          cells.set(j, i, new Wall(this, j, i, cellSize));
          break;
        case ' ':
          cells.set(j, i, new Tile(this, j, i, cellSize));
          break;
        default:
        }
      }// for j
    }// for i
    return cells;
  }

  PVector boardToWorldSpace(float x, float y) {
    return new PVector(20 + x * cellSize, 20 + y * cellSize);
  }

  PVector worldToBoardSpace(float x, float y) {
    return new PVector(floor(x / cellSize), floor(y / cellSize));
  }

  int directionToFacing(PVector direction) {
    PVector roundedDirection = new PVector(round(direction.x), round(direction.y));
    for (Map.Entry<Integer, PVector> entry : directions.entrySet()) {
      if (entry.getValue().equals(roundedDirection)) {
        return entry.getKey();
      }// if
    }// for each
    return 0;
  }
  
  void addPellet() {
    pelletCount++;
  }
  
  void removePellet() {
    pelletCount--;
    pm.pelletPause(1);
  }

  Cell getCell(float x, float y) {
    return cells.get((int)x, (int)y);
  }

  PacMan getPacMan() {
    return pm;
  }

  Ghost getBlinky() {
    return (Ghost)actors[1];
  }

  Ghost getPinky() {
    return (Ghost)actors[2];
  }

  Ghost getInky() {
    return (Ghost)actors[3];
  }

  PVector getDirectionVector(int facing) {
    return directions.get(facing).copy();
  }

  float getCellSize() {
    return cellSize;
  }
}
