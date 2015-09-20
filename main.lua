time = 0

once_u = false
once_d = false
once_r = false
once_l = false

Title = require("Title")
Game = require("Game")
ScoreScreen = require("ScoreScreen")
Menu = require("Menu")

function switchTo(state)
	current:stop()
	current = state
	current:start()
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

--- Linear interpolation between a and b controlled by 0 <= t <= 1.
function lerp(a, b, t)
	return (1-t)*a + t*b
end

function love.load(arg)
	-- compute some globals
	width = love.window.getWidth()
	height = love.window.getHeight()
	
	-- load all the states
	Title:load()
	Menu:load()
	Game:load()
	--Scores:load()
	ScoreScreen:load()
	-- start off in title state
	current = Title
	current:start()
end

function love.update(dt)
	current:update(dt)
end

function love.draw(dt)
	current:draw(dt)
end

function love.keyreleased(key)
	current:keyreleased(key)
end

function love.keypressed(key)

	-- exits
	if key == 'escape' then
		love.event.quit()
	end
end
