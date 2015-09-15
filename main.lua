time = 0

local Enemy = {
	x = 10, y = 10,
	vx = 20, vy = 20,
	r = 10
}
Enemy.__index = Enemy

setmetatable(Enemy, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function Enemy.new(x, y, v)
	local self = setmetatable({}, Enemy)
	self.x = x
	self.y = y
	self.vx = v
	self.vy = v

	return self
end

function Enemy:draw()
	love.graphics.draw(enemy_sprite, self.x, self.y)
end

function Enemy:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < 1 or self.x > width-enemy_width then
		self:bounce(1)
	end

	if self.y < 1 or self.y > height-enemy_height then
		self:bounce(0)
	end
end

function Enemy:direction()
	if math.random(0,2) <= 1 then
		if math.random(0,2) >= 1 then
			self:bounce(0)
		else
			self:bounce(1)
		end
	end
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

local Player = {
	x = 10, y = 10,
	width = 10, height = 10,
	vel = 10
}
Player.__index = Player

setmetatable(Player, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function Player.new(x, y, w, h, v)
	local self = setmetatable({}, Player)
	self.x = x
	self.y = y
	self.width = w
	self.height = h
	self.vel = v

	return self
end

function Player:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		self.x = self.x-self.vel*dt

		if self.x < 1 then
			self.x = 1
			blip:play()
		end
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		self.x = self.x+self.vel*dt

		if self.x > (width - self.width) then
			self.x = (width - self.width)
			blip:play()
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		self.y = self.y + self.vel*dt

		if self.y > (height - self.height) then
			self.y = (height - self.height)
			blip:play()
		end
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		self.y = self.y-self.vel*dt

		if self.y < 1 then
			self.y = 1
			blip:play()
		end
	end
end

function Player:draw()
	love.graphics.draw(player_sprite, self.x, self.y)
end

function love.load(arg)
	math.randomseed(os.time())
	width = love.window.getWidth()
	height = love.window.getHeight()
	
	enemy_sprite = love.graphics.newImage("gfx/gel.png")
	enemy_width = enemy_sprite:getWidth()
	enemy_height = enemy_sprite:getHeight()
	
	player_sprite = love.graphics.newImage("gfx/toast.png")
	player_width = player_sprite:getWidth()
	player_height = player_sprite:getHeight()
	
	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)

	enemies = {}

	for i = 1, 10 do
		table.insert(enemies, Enemy(math.random(800 - enemy_width), math.random(600 - enemy_height), math.random(40,80)))
	end

	for _, e in ipairs(enemies) do
		e:direction()
	end

	player1 = Player(width/2, height/2, player_width, player_height, 200)
end

function love.update(dt)
	time = time + dt

	for _, e in ipairs(enemies) do
		e:update(dt)
	end

	player1:update(dt)

end

function love.draw(dt)

	player1:draw()
	
	for _, e in ipairs(enemies) do
		e:draw()
	end
end

function love.keypressed(key)

	-- exits
	if key == 'escape' then
		love.event.quit()
	end
end
