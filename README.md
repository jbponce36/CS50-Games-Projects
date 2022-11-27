# Space 50 by jbponce36
## CS50's Introduction to Game Development

Space 50 is a vertical scroll 2D shooting game based off a mix between Space Invaders and a simple bullet hell.  
It features 3 kinds of enemies with different patterns appearing at random waves and a final boss with different attacks.  

## Getting started
From Unity project: Load MainMenuScene.

## Controls
- Arrow keys or WASD keys: Move the player.
- Space bar: Fires. Can be pressed or holded.
- Mouse: Navigation on menues.

## Specifications 

### Game Engine
Unity

### Start-to-finish experience
- Game boots up and shows main menu.
- The player can select whether they want to Play or Exit the game.
- If they choose Play, the main level is loaded and enemies start to spawn.
- When they kill an enemy, a random drop will appear. It can be either a coin, a Bullet powerup or a Follower powerup.
- If the player gets hurt by an enemy or enemy bullet and they don't have any follower active, they lose a life.
- The enemy's movement speeds up a little as time passes.
- The enemy's health also increments a little as time passes.
- The enemy's bullets speed also speeds up as time passes.
- After some time if the player didn't lose, the boss will appear and start shooting different random patterns.
- End goal: Defeating the boss.
- When they kill the boss, the congratulating menu appears and they can choose to play again or to go back to the main menu.
- If they die, the game over menu appears and they can chose to play again or to go back to the main menu.
- They can pause the game anytime when they are playing the main level.

### GameStates
#### MainMenuState
Shows the main menu with the title Space 50 and 2 buttons: Play and Exit.
#### PlayState
The main level of the game where enemies spawn and the boss appears at the end of it.
#### YouWonState
Shows a congratulation message and the score. Also it shows the menu to play again or go back to the main menu.
#### GameOverState
Shows the game over message and the menu to retry the level or go back to the main menu.

### Mechanics
#### Winning
The player wins when they defeat the boss.

#### Losing
- The player loses when they lose all 3 lives.
- They can lose a life if they get hit bit an enemy bullet, or get hit by the enemy itself, if they currently don't have any Follower powerups active. If they do have at least one follower it simply removes one of them and makes the player invulnerable for a little time.
- The player loses a life instantly when they collide with the boss whether they have a follower or not.

#### Scoring
The player adds score when they:
- Pick up a coin.
- Pick up a powerup.
- Defeats an enemy.
- Defeats the boss.

#### Drops and powerups
- The Coin drop adds to the score.
- The Bullet powerup adds another bullet to the player weapon that can be fired simultaneously as the previous ones they had. Player can fire up to 3 bullets simultaneously. They don't lose this powerups unless they die. There are 3 kinds of firing:
    - 1 small bullet
    - 2 small bullets
    - 2 small bullets and a bigger one on the middle
- The Follower powerup adds a little companion that follows the player around them and fires a small bullet whenever the player fires. Player can have up to 3 followers simultaneously. If they get hurt and they have at least one follower it removes one of them.

#### Enemies
##### Common enemies
- Type 1: The tiny one.
    - It shoots a tiny bullet from time to time and moves at middle speed from top to bottom of the screen, and left to right and viceversa. It has little health as well.

- Type 2: The fast one.
    - It flies at a high speed from top to bottom of the screen. It has a medium amount of health.

- Type 3: The heavy one.
    - It behaves like the tiny one but it moves slowly and has a lot more health. It fires a larger bullet from time to time.

##### The boss
It appears after certain time had passed and shoots different kind of bullets and bullet patterns. Patterns change every 8 seconds and fire during 6 seconds each.

- Pattern 1: Shoot forward.
    - It shoots some waves of random bullets forward at random between certain angles.

- Pattern 2: Shoot circle.
    - It shoots a circle of bullets around it several times, alternating between 2 amount of total bullets.

- Pattern 3: Shoot star.
    - Like the circle on but with sort of like a star or flower pattern. Alternates between a 5 point star and a 6 point star pattern.

- Pattern 4 and 5: Shoot spiral and shoot spiral reverse.
    - It shoots a spiral of bullets that spins either clockwise ot counter-clockwise.

##### Enemy bullets
There are 4 kinds of enemy bullets that differ in size, shape and speed. Their speed increments as time passes.

#### Player
The player can move left, right, up and down using the arrows or the WASD keys.  
They can fire once by pressing the space bar or keep firing constantly by holding it down.

##### Player bullets
There are 2 kinds of bullets that differ in size, shape and damage that the player can fire, and 1 type of bullet that the follower companions can shoot that is smaller and damages less.

##### Follower companions
They rotate around the player and fire a small bullet whenever the player fires.  
If the player gets hurt, one of them dissapears.

### Complexity
- Space 50 is a game that takes bits of every other game we've seen in the course but it adds some other functionality as well.
- It also translates some of the mechanics seen in LOVE2D to the Unity engine.
- It starts like the Helicopter Game in its core with the scrolling background and the player that collides with objects and adds to score. But it is translated into 2D.
- The background uses parallax scrolling with 3 layers.
- There are more types of enemies with different behaviours each.
- There is also the boss at the end of the level that adds a definitive way of winning the game.
- There are coins like in Helicopter Game but there are also 2 different powerups with different consequences for the player like in Mario game, either adding another bullet or a follower companion that follows the player and also shoots a bullet.
- Enemy's movement speed, health and their bullet's speed increments as time passes.
- There is also the shooting system that reminds of the Zelda game pot throwing.
- It uses the same scenes as the Dreadhalls game with the addition of the YouWonScene where it congratulates the player for winning and lets them play again. 
- It procedurally generates enemy waves like the pipes in the Flappy Bird game but there are more types of enemies and quantities. It has a pause menu as well.

## Assets

### Sprites
Sprites for the level background, player and enemies spaceships, bullets and powerups where taken from this assets pack from the Unity Assets Store:

Title: Vertical 2D Shooting Assets Pack  
Author: Goldmetal Studio  
URL: https://assetstore.unity.com/packages/2d/characters/vertical-2d-shooting-assets-pack-188719#description  

### Sounds and Music
Title: Sci-Fi Sounds  
Author: Kenney  
URL: https://opengameart.org/content/sci-fi-sounds  
Copyright/Attribution Notice: "www.kenney.nl"  
File(s): sci-fi_sounds.zip  

Title: Interface Sounds  
Author: Kenney  
URL: https://opengameart.org/content/interface-sounds  
Copyright/Attribution Notice: "www.kenney.nl"  
File(s): kenney_interfaceSounds.zip  

Title: Electric Sound Effects Library  
Author: Little Robot Sound Factory  
URL: https://opengameart.org/content/electric-sound-effects-library  
Copyright/Attribution Notice: www.littlerobotsoundfactory.com  
File(s): Electric Sound Library.zip  

Title: Mysterious Calm  
Author: bart  
URL: https://opengameart.org/content/mysterious-calm  
File(s): mysterious_calm.ogg  

Title: Freelance  
Author: maxstack  
URL: https://opengameart.org/content/freelance  
File(s): restoration completed.ogg  

Title: Game over jingles  
Author: Tine S  
URL: https://opengameart.org/content/game-over-jingles  
Copyright/Attribution Notice: Composed by Tine Schenck  
File(s): Game over jingle 4.wav  

### Fonts
Title: Broken Console  
Author: Arterfak Project  
URL: https://fontesk.com/broken-console-font/  

Title: Avenixel  
Author: Gabriel Sammartino  
URL: https://fontesk.com/avenipixel-font/  

Title: Retrograde  
Author: Daler Mukhiddinov  
URL: https://fontesk.com/retrograde-font/  

## Credits
Made by: Julieta Belén Ponce
