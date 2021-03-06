void loadLevel(int num) //)
{
  String fileName = "data/"+num+"/lvl_"+num;
  File directory = new File(dataPath(""+num));
  //remove all data from previous level
  clearCoordinates();
  resetClock();
  worms     .clear();
  adwares   .clear();
  vira      .clear();
  ads       .clear();
  packages  .clear();
  player.hit = false;

  if (directory.exists())
  {
    int restBlocks = 0;
    int puzzleBlocks = 0;
    int wallBlocks = 0;
    int enemyAmount = 0;

    String varsPlayer [] = {};
    String varsPuzzle [] = {};
    String varsWalls  [] = {};
    String varsEnemies[] = {};

    varsPlayer   =  loadStrings(fileName+"_player.txt");
    varsPuzzle   =  loadStrings(fileName+"_puzzle.txt");
    varsWalls    =  loadStrings(fileName+"_walls.txt");
    varsEnemies  =  loadStrings(fileName+"_enemies.txt");

    float[][] restCoords = new float[8][4];

    player.reqX = Float.parseFloat(varsPlayer[0]);
    player.reqY = Float.parseFloat(varsPlayer[1]);

    player.mainX = Float.parseFloat(varsPlayer[2]);
    player.mainY = Float.parseFloat(varsPlayer[3]);
    player.mainW = Float.parseFloat(varsPlayer[4]);
    player.mainH = Float.parseFloat(varsPlayer[5]);

    // get remaining player coordinates from player variables array (was 38)
    for (int i = 6; i < varsPlayer.length; i+=4)
    {
      try
      {
        float x = Float.parseFloat(varsPlayer[i]);
        //print(x);
        float y = Float.parseFloat(varsPlayer[i+1]);
        float w = Float.parseFloat(varsPlayer[i+2]);
        float h = Float.parseFloat(varsPlayer[i+3]);
        float[] coords = {x, y, w, h};
        if (!isEmpty(coords))
        {
          restCoords[restBlocks] = coords;
          restBlocks++;
          //coords[listIndex] = Float.parseFloat(vars[i]);
        }
      }
      catch(ArrayIndexOutOfBoundsException e)
      {
        break;
      }
    }
    player.restCoords = restCoords;

    //get puzzle blocks from puzzle variable array
    for (int j = 0; j < varsPuzzle.length; j+=4)
    {
      float blockX = Float.parseFloat(varsPuzzle[j]);
      float blockY = Float.parseFloat(varsPuzzle[j+1]);
      float blockW = Float.parseFloat(varsPuzzle[j+2]);
      float blockH = Float.parseFloat(varsPuzzle[j+3]);
      float[] blockCoords = {blockX, blockY, blockW, blockH};
      if (!isEmpty(blockCoords))
      {
        puzzleCoords[puzzleBlocks] = blockCoords;
        puzzleBlocks++;
      }
    }

    //get wall blocks from wall variable array
    for (int k = 0; k < varsWalls.length; k+=4)
    {
      float wallX = Float.parseFloat(varsWalls[k]);
      float wallY = Float.parseFloat(varsWalls[k+1]);
      float wallW = Float.parseFloat(varsWalls[k+2]);
      float wallH = Float.parseFloat(varsWalls[k+3]);
      float[] wallStats = {wallX, wallY, wallW, wallH};
      if (!isEmpty(wallStats))
      {
        wallCoords[wallBlocks] = wallStats;
        wallBlocks++;
      }
    }
    if(num % 5 == 0)
    {
      HealthPickup healthPickup = new HealthPickup();
      healthPickups.add(healthPickup);
    }
    else
    {
      healthPickups.clear();
    }
    for (int l = 0; l < varsEnemies.length; l+=2)
    {
      int enemyX = (int)Float.parseFloat(varsEnemies[l]);
      int enemyY = (int)Float.parseFloat(varsEnemies[l+1]);
      int amountOfEnemies = 3;
      float[] enemyStats = {enemyX, enemyY};

      if (!isEmpty(enemyStats))
      {
        int range = (amountOfEnemies - 0) + 1;
        int enemyType = (int)(Math.random() * range) + 0;

        switch(enemyType)  //spawn an enemy
        {
        case 0:
          Worm newWorm = new Worm(enemyX, enemyY);
          worms.add(newWorm);
          break;

        case 1:
          EnemyAdware newAdware = new EnemyAdware(enemyX, enemyY);
          adwares.add(newAdware);
          break;

        case 2:
          Virus newDOT = new Virus(enemyX, enemyY);
          vira.add(newDOT);
          break;  

        case 3:
          Malware newMalware = new Malware(enemyX, enemyY);
          malwares.add(newMalware);
        }
        enemyAmount++;
      }
    }

    player.done = false;
    score.calculatedThisLevel = false;
    savedBestScoresThisLevel  = false;
    levelNumber++;
    levelTotal++;
  } else
  {
    //do nothing, as the next level doesn't exist
  }
}

void restartGame()
{
  //restart the game
  //leaderboard.lastFiveScores[score.numberOfScores] = score.totalScore;
  //recentScoresWriter = createWriter(bestScoresEver);
  for (int i = 0; i < 5; i++)
  {
    float everyScore = leaderboard.bestFiveScores[i];
    if (score.totalScore > everyScore)
    {
      for (int j=4; j>=max(i, 1); j--)
      {
        leaderboard.bestFiveScores[j] = leaderboard.bestFiveScores[j-1];
      }
      leaderboard.bestFiveScores[i] = score.totalScore;
      break;
    }
  }

  //recentScoresWriter.close();
  levelNumber = 1;
  loadLevel(levelNumber);
  player.beatGame = false;
  player.done = false;
  player.health = player.originalHealth;
  resetClock();
  score.totalScore = 0;
  gamestart.play();
  mainsong.loop();
}

void saveBestScores()
{
  PrintWriter recentScoresWriter = createWriter("data/best_5_scores.txt");
  for (float currentScore : leaderboard.bestFiveScores)
  {
    recentScoresWriter.println(currentScore);    //NPE
  }
  recentScoresWriter.flush();
  recentScoresWriter.close();
  savedBestScoresThisLevel = true;
}

void loadAllImages()
{
  entryScreen        = loadImage("start_screen.png");
  deathScreen        = loadImage("deathScreen.jpg");
  wallSpritesheet    = loadImage("wall_texture.jpg");
  leaderboardImage   = loadImage("leaderboard_image.jpg");
  scoreAdditionImage = loadImage("score_addition.png");
  playerInjuredSprite= loadImage("damagesprite.png");
  puzzleDoneSprite   = loadImage("donesprite.png");
  playerSpriteNormal = loadImage("sprite_player.png");
  playerSpriteDone   = loadImage("playersprite_done.png");
  wormSprite         = loadImage("worm.png");
  adwareSprite       = loadImage("adwareSprite.png");
  virusSprite        = loadImage("virusSprite.png");
  malwareSprite      = loadImage("malwareSpriteSheet.png");
  Packagespritesheet = loadImage("Packagespritesheet.png");
  puzzleSpritesheet  = loadImage("sprite_puzzel.png");
  DoTcom             = loadImage("DoTcom.png");
  healthPickupSprite = loadImage("healthSprite.png");
  healthFeedback     = loadImage("healthFeedback.png");
  
  adwareSprites = new PImage[EnemyAdware.amountOfAds];    //amountOfAds is a static member of EnemyAdware, so we can refer to the class name
  for(int i = 0; i < EnemyAdware.amountOfAds; i++)
  {
    adwareSprites[i] = loadImage("adware_images/ad"+(i+1)+".jpg");
  }
}

void loadAllSounds()
{
  damage = new SoundFile(this, "damage.mp3");
  adware = new SoundFile(this, "adware.mp3");
  gameover = new SoundFile(this, "gameover.mp3");
  gamequit = new SoundFile(this, "gamequit.mp3");  
  gamestart = new SoundFile(this, "gamestart.mp3");  
  menu = new SoundFile(this, "menu.mp3");
  mainsong = new SoundFile(this, "mainsong.wav");
  wallbump = new SoundFile(this, "wallbump.mp3");
  infected = new SoundFile(this, "infected.mp3");
  leveldone = new SoundFile(this, "leveldone.mp3");
  
  //allSounds.add(damage); allSounds.add(adware); allSounds.add(gameover); allSounds.add(gamequit); allSounds.add(gamestart); allSounds.add(menu); allSounds.add(wallbump); allSounds.add(infected); allSounds.add(leveldone);
 }

void clearCoordinates()
{
  player.mainX = 0;
  player.mainY = 0;
  player.mainW = 0;
  player.mainH = 0;
  stretchCounter = 0;
  blockCounter = 0;
  //easeCounter = 0;
  for(float[] c : wallCoords)
  {
     c[0] = 0.0; c[1]= 0.0; c[2] = 0.0; c[3]= 0.0;
  }
  for(float[] c : puzzleCoords)
  {
     c[0] = 0.0; c[1]= 0.0; c[2] = 0.0; c[3]= 0.0;
  }
  for(float[] c : enemyCoords)
  {
    c[0] = 0.0; c[1] = 0.0;
  }
  worms       .clear();
  adwares     .clear();
  vira        .clear();
  packages    .clear();
  malwares    .clear();
  
  //for (SoundFile everySound : allSounds)
 // {
 //   everySound.stop();
  //}
  playingMenu = false;
  playingLevelDone = false;
  playingGameOver = false;
}