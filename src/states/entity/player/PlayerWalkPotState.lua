--[[
    GD50
    Legend of Zelda

    Author: Julieta Ponce
    jbponce36@gmail.com
]]

PlayerWalkPotState = Class{__includes = EntityWalkState}

function PlayerWalkPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkPotState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-pot-down')
    else
        self.entity:changeState('idle-pot')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- throw the pot
        -- now the pot is in the current room as a projectile and not on the player
        self.entity.carryingPot = false
        local pot = Projectile(self.entity.pot, self.entity.direction, self.entity.pot.x, self.entity.pot.y)
        table.insert(self.dungeon.currentRoom.potsThrowed, pot)
        self.entity.pot = nil
        self.entity:changeState('walk')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)


    if self.entity.pot then
        -- follow the players position
        self.entity.pot.x = self.entity.x
        self.entity.pot.y = self.entity.y - 8
    end
end