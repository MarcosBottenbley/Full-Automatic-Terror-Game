local isOver
local time2

local GameState = {
	duration = 30, --seconds
	image = nil, sound = nil,
	time = 0,
}
GameState.__index = GameState

setmetatable(GameState, {
	__call = function (cls, ... )
		local self = setmetatable({},cls)
		self:_init(...)
		return self
	end,
})

function GameState:_init(duration, image, sound, font)
	self.duration = duration
	self.image = image
	self.sound = sound
	if font ~= nil
		love.graphics.setFont(font)
	end
end

function GameState:update(input)
	if time == 0 then
		time = love.timer.getTime()
	end

	if input then
		isOver = true
	end

	time2 = love.time.getTime()
	if duration ~= nil and (time2 - time) >= duration then
		isOver = true
	end
end

function isOver()
	return isOver
end

function GameState:draw(swidth, sheight, title)
	if image ~= nil then
		love.graphics.draw(self.image, swidth/2, sheight/2)
	elseif title ~= nil
		love.graphics.printf(title, swidth/2, sheight/2, 200, "center")
	else
		love.graphics.printf("GameState", swidth/2, sheight/2, 200, "center")
	end
end

return GameState