--[[
    GD50
    Legend of Zelda

    Author: Julieta Ponce
    jbponce36@gmail.com
]]

PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- lift-pot-left, lift-pot-up, etc
    self.player:changeAnimation('lift-pot-' .. self.player.direction)
end

function PlayerLiftPotState:enter(params)
    self.player.currentAnimation:refresh()
end

function PlayerLiftPotState:update(dt)

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.carryingPot then
        if self.player.currentAnimation.timesPlayed > 0 then
            self.player.currentAnimation.timesPlayed = 0
            self.player:changeState('idle-pot')
        end
    elseif self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
    
    -- check if hitbox collides with any objects in the scene
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.liftHitbox) and object.type == 'pot' and not self.player.carryingPot then 
            -- lift the pot
            -- remove it from the current room and add it to the player
            gSounds['pickup-pot']:play()
            self.player.carryingPot = true
            local pot = object
            self.player.pot = pot
            table.remove(self.dungeon.currentRoom.objects, k)

            -- tween the pot's position from the ground to above the player's head
            Timer.tween(0.2, {
                [self.player.pot] = {x = self.player.x, y = self.player.y - 8}
            })
        end
    end
end

function PlayerLiftPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.liftHitbox.x, self.liftHitbox.y,
    --     self.liftHitbox.width, self.liftHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end