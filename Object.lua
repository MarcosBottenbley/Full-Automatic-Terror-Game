math.randomseed(os.time())

local Object= {
	x = 10, y = 10,
	vx = 50, vy = 50,
	width = 10, height = 10,
	sprites = {}, delta = 0,
	name = "Object"
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Object:_init(x, y, v, file, width, height, frames, states, delay, name)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v

	self.sprite_sheet = love.graphics.newImage(file)

	self.width = width 		--width of each sprite in the frame
	self.height = height	--height of each sprite in the frame

	self.frames = frames	--number of frames
	self.states = states	--number of states (different animations)

	self.delay = delay		--delay between changing frames

	self.name = name

	self.current_frame = 1
	self.current_state = 1

	self.sheet_width = self.sprite_sheet:getWidth()
	self.sheet_height = self.sprite_sheet:getHeight()

	self:load()
end

function Object:load()
	self.sprites[1] = love.graphics.newQuad(1,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[2] = love.graphics.newQuad(62,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[3] = love.graphics.newQuad(124,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[4] = love.graphics.newQuad(186,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[5] = love.graphics.newQuad(248,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[6] = love.graphics.newQuad(310,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[7] = love.graphics.newQuad(372,1, self.width,self.height,self.sheet_width,self.sheet_height)
	self.sprites[8] = love.graphics.newQuad(434,1, self.width,self.height,self.sheet_width,self.sheet_height)
end

function Object:update(dt)
	self.delta = self.delta + dt

	if self.delta >= self.delay then
		self.current_frame = (self.current_frame % self.frames) + 1
		self.delta = 0
	end
end

function Object:draw(r,g,b)
	if self.sprite_sheet ~= nil then
		love.graphics.draw(self.sprite_sheet, self.sprites[self.current_frame], self.x, self.y)
	else
		if r ~= nil and g ~= nil and b ~= nil then
			love.graphics.setColor(r,g,b)
		else
			love.graphics.setColor(255,255,255,255)
		end
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
	love.graphics.setColor(255,255,255,255)
end

return Object