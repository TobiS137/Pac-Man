import rna.inputs.*;
import rna.tools.*;
import rna.util.*;
import java.util.Map;

Board board;

int marginTop = 0;
int marginBottom = 0;

void settings() {
  size(1000, 1106 + marginTop + marginBottom);
}

void setup() {
  board = new Board(loadImage("board.png"), "tileMap.txt");
}// setup

void draw() {
  background(13, 13, 13);
  board.update();
  board.draw();
}// draw
