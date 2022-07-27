--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local goldMedalImage = love.graphics.newImage('gold.png')
local silverMedalImage = love.graphics.newImage('silver.png')
local bronzeMedalImage = love.graphics.newImage('bronze.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
	
	-- render the corresponding medal image to the middle of the screen
		-- If score is higher than 5, we get a gold medal
		-- If score is between 4 and 3, we get a silver medal
		-- If score is between 2 and 1, we get a bronze medal
		-- If score is 0, we don't get any medal
	if self.score >= 5 then
		love.graphics.draw(goldMedalImage, VIRTUAL_WIDTH / 2 - goldMedalImage:getWidth() / 2, 
			VIRTUAL_HEIGHT / 2 - goldMedalImage:getHeight() / 2)
	elseif self.score >= 3 then
		love.graphics.draw(silverMedalImage, VIRTUAL_WIDTH / 2 - silverMedalImage:getWidth() / 2, 
			VIRTUAL_HEIGHT / 2 - silverMedalImage:getHeight() / 2)
	elseif self.score >= 1 then
		love.graphics.draw(bronzeMedalImage, VIRTUAL_WIDTH / 2 - bronzeMedalImage:getWidth() / 2, 
			VIRTUAL_HEIGHT / 2 - bronzeMedalImage:getHeight() / 2)
	end

	--if we get a medal, render the text lower to make space for the image
	if self.score >= 1 then
		love.graphics.printf('Press Enter to Play Again!', 0, 180, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
	end
end