time = 0

once_u = false
once_d = false
once_r = false
once_l = false

highscores = {}
default_scores = "\n5000\n4000\n3000\n2000\n1000"

Title = require("Title")
Game = require("Game")
ScoreScreen = require("ScoreScreen")
Menu = require("Menu")
Studio = require("Studio")

function switchTo(state)
	current:stop()
	current = state
	current:start()
end

--- Center small inside large.
function center(large, small)
	return large/2 - small/2
end

--- Interpolation between a and b controlled by 0 <= t <= 1.
function lerp(a, b, t)
	return ((1-t)^5)*a + (t^5)*b
end

function love.load(arg)

	--load highscore list
	if not love.filesystem.exists("scores") then
		love.filesystem.write("scores", default_scores)
	end
	for line in love.filesystem.lines("scores") do
		table.insert(highscores, line)
	end
	table.remove(highscores, 1)
	
	-- compute some globals
	width = love.window.getWidth()
	height = love.window.getHeight()
	
	-- load all the states
	Studio:load()
	Title:load()
	Menu:load()
	Game:load()
	ScoreScreen:load()

	--set current state
	current = Studio
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

function love.quit()
	love.filesystem.write("scores", "")
	
	for rank, hs in ipairs(highscores) do
		love.filesystem.append("scores", "\n" .. hs)
	end
end
