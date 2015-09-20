local Sprite = {
	sprites = {}
}
Sprite.__index = Sprite

setmetatable(Sprite, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Sprite:_init(file, fwidth, fheight, frames, states, delay)
	self.sprite_sheet = love.graphics.newImage("gfx/enemy_sheet.png")

	self.fwidth = fwidth 	--width of each sprite in the frame
	self.fheight = fheight	--height of each sprite in the frame

	self.frames = frames	--number of frames
	self.states = states	--number of states (different animations)

	self.delay = delay		--delay between changing frames

	self.current_frame = 1
	self.current_state = 1

	self.width = self.sprite_sheet:getWidth()
	self.height = self.sprite_sheet:getHeight()
end

function Sprite:load(w,h)
	for i = 1, self.states do
		local h = self.fheight * (i-1)
		self.sprites[i] = {}

		for j = 1, self.states do
			local w = self.width * (j-1)
			self.sprites[i][j] = love.graphics.newQuad(w,h,self.fwidth,self.fheight,self.width,self.height)
		end
	end
end

function Sprite:update(dt)
	self.delta = self.delta + dt

	if self.delta >= self.delay then
		self.current_frame = (self.current_frame % self.frames) + 1
		self.delta = 0
	end
end

function Sprite:draw(x,y)
	love.graphics.drawq(self.sprite_sheet, self.sprites[self.current_state][self.current_frame], x, y)
end

function Sprite:getWidth()
	return self.fwidth
end

function Sprite:getHeight()
	return self.fheight
end

return Sprite