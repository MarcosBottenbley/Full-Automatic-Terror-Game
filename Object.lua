--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

math.randomseed(os.time())

local Object = {
	x = 10, y = 10,
	width = 10, height = 10,
	sprites = {}, delta = 0,
	id = 0, type = 'o',
	collided = false,
	dead = false, thrusters = {},
	particles = nil
}
Object.__index = Object

setmetatable(Object, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

--- initializes objects with position, image, size, frames, and other details

function Object:_init(x, y, file, width, height, frames, states, delay)
	self.x = x
	self.y = y

	if file ~= nil then
		self.sprite_sheet = love.graphics.newImage(file)
		self.sheet_width = self.sprite_sheet:getWidth()
		self.sheet_height = self.sprite_sheet:getHeight()
	end

	self.width = width 	--width of each sprite in the frame
	self.height = height	--height of each sprite in the frame

	if states ~= nil then
		self.frames = frames	--number of frames
		self.states = states	--number of states (different animations)
		self.delay = delay		--delay between changing frames
	else
		self.frames = 0
		self.states = 0
		self.delay = 0
	end

	self.current_frame = 1
	self.current_state = 1

	self.timer = 0

	self.exploded = false

	self:load()
	self.validCollisions = {0}

	local img = love.graphics.newImage("gfx/particle.png")
	self.particles = love.graphics.newParticleSystem(img, 50)
end

function Object:load()
	for i = 1, self.states do
		local h = (self.height * i) - (self.height-1)
		self.sprites[i] = {}

		for j = 1, self.frames do
			local w = (self.width * j) - (self.width-1)
			self.sprites[i][j] = love.graphics.newQuad(w,h,
				self.width,
				self.height,
				self.sheet_width,
				self.sheet_height)
		end
	end
end

function Object:update(dt)
	self.delta = self.delta + dt

	if self.delay > 0 and self.delta >= self.delay then
		self.current_frame = (self.current_frame % self.frames) + 1
		self.delta = 0
	end
	self.particles:update(dt)
end

--- handles sprite sheets for animating object movement

function Object:draw(r,g,b, angle)
	if r ~= nil and g ~= nil and b ~= nil then
		love.graphics.setColor(r,g,b)
	else
		love.graphics.setColor(255,255,255,255)
	end

	if self.sprite_sheet ~= nil then
		love.graphics.draw (
			self.sprite_sheet,
			self.sprites[self.current_state][self.current_frame],
			self.x, self.y,
			angle, 1,1,
			self.width/2 - 1, self.height/2 - 1
		)
	else
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
	love.graphics.setColor(255,255,255,255)
end

--Change object's animation to another state
function Object:changeAnim(state)
	self.current_state = state
	self.current_frame = 1
	self.delta = 0
end

--- manually sets object x coordinate
function Object:setX(newX)
	self.x = newX
end

--- manually sets object y coordinate

function Object:setY(newY)
	self.y = newY
end

--- retrieves object x coordinate

function Object:getX()
	return self.x
end

--- retrieves object y coordinate

function Object:getY()
	return self.y
end

function Object:getWidth(...)
	return self.width
end

function Object:getHeight(...)
	return self.height
end

function Object:getID( ... )
	return self.id
end

function Object:getType( ... )
	return self.type
end

function Object:getHitBoxes( ... )
	-- body
end

function Object:explode()

end

function Object:getValid(...)
	return self.validCollisions
end

function Object:collide(obj)

end

function Object:setDead()
	self.dead = true
end

function Object:isDead()
	return self.dead
end

return Object
