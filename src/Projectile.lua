--[[
    GD50
    Legend of Zelda

    Author: Julieta Ponce
    jbponce36@gmail.com
]]

Projectile = Class{}

function Projectile:init(object, throwDirection, initialX, initialY)
    -- it handles objects travelling in a straight line
    self.object = object
    self.throwDirection = throwDirection
    self.initialX = initialX
    self.initialY = initialY
end

function Projectile:update(dt)
    if self.object then
        if self.throwDirection == 'left' then
            -- update object's position
            self.object.x = self.object.x - PLAYER_POT_THROW_SPEED * dt
            -- calculate distance between the initial point were it was thrown and the current position
            local objectTravelX = math.abs(self.initialX - self.object.x)

            -- if it collides with a wall or if it travelled more than 4 tiles, make it disappear
            if self.object.x <= MAP_RENDER_OFFSET_X + TILE_SIZE or
                objectTravelX >= 4 * TILE_SIZE then 
                self.object = nil
                gSounds['pot-break']:play()
            end
        -- same for the other directions
        elseif self.throwDirection == 'right' then
            self.object.x = self.object.x + PLAYER_POT_THROW_SPEED * dt
            local objectTravelX = math.abs(self.initialX - self.object.x)
            
            if self.object.x + self.object.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 or
            objectTravelX >= 4 * TILE_SIZE then
                self.object = nil
                gSounds['pot-break']:play()
            end
        elseif self.throwDirection == 'up' then
            self.object.y = self.object.y - PLAYER_POT_THROW_SPEED * dt
            local objectTravelY = math.abs(self.initialY - self.object.y)
            
            if self.object.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.object.height / 2 or
            objectTravelY >= 4 * TILE_SIZE then 
                self.object = nil
                gSounds['pot-break']:play()
            end
        elseif self.throwDirection == 'down' then
            self.object.y = self.object.y + PLAYER_POT_THROW_SPEED * dt
            local objectTravelY = math.abs(self.initialY - self.object.y)
            
            local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

            if self.object.y + self.object.height >= bottomEdge or
            objectTravelY >= 4 * TILE_SIZE then
                self.object = nil
                gSounds['pot-break']:play()
            end
        end
    end
end

function Projectile:collides(entity)
    if self.object then
        return self.object:collides(entity)
    end
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    if self.object then
        self.object:render(adjacentOffsetX, adjacentOffsetY)
    end
end