Bird flappy;
float g;
int speed;
Stage level;
int pipeWidth;
int pipes_to_the_left; // for keeping track of score.
boolean running;

void setup() {
  running = true;
  size(400, 600);
  background(75, 200, 225);
  g = 0.1;
  speed = 2;
  pipeWidth = 40;
  flappy = new Bird(100, 290, 240, 245, 55);
  level = new Stage();
}

void draw() {
  if (running){
    background(75, 200, 225); 
    level.advance(); //should the level advance or the bird move first?
    flappy.update();
    flappy.drawMe(); // draw the bird after drawing the level, to make the bird be in front.
    if (level.checkCollisions(flappy)) {
      gameOver(level, flappy);
    }
    level.removeOldPipes();
    
    // print score to screen
    fill(255,255,0);
    textSize(20);
    text(flappy.pipesPassed, width / 2, height * 0.1 );
  }
}

void mousePressed() {
  if (running){
    flappy.flap();
  }
}

class Bird {
  int x;
  int y;
  color col;
  float velY;
  int birdWidth;
  int birdHeight;
  int pipesPassed = 0;
  Bird(int posX, int posY, int rcol, int gcol, int bcol) {
    x = posX;
    y = posY;
    birdWidth = 20;
    birdHeight = 20;
    col = color(rcol, gcol, bcol);
  }
  void drawMe() {
    fill(col);
    rect(x, y, birdWidth, birdHeight);
  }
  void update() {
    velY = velY + g;
    y += velY;
    
    // track score
    int count = 0;
    for (Pipe p : level.pipeList){
      if (p.x + pipeWidth < this.x) count++;
    }
    if (count > pipes_to_the_left){
      pipesPassed++;
    }
    pipes_to_the_left = count;
  }
  void flap() {
    velY = -30*g;
    y += velY;
  }
}

class Pipe {
  int x;
  int gapSize;
  int start;
  int min_gapSize;
  int max_gapSize;
  int smin;
  int smax;
  Pipe(int pos) {
    min_gapSize = 100;
    max_gapSize = 100;
    smin = 100;
    smax = 500;
    gapSize = floor(random(min_gapSize, max_gapSize+1));
    start = floor(random(smin, smax-gapSize+1));
    x = pos;
  }
  void drawMe() {
    fill(0, 255, 0);
    rect(x, 0, pipeWidth, start);
    rect(x, start+gapSize, pipeWidth, height-start+gapSize);
  }
  void update() {
    x -= speed;
  }
  //checks collision with a point x,y
  boolean checkCollision(int birdX, int birdY) {
    if (birdX >= x && birdX <= x+pipeWidth) {
      //top part
      if (birdY >= 0 && birdY <= start) {
        return true;
      }
      //bottom part
      if (birdY >= start+gapSize && birdY <= height) {
        return true;
      }
    }
    return false;
  }
}

class Stage {
  int tick;
  int tickInt;
  int tickLimit;
  ArrayList<Pipe> pipeList = new ArrayList<Pipe>();
  Stage() {
    tick = 0;
    tickLimit = speed*50;
  }
  void advance() {
    if (tick >= tickLimit || tick == 0) {
      tick = 0;
      tickInt = 1;
      pipeList.add(new Pipe(width));
    }
    tick += tickInt;
    for (int i=0; i<pipeList.size (); i++) {
      Pipe p = pipeList.get(i);
      p.update();
      p.drawMe();
    }
  }
  void removeOldPipes() {
    for (int i=0; i<pipeList.size (); i++) {
      Pipe p = pipeList.get(i);
      if (p.x <= 0-pipeWidth) {
        pipeList.remove(p);
        pipes_to_the_left--;
      }
    }
  }
  boolean checkCollisions(Bird bird) {
    boolean c = false;
    if (bird.y > height - bird.birdHeight) {
      bird.y = height - bird.birdHeight;
      bird.velY = 0;
      c = true;
    }
    if (bird.y < 0) {
      bird.y = 0;
      bird.velY = 0;
    }
    //huge collision check algorithm
    //for each pipe check collision
    for (int i=0; i<pipeList.size (); i++) {
      Pipe p = pipeList.get(i);
      /*
        //top surface of bird
       for (int m=bird.x; m<=bird.x+bird.birdWidth; m++) {
       p.checkCollision(m,bird.y);
       }
       //bottom surface of bird
       for (int m=bird.x; m<=bird.x+bird.birdWidth; m++) {
       p.checkCollision(m,bird.y+bird.birdHeight);
       }*/

      // If our bird is rectangular, it is more efficient just to check the corners.
      c = c || p.checkCollision(bird.x, bird.y);
      c = c || p.checkCollision(bird.x + bird.birdWidth, bird.y);
      c = c || p.checkCollision(bird.x, bird.y + bird.birdHeight);
      c = c || p.checkCollision(bird.x + bird.birdWidth, bird.y + bird.birdHeight);
    }
    return c;
  }
}

void gameOver(Stage stage, Bird bird) {
  noLoop(); // note: this will stop the draw loop from running. It will also cause the program to stop recognizing mouse/keyboard events.
  running = false;
  speed = 0;
  g = 0;
  bird.velY = 0;
  stage.tickInt = 0;
}
