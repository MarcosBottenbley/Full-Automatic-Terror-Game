--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

time = 0

controls = {
	-- menu_up = 'up',
	-- menu_down = 'down',
	-- menu_left = 'left',
	-- menu_right = 'right',
	-- menu_select = 'enter',
	-- menu_back = 'esc',
	
	player_up = 'up',
	player_down = 'down',
	player_left = 'left',
	player_right = 'right',
	fire = 'z',
	bomb = 'x',
	weapon = '1',
	invul = 'i'
}
	
score = 0
recent_score = 0

highscores = {}
default_scores = "\n6000\n5000\n4000\n3000\n2000\n1000"

levelNum = 0
max_level = 4

Title = require("Title")
Game = require("Game")
Intro = require("Intro")
Intro2 = require("Intro2")
Intro3 = require("Intro3")
Intro4 = require("Intro4")
StageIntro = require("StageIntro")
HowToPlay = require("HowToPlay")
ScoreScreen = require("ScoreScreen")
Menu = require("Menu")
Menu2 = require("Menu2")
Studio = require("Studio")
Win = require("Win")
Settings = require("Settings")
GameOver = require("GameOver")

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
	Menu2:load()
	Intro:load()
	Intro2:load()
	Intro3:load()
	Intro4:load()
	StageIntro:load()
	HowToPlay:load()
	Game:load()
	ScoreScreen:load()
	Win:load()
	Settings:load()
	GameOver:load()

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

function love.keypressed(key)
	current:keypressed(key)
end

function love.quit()
	love.filesystem.write("scores", "")

	for rank, hs in ipairs(highscores) do
		love.filesystem.append("scores", "\n" .. hs)
	end
end
