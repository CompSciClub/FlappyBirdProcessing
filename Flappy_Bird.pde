bird flappy;
float g;
int speed;
pipe p;

void setup() {
  size(400,600);
  background(75,200,225);
  g = 0.1;
  speed = 2;
  flappy = new bird(100,290,240,245,55);
  p = new pipe(width);
}

void draw() {
  background(75,200,225);
  p.advance();
  flappy.update();
  flappy.checkCollisions();
  flappy.drawMe();
}

void mousePressed() {
  flappy.flap(); 
}

public class bird {
  int x;
  int y;
  int[] col;
  float velY;
  public bird(int posX,int posY,int rcol,int gcol,int bcol) {
    x = posX;
    y = posY;
    col = new int[]{rcol,gcol,bcol};
  }
  public void drawMe() {
    fill(col[0],col[1],col[2]);
    rect(x,y,20,20);
  }
  public void update() {
    velY = velY + g;
    y += velY;
  }
  public void flap() {
    velY = -30*g;
    y += velY;
  }
  public void checkCollisions() {
    if (y > height-20) {
      y = 580;
      velY = 0;
      g = 0;
      println("Game Over");
    }
    else if (y < 0) {
      y = 0;
      velY = 0;
    }
  }
}

public class pipe {
  int x;
  int change;
  int distance;
  int start;
  int dmin;
  int dmax;
  int smin;
  int smax;
  int wide;
  public pipe(int pos) {
    dmin = 100;
    dmax = 100;
    smin = 100;
    smax = 500;
    wide = 40;
    distance = floor(random(dmin,dmax+1));
    start = floor(random(smin,smax-distance+1));
    println(distance);
    println(start);
    x = pos;
    change = speed;
  }
  public void advance() {
    x -= change;
    fill(0,255,0);
    rect(x,0,wide,start);
    rect(x,start+distance,wide,height-start+distance);
  }
}
