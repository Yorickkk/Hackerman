/*
  DON'T CHANGE ANYTHING IN PLAYER, I AM WORKING ON COLLISION AT THE MOMENT -Yorick
 */
class Player
{
  final int originalHealth = 100;
        int health = originalHealth;
  public color healthColour = color(255,104,225);
  boolean hit = false;
  
  float reqX, reqY;
  float mainX, mainY, mainW, mainH;
  float xRemainderToWall, yRemainderToWall = 0.0;
  float playerWidth = mainW - mainX;
  float playerHeight = mainH - mainY;
  float playerArea = (playerWidth / playerHeight);
  float xsp, ysp = 0;
  public float speed = 10;
  float originalSpeed = speed;
  float angle = 0;
  boolean done = false;
  boolean beatGame = false;
  boolean collidesWithWall, xCollision, yCollision = false;
  boolean u, d, l, r = false;
  float otherX, otherY, otherW, otherH = 0.0;
  color colour = color(0, 0, 255);
  float[][] restCoords = {{0.0}};

  float setSpeed()
  {
    return (playerArea);
  }

  void draw()
  {
    /*if     (hit)  colour = color(255,0,0);
    else if(done) colour = color(0,255,0);
    else          colour = color(0,0,255);*/
    
    fill(colour);
    rect(mainX, mainY, mainW, mainH);   //draw the main block
    for (float[] c : restCoords)
    {
      if (!isEmpty(c))
      {
        fill(colour);
        rect(c[0], c[1], c[2], c[3]);   //draw the other blocks
      }
    }
    

    if (checkDone()) done = true;     //check if puzzle is completed
    else colour = color(0,0,255);
  }

  void update()
  {
    if(health <= 0)  //death sequence
    {
      clearCoordinates();
      fill(255,0,0);
      textAlign(CENTER);
      textSize(48); text("You got Hacked.",width/2,height/2);
      
      gameRestartTimer++;
      if(gameRestartTimer >= gameRestartTimeAmount)
      {
        restartGame();
        gameRestartTimer = 0;
      }
    }
    else            //sequence for player is alive
    {
      xsp *= 0.4;
      ysp *= 0.4;
  
      if (keysPressed[LEFT])   xsp = -1;
      if (keysPressed[RIGHT])  xsp = 1;
      if (keysPressed[UP])     ysp = -1;
      if (keysPressed[DOWN])   ysp = 1;
  
      if (keysPressed[SHIFT])
      {
        
      }
  
      if (! nextPositionIsWall() ) //if next position is free
      {
        mainX += xsp * speed;      //move us in the direction(xsp), with the speed (speed)
        mainY += ysp * speed;
      }
      else//if next position is a wall
      {   //and if we're not directly touching the wall (more than 1 pixel difference)
      
        if (mainX-1 <= otherX + otherW)
        {} else mainX += xsp;     //move us 1 pixel to the right
        
        if (mainX+mainW+1 >= otherX)
        {} else mainX -= xsp;     //move us 1 pixel to the left
        
        if (mainY-1 <= otherY + otherH)
        {} else mainY += ysp;     //1 pixel down
        
        if (mainY+mainH+1 >= otherY)
        {} else mainY -= ysp;     //1 pixel up
      }
      mainX = constrain(mainX, 0, width-mainW);      //stay in the screen x wise
      mainY = constrain(mainY, 0, height-mainH);     //y wise
    }
  }

  boolean nextPositionIsWall()
  {
    float nextXposition = mainX + (xsp * speed);          //position player attempts to move in
    float nextYposition = mainY + (ysp * speed);

    for (float[] c : wallCoords)
    {
      otherX = c[0];
      otherY = c[1];
      otherW = c[2];
      otherH = c[3];

      if (nextXposition <= otherX + otherW    &&                //there's a wall to the left
          nextXposition + mainW >= otherX     &&                //to the right
          nextYposition <= otherY + otherH    &&                //above player
          nextYposition + mainH >= otherY)    return true;      //below player
    }
    return false; //no wall where we want to move!
  }

  boolean checkDone()
  {
    if (mainX <= reqX + puzzleDoneMargin &&
        mainX >= reqX - puzzleDoneMargin &&
        mainY <= reqY + puzzleDoneMargin &&
        mainY >= reqY - puzzleDoneMargin)
        {
          mainX = reqX;
          mainY = reqY;
          return true;
        }
    else  return false; 
  }
}