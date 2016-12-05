class Worm
{
  float x, y;
  float moveSpeed = 3;
  int dir = RIGHT;
  float nextXposition, nextYposition = 0;

  int segments = 1;
  int segmentSize = 5;
  float headSize = segmentSize * 1.3;
  int maxSegments = 100;
  float size;                        //placeholder variable for black magic

  int segmentationTime = 5;         //every segmentationTime amount of frames, a new segment is added (the worm grows bigger)
  int segmentCounter = 0;            //count every frame for duplication purposes
  int damage = 1;

  public Worm(int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  void draw()
  {
    for (int i = 0; i < segments; i++)
    {
      if (i==0)        fill(color(240, 0, 240));           //make the head (first segment) a unique colour
      else                                          
      {  
        if (i%2==0)   fill(color(244, 164, 96));    
        else          fill(color(205, 133, 63));          //segments are alternated between 2 colours
      }

      size = (i == 0) ? headSize : segmentSize;           //draw the head bigger


      if (dir == LEFT)  ellipse(x + (i*segmentSize), y, size, size);  //draw additional segments to the right of the head
      if (dir == RIGHT) ellipse(x - (i*segmentSize), y, size, size);  //draw additional segments to the left of the head
      if (dir == DOWN)  ellipse(x, y + (i*segmentSize), size, size);
      if (dir == UP)    ellipse(x, y - (i*segmentSize), size, size);
    }
  }

  void update()
  {
    damagePlayer(x, y, damage);

    segmentCounter++;
    if (segments <= maxSegments)
    {
      if (segmentCounter > segmentationTime)
      {
        segments++;
        segmentCounter = 0;
      }
    } else segmentCounter = 0;



    if (bounceOffWall(x, y) || bounceOffScreenEdge())//if (hitsWall())
    {
      segments = 3;
      if (bounceOffWall(x, y))
      {
        if (dir == LEFT) dir = RIGHT;
        else if (dir == RIGHT) dir = LEFT;
      }
    }

    switch(dir)
    {
    case LEFT:                  //move left
      x -= moveSpeed; 
      break;
    case RIGHT:                 //move right
      x += moveSpeed; 
      break;  
    case DOWN:
      y -= moveSpeed; 
      break;
    case UP:
      y += moveSpeed; 
      break;
    default:
      break;
    }
  }

  boolean bounceOffScreenEdge()
  {
    if (x+segmentSize > width)
    {
      dir = LEFT;
      return true;
    }
    if (x-segmentSize < 0)
    {
      dir = RIGHT;
      return true;
    }
    if (y+segmentSize > height)
    {
      dir = DOWN;
      return true;
    }
    if (y-segmentSize < 0)
    {
      dir = UP;
      return true;
    }
    return false;
  }
}
/*
//////////////////////////////////////////////
 end of worm class
 //////////////////////////////////////////////
 //////////////////////////////////////////////
 //////////////////////////////////////////////
 begin of adware class
 //////////////////////////////////////////////
 */

class EnemyAdware
{
  float x = 10;
  float y = 10;
  float w = 20;
  float h = 20;
  int amountOfAds = 1000;
  float speed = 20;
  float xsp = speed; 
  float ysp = speed;
  int damage = 0;
  float originalSpeed = speed;

  color colour = color(70, 215, 240);
  PImage img; //image loader
  int imgNum = 1;

  public EnemyAdware (int x, int y)
  {
    this.x = x;
    this.y = y;
  }

  void stayInScreen()
  {
    if (x > width - w)    xsp = -speed;
    if (x < 0)            xsp = speed;
    if (y > height - h)   ysp = -speed;
    if (y < 0)            ysp = speed;
  }



  void update()
  {
    stayInScreen();
    if (bounceOffWall(x, y))
    {
      if (xsp < 0) xsp = speed; 
      else xsp = -speed;
      if (ysp < 0) ysp = speed; 
      else ysp = -speed;
    }
    x += xsp;
    y += ysp;

    if (damagePlayer(x, y, damage))
    {
      burstAdware();
    }
  }

  void burstAdware()
  {
    speed = 0;
    player.speed = 0;
    for (int i = 0; i < 10; i++)
    {
      PopUpRandomizer(imgNum);
    }
    speed = originalSpeed;
    player.speed = player.originalSpeed;
  }

  void PopUpRandomizer(int num) //spawns x, y and image
  {
    float popUpx = random(750);
    float popUpy = random(400);

    img = loadImage("Ad"+num+".png");
    image(img, popUpx, popUpy);
  }

  void draw()
  {
    fill(colour);                                                  //stroke(255, 100, 0);
    rect(x, y, w, h);
  }
}


class EnemyDOT
{
  float x, y;
  float vx, vy;
  float diameter = 45;

  color fillColor = color(255, 0, 0);
  int teller = 0;
  float draw = 0;
  int amountOfPackages = 0;
  int damage = 3;

  public EnemyDOT(float x, float y)
  {
    this.x = x;
    this.y = y;

    vx = random(-3.0, 3.0);
    vy = random(-3.0, 3.0);
  }

  void update()
  {    

    //if(overlapsPlayer(x,y)) player.health -= 1;
    x += vx;
    y += vy;

    //bounce off screen edge
    if ((x > width-diameter/2) || (x < diameter/2)) vx = -vx;
    if ((y > height-diameter/2) || (y < diameter/2)) vy = -vy;
    teller++;  

    if (teller >= 150 && amountOfPackages!=5)
    {
      amountOfPackages++;

      Package newPackage = new Package();    //make a new package
      newPackage.init(x, y);                 //spawn it under ourselves
      packages.add(newPackage);              //add it to the arraylist


      teller = 0;                            //wait teller amount of frames before repeating
    }
  }

  void draw() 
  {
    fill(fillColor);
    ellipse(x, y, diameter, diameter);
  }
}

class Package
{
  float vx, vy;
  float x, y;
  float diameter;
  color fillColor;
  int teller = 0;
  int damage = 3;
  int infectCounter = 0;
  boolean infected = false;
  int infectTime = 35;

  void init(float x, float y)
  {
    // The size of an enemy varies
    diameter = 20;
    fillColor = color(255, 255, 255);
    this.x = x;
    this.y = y;
  }
  void draw()
  {
    fill(fillColor);
    rect(x, y, diameter, diameter);
  }
  void update()
  {
    damagePlayer(x, y, damage);

    if (overlapsPlayer(x, y)) infected = true;
    damagePlayerDoT(x, y, damage);
  }

  boolean damagePlayerDoT(float x, float y, float damage)
  {
    /*
    if(overlapsPlayer(x,y))
     {
     for(int i=0; i<1; i++)
     {
     player.health -= 0.3;
     }
     return true;
     }*/
    if (infected)
    {
      infectCounter++;
      if (infectCounter >= infectTime) infected = false;
      player.health -= damage;
    }
    return false;
  }
}

class Malware

{

  int breedte = 20;
  int hoogte = 20;
  float x;
  float y;
  color colour = color(125, 125, 0);
  int speed = 8;
  boolean alive = true;

  public Malware(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  void draw()
  {
    fill(colour);
    ellipse(x, y, breedte, hoogte);
  }
  
  void update()
  {
    move();
    collision();
  }

  void move() 
  {

    float xDistance = x - player.mainX;                      //black magic
    float yDistance = y - player.mainY;

    if (Math.abs(xDistance) <= 300 && Math.abs(yDistance) <= 300)
    {
      double hyp = Math.sqrt(xDistance * xDistance + yDistance * yDistance);
      xDistance /= hyp;
      yDistance /= hyp;
      x += (xDistance * -speed);
      y += (yDistance * -speed);
    }
  }

  void collision() 
  {
    if (overlapsPlayer(x,y)) 
    {
      alive = false;
    }
  }
}