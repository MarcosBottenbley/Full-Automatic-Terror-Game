--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local namelist = {
	"SUN ZONE",
	"ONSLAUGHT",
	"SPACE JAIL",
	"GAUNTLET",
	"SCRAPYARD",
	"SIEGE",
	"EVENT HORIZON"
}

local StageIntro = {
	--variables to hold the "now entering" message and stage name
	stagestring = "", enterstring = "",
	--current x value for the stage text and entering text
	stagex_pos = 0, enterx_pos = 0,
	--target x/y values for the stage/entering text
	stagex = 0, stagey = 0, enterx = 0, entery = 0,
}
StageIntro.__index = StageIntro

setmetatable(StageIntro, {
	__index = State,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function StageIntro:load()
	--font for both messages is set here
	self.stagefont = love.graphics.newFont("ka1.ttf", 74)
	self.enterfont = love.graphics.newFont("ka1.ttf", 32)
end

function StageIntro:start()
	self.time = 0
	
	--the stage name and entering text are set automatically depending
	--on the level. if you want to change the name, edit the namelist table
	self.stagestring = namelist[levelNum]
	if levelNum < 1 then
		self.stagestring = "TUTORIAL"
	end
	self.enterstring = "Now entering Sector " .. levelNum
	--hacky code to handle branching, will change later
	if levelNum == 3 then
		self.enterstring = "Now entering Sector 3A"
	elseif levelNum == 4 then
		self.enterstring = "Now entering Sector 3B"
	elseif levelNum == 5 then
		self.enterstring = "Now entering Sector 4B"
	elseif levelNum == 6 then
		self.enterstring = "Now entering Sector 4A"
	elseif levelNum == 7 then
		self.enterstring = "Now entering Final Sector"
		self.stagefont = love.graphics.newFont("ka1.ttf", 56)
		self.enterfont = love.graphics.newFont("ka1.ttf", 28)
	end
	
	--we have to set the font dimensions every time the state 
	--gets reloaded since the names change
	self.sf_width = self.stagefont:getWidth(self.stagestring)
	self.sf_height = self.stagefont:getHeight(self.stagestring)
	
	self.ef_width = self.enterfont:getWidth(self.enterstring)
	self.ef_height = self.enterfont:getHeight(self.enterstring)
	
	--target x/y position for text is set here, right now they're both
	--centered in the middle with some slight offsets
	self.stagex = center(width, self.sf_width) + 100
	self.stagey = center(height, self.sf_height)
	
	self.enterx = center(width, self.ef_width) - 100
	self.entery = center(height, self.ef_height) - self.sf_height + 20
	
	--there's a weird bug that makes the text display onscreen for a split
	--second before it zooms in if we don't specify that it starts offscreen
	self.enterx_pos = -1000
	self.stagex_pos = -1000
end

function StageIntro:update(dt)
	self:updateTextPos(dt)
	
	--switches to game after 5 seconds
	self.time = self.time + dt
	if self.time > 5 then
		switchTo(Game)
	end
end

--handles the text movement (the "now entering" message zooms in from offscreen
--on the left and the stage name does the same from the right
function StageIntro:updateTextPos(dt)
	if self.time < 1 then
		self.enterx_pos = self.enterx - 1000 * (1 - self.time)
		self.stagex_pos = self.stagex + 1000 * (1 - self.time)
	end
end

function StageIntro:draw()	
	love.graphics.setFont(self.enterfont)
	love.graphics.print(
		self.enterstring,
		self.enterx_pos, self.entery
	)
	
	love.graphics.setFont(self.stagefont)
	love.graphics.print(
		self.stagestring,
		self.stagex_pos, self.stagey
	)
end

function StageIntro:keyreleased(key)
	switchTo(Game)
end

function StageIntro:keypressed(key)
end

function StageIntro:stop()
end

return StageIntro