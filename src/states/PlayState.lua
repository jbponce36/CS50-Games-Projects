--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    self.recoverPoints = params.recoverPoints

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- table containing all the balls
    self.balls = {}

    -- insert the first ball into the table
    table.insert(self.balls, self.ball)

    -- init new powerup
    self.powerup = Powerup()

    -- timer for powerup spawning
    self.timer = 0
    self.lastPowerupSpawnTime = 5

    -- count bricks hit for powerup spawning
    self.bricksHit = 0
    self.hitsForPowerupSpawning = 10

    -- number of keys that unlocks locked bricks
    self.keys = params.keys

    self.levelHadLockedBricks = gLevelHadLockedBricks
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update timer for powerup spawning
    self.timer = self.timer + dt

    -- if a powerup isn't spawned yet, spawn a new one;
    -- powerup spawns when certain time has passed 
    -- or when the brick hit counter reaches certain amount
    if not self.powerup.inPlay then
        if self.timer > self.lastPowerupSpawnTime or 
            self.bricksHit > self.hitsForPowerupSpawning then

            -- spawn a new powerup with a random y velocity
            self.powerup = Powerup()
            self.powerup.dy = math.random(50, 60)

            -- only spawn key powerup if there still are locked bricks 
            -- and the player does not have enough keys for them already
            if gLockedBricks > 0 and gLockedBricks > self.keys then
                -- spawn a key powerup with 50 per cent chance
                local chanceForKeyPowerup = math.random(0, 1)
                if chanceForKeyPowerup == 1 then
                    self.powerup.skin = 10
                else
                    self.powerup.skin = 9
                end
            else
                self.powerup.skin = 9
            end
            
            self.powerup.inPlay = true
            
            -- reset timer and counter
            self.timer = 0
            self.bricksHit = 0

            -- set a random time between 5 and 15 seconds for powerup spawning
            self.lastPowerupSpawnTime = math.random(5, 15)
        end
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    
    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end

    -- update powerup position and detect collision with paddle, if there is any powerup
    if self.powerup.inPlay then
        self.powerup:update(dt)

        -- if powerup goes below the screen, disable it
        if self.powerup.y >= VIRTUAL_HEIGHT then
            self.powerup.inPlay = false
        end
        
        -- player picks up the powerup
        if self.powerup:collides(self.paddle) then
            self.powerup.inPlay = false

            if self.powerup.skin == 9 then
                -- add two more balls
                for i = 1, 2 do
                    newBall = Ball()
                    newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
                    newBall.y = self.paddle.y - 8
                    newBall.dx = math.random(-200, 200)
                    newBall.dy = math.random(-50, -60)
                    newBall.skin = math.random(7)

                    table.insert(self.balls, newBall)
                end
            else
                -- pick up the key
                self.keys = self.keys + 1
            end

            gSounds['confirm']:play()
        end
    end

    for k, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end

    -- detect collision across all bricks with all the balls
    for k, brick in pairs(self.bricks) do

        for i, ball in pairs(self.balls) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- if it is a locked brick
                if brick.color == 6 then
                    if self.keys > 0 then
                        -- add 1000 to score
                        self.score = self.score + 1000
                        -- trigger the brick's hit function, which removes it from play
                        brick:hit()
                        self.keys = self.keys - 1
                        gLockedBricks = gLockedBricks - 1
                    else
                        gSounds['wall-hit']:play()
                    end
                else
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()
                end

                -- count the bricks hit for powerup spawning
                self.bricksHit = self.bricksHit + 1 

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                    -- grow the paddle if it's not the biggest size already
                    if self.paddle.size < 4 then 
                        self.paddle.size = self.paddle.size + 1
                        self.paddle.width = self.paddle.width + 32            
                    end

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        recoverPoints = self.recoverPoints,
                        keys = self.keys
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    for k, ball in pairs(self.balls) do
        if ball.y >= VIRTUAL_HEIGHT then
            if #self.balls == 1 then
                self.health = self.health - 1
                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    -- shrink the paddle if it's not the smallest size already
                    if self.paddle.size > 1 then 
                        self.paddle.size = self.paddle.size - 1
                        self.paddle.width = self.paddle.width - 32            
                    end

                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints,
                        keys = self.keys
                    })
                end
            else
                table.remove(self.balls, k)
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- display keys counter, only if level had locked bricks
    if self.levelHadLockedBricks then
        displayKeys(self.keys)
    end

    -- render powerup, if there is any
    self.powerup:render()

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end