bird flappy;
float g;

void setup() {
  g = 0.1;
  size(400,600);
  background(75,200,225);
  flappy = new bird(100,290,240,245,55);
}

void draw() {
  background(75,200,225);
  flappy.updateMe();
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
  public void updateMe() {
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
      println("Gane Over");
    }
    else if (y < 0) {
      y = 0;
      velY = 0;
    }
  }
}
