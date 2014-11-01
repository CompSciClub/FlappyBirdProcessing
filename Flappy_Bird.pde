bird flappy;
float g;
int speed;
stage level;
boolean running;
int pipeWidth;
boolean collision;

void setup() {
  size(400,600);
  background(75,200,225);
  g = 0.1;
  speed = 2;
  pipeWidth = 40;
  flappy = new bird(100,290,240,245,55);
  level = new stage();
  running = false;
  collision = false;
}

void draw() {
  background(75,200,225);
  flappy.drawMe(); 
  if (running != false) {
    level.advance(); //should the level advance or the bird move first?
    flappy.update();
    level.checkCollisions(flappy);
    level.removeOldPipes();
  }
  if (collision == true) {
    gameOver(level,flappy); 
  }
}

void mousePressed() {
  if (running) {
    flappy.flap();
  }
  else {
    running = true; 
  } 
}

void gameOver(stage stage, bird bird) {
  speed = 0;
  g = 0;
  bird.velY = 0;
  stage.tickInt = 0;
}

public class bird {
  int x;
  int y;
  int[] col;
  float velY;
  int birdWidth;
  int birdHeight;
  public bird(int posX,int posY,int rcol,int gcol,int bcol) {
    x = posX;
    y = posY;
    birdWidth = 20;
    birdHeight = 20;
    col = new int[]{rcol,gcol,bcol};
  }
  public void drawMe() {
    fill(col[0],col[1],col[2]);
    rect(x,y,birdWidth,birdHeight);
  }
  public void update() {
    velY = velY + g;
    y += velY;
  }
  public void flap() {
    velY = -30*g;
    y += velY;
  }
}

public class pipe {
  int x;
  int distance;
  int start;
  int dmin;
  int dmax;
  int smin;
  int smax;
  public pipe(int pos) {
    dmin = 100;
    dmax = 100;
    smin = 100;
    smax = 500;
    distance = floor(random(dmin,dmax+1));
    start = floor(random(smin,smax-distance+1));
    x = pos;
  }
  public void drawMe() {
    fill(0,255,0);
    rect(x,0,pipeWidth,start);
    rect(x,start+distance,pipeWidth,height-start+distance); 
  }
  public void update() {
    x -= speed;
  }
  //checks collision with a point x,y
  public void checkCollision(int birdX,int birdY) {
    if (birdX >= x && birdX <= x+pipeWidth) {
      //top part
      if (birdY >= 0 && birdY <= start) {
        collision = true; 
      }
      //bottom part
      if (birdY >= start+distance && birdY <= height) {
        collision = true; 
      }
    }
  }
}

public class stage {
  int tick;
  int tickInt;
  int tickLimit;
  ArrayList<pipe> pipeList = new ArrayList<pipe>();
  public stage() {
    tick = 0;
    tickLimit = speed*50;
  }
  public void advance() {
    if (tick >= tickLimit || tick == 0) {
      tick = 0;
      tickInt = 1;
      pipeList.add(new pipe(width));
    }
    tick += tickInt;
    for (int i=0; i<pipeList.size(); i++) {
      pipe test = pipeList.get(i);
      test.update();
      test.drawMe();
      
    }
  }
  public void removeOldPipes() {
    for (int i=0; i<pipeList.size(); i++) {
        pipe test = pipeList.get(i);
        if (test.x <= 0-pipeWidth) {
          pipeList.remove(test); 
        }
     }
  }
  public void checkCollisions(bird bird) {
    if (bird.y > height-20) {
      bird.y = 580;
      bird.velY = 0;
      gameOver(this, bird);
    }
    if (bird.y < 0) {
      bird.y = 0;
      bird.velY = 0;
    }
    //huge collision check algorithm
    //for each pipe check collision
    for (int i=0; i<pipeList.size(); i++) {
        pipe test = pipeList.get(i);
        //top surface of bird
        for (int m=bird.x; m<=bird.x+bird.birdWidth; m++) {
          test.checkCollision(m,bird.y);
        }
        //bottom surface of bird
        for (int m=bird.x; m<=bird.x+bird.birdWidth; m++) {
          test.checkCollision(m,bird.y+bird.birdHeight);
        }
     }
  }
}
