/*space for writing general comments on the code

every resource involving numbers (score, time, health etc.) should be float, but drawn as int.
this gives us more control over handling these numbers, as we can be more precise due to the nature of float
drawing the numbers as int is important as this removes the fraction floats have, which is ugly on screen

basic program flow
  
  *just once:
    *initialize things like score, leaderboard and timer
  
  *loop indefinitely
    *load level at the index, levels have player, enemies, wall information
    *loop until player has completed level
      *update player depending on input
      *update enemies depending on behaviour
      *draw everything in the room
      *if player coordinates match with done requirement coordinates, break loop
    *increment level index, wrap around if nonexistent


*/
import java.util.Objects;
import java.util.Arrays;
import java.io.File;
import java.lang.Math;

int slowMove = 0;
int stall    = 0;
boolean done = false;
int nEnemies = 5;
float t      = 0.0; 
int health   = 100;
boolean showStartScreen = true;
boolean savedBestScoresThisLevel = false;
int levelNumber = 1;


int drawbackground = 0;
color HUDcolour = color(255, 201, 14);
color red   = color(255, 0, 0);
color green = color(0, 255, 0);
color blue  = color(0, 0, 255);

ArrayList<EnemyDOT>    DOTenemies = new ArrayList<EnemyDOT>();
ArrayList<Package>     packages   = new ArrayList<Package>();
ArrayList<EnemyAdware> adwares    = new ArrayList<EnemyAdware>();
ArrayList<Worm>        worms      = new ArrayList<Worm>();
ArrayList<Malware>     malwares   = new ArrayList<Malware>();
ArrayList<Ad>          ads        = new ArrayList<Ad>();

Player player = new Player();                  //a player object, for all rectangles the player controls
Score score = new Score();
Leaderboard leaderboard = new Leaderboard();

float[][] wallCoords   = new float[30][4];     //a 30 slot 2d array, each subarray having 4 slots. this is for the maximum of 30 wall blocks
float[][] puzzleCoords = new float[20][4];     //a 20 slot 2d array, each subarray having 4 slots. this is for the maximum of 20 puzzle blocks
float[][] enemyCoords  = new float[12][2];     //12 enemies of which x and y are known
//int[] lastFiveScores = {0, 0, 0, 0, 0};


//game constants
final int PUZZLEDONEMARGIN       = 40;                
final int AMOUNTOFLEVELS         = 6;
final int LEVELWAIT              = 150;
final int TIMELEVEL              = 10;


PImage entryScreen; 
PImage deathScreen;
PImage wallSprite;
PImage leaderboardImage;
PImage scoreAdditionImage;
PImage wallSpritesheet;
PImage damageSprite;

File bestScoresEver = new File("best_5_scores.txt");

void setup()
{
  size(1250, 702);
  //size(1280, 720);
  //surface.setResizable(true);
  //bestScoresEver = new File("data/best_5_scores.txt");
  leaderboard.loadBestScores();
  entryScreen        = loadImage("start_screen.png");
  deathScreen        = loadImage("death_screen.png");
  wallSpritesheet    = loadImage("wall_texture.png");
  leaderboardImage   = loadImage("leaderboard_image.png");
  scoreAdditionImage = loadImage("score_addition.png");
  damageSprite       = loadImage("damagesprite.png");

  loadLevel(levelNumber);

  Worm xnx = new Worm(width-50, 100);
  worms.add(xnx);
}

void draw()
{
  runGame();
}

void drawHUD()
{
  textAlign(LEFT);
  textSize(32);

  //color timeLeftColour = color((int) random(155,255));          //random colour between 155 and 255 RGB
  leaderboard.draw();
  fill(255);
  textSize(24);
  text(secondsLeft, player.mainX-5, player.mainY-5);

  textSize(24);
  fill(red);
  textAlign(LEFT);
  imageMode(CORNER);
  if (!player.done)
  {
    int leaderboardX = leaderboard.x;
    //image(scoreAdditionImage,leaderboard.x-275,0 , leaderboard.x-425, 300);
    text("Score : " + (int)score.totalScore, leaderboard.x-175, leaderboard.padding);
  }
  else 
  {
    imageMode(CENTER);
    textAlign(LEFT);
    textSize(48);
    fill(red);
    image(scoreAdditionImage, width/2, height/2);

    text((int)score.oldScore, 678, 228);
    text((int)score.timePoints, 678, 304);
    text((int)score.scorePoints, 678, 382);

    float newScore = (int) score.berekenScore();
    textSize(64);
    text((int)score.berekenScore(), 540, 490);
  }

  fill(player.healthColour);
  textSize(32);
  textAlign(CENTER);
  text((int)player.health, player.mainX+(player.mainW/2), player.mainY+(player.mainH/2));
}