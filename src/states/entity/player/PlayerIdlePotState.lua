--[[
    GD50
    Legend of Zelda

    Author: Julieta Ponce
    jbponce36@gmail.com
]]

PlayerIdlePotState = Class{__includes = EntityIdleState}

function PlayerIdlePotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
end

function PlayerIdlePotState:enter(params)

    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)

    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdlePotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-pot')
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

    if self.entity.pot then
        -- follow the players position
        self.entity.pot.x = self.entity.x
        self.entity.pot.y = self.entity.y - 8
    end
end