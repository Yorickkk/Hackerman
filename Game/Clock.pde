int secondsCounter = 0;
int secondsLeft = 0;
float speed;           // How fast the Timer dissapears
float lengthTimer;     // How long the Timer has to be

void updateClock()
{
  if (frameCount % 60 == 0)
  {
    secondsCounter++;
  }
  
  if (secondsLeft < 0)
  {
    player.health = 0;
  }
  
  secondsLeft = TIMELEVEL - secondsCounter;
} 

void resetClock()  // reset all values making the clock reset itself
{
  secondsCounter = 0;
  lengthTimer = width;
}

void drawClock()
{
  if (lengthTimer > 0 && !player.done)
  {
    lengthTimer -= speed;
  }
  fill(245, 100, 100);
  rect(0,0,lengthTimer,30);
}
void timerInit()
{
  lengthTimer = width;
  speed = width /(TIMELEVEL * 60);
}