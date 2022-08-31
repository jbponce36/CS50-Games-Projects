--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Julieta Ponce
    jbponce36@gmail.com

    Represents a powerup that spawns randomly, be it on a timer or when the 
    Ball hits a Block enough times, and gradually descends toward the player. 
]]

Powerup = Class{}

function Powerup:init()
    self.x = math.random(0, VIRTUAL_WIDTH - 16)
    self.y =  -16
    
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    self.inPlay = false

    -- variable for keeping track of our velocity on the Y axis
    self.dy = 0

    -- this will effectively be the color of our powerup, and we will index
    -- our table of Quads relating to the global powerup texture using this
    self.skin = 0
end

--[[
    Expects an argument with a bounding box, and returns true if the bounding 
    boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin],
            self.x, self.y)
    end
end