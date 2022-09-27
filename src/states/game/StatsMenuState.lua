--[[
    GD50
    Pokemon

    Author: Julieta Ponce
    jbponce36@gmail.com
]]

StatsMenuState = Class{__includes = BaseState}

function StatsMenuState:init(playerPokemon, HPIncrease, attackIncrease, defenseIncrease, speedIncrease)
    self.playerPokemon = playerPokemon
    
    local HP = self.playerPokemon.HP
    local attack = self.playerPokemon.attack
    local defense = self.playerPokemon.defense
    local speed = self.playerPokemon.speed

    local HPText = 'HP: ' .. tostring(HP) .. ' + ' .. tostring(HPIncrease) .. ' = ' .. tostring(HP + HPIncrease)
    local attackText = 'Attack: ' .. tostring(attack) .. ' + ' .. tostring(attackIncrease) .. ' = ' .. tostring(attack + attackIncrease)
    local defenseText = 'Defense: ' .. tostring(defense) .. ' + ' .. tostring(defenseIncrease) .. ' = ' .. tostring(defense + defenseIncrease)
    local speedText = 'Speed: ' .. tostring(speed) .. ' + ' .. tostring(speedIncrease) .. ' = ' .. tostring(speed + speedIncrease)
    
    self.statsMenu = Menu {
        x = VIRTUAL_WIDTH - 192 - 5,
        y = 5,
        width = 192,
        height = 128,
        cursorOn = false,
        items = {
            {
                text = HPText
            },
            {
                text = attackText
            },
            {
                text = defenseText
            },
            {
                text = speedText
            }
        }
    }
end

function StatsMenuState:update(dt)
    self.statsMenu:update(dt)

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then

        -- pop stats menu
        gStateStack:pop()

        -- fade in and out back to the field automatically
        Timer.after(0.5, function()
            gStateStack:push(FadeInState({
                r = 1, g = 1, b = 1
            }, 1,
            
            -- pop battle state and add a fade to blend in the field
            function()

                -- resume field music
                gSounds['victory-music']:stop()
                gSounds['field-music']:play()

                -- pop battle state
                gStateStack:pop()

                gStateStack:push(FadeOutState({
                    r = 1, g = 1, b = 1
                }, 1, function()
                    -- do nothing after fade out ends
                end))
            end))
        end)
    end
end

function StatsMenuState:render()
    self.statsMenu:render()
end