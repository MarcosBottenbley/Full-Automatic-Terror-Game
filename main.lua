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
	love.graphics.circle("fill", self.x, self.y, self.r, 100)
end

function Enemy:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < self.r or self.x > width-self.r then
		self:bounce(1)
	end

	if self.y < self.r or self.y > height-self.r then
		self:bounce(0)
	end
end

function Enemy:direction()
	if math.random() == 1 then
		self:bounce(math.random())
	end
end

function Enemy:getx()
	print(self.x)
end

function Enemy:gety()
	print(self.y)
end

function Enemy:bounce(side)
	if side == 1 then
		self.vx = -self.vx
	else
		self.vy = -self.vy
	end
end

function love.load(arg)
	width = love.window.getWidth()
	height = love.window.getHeight()

	enemies = {}

	for i = 1, 10 do
		table.insert(enemies, Enemy(math.random(800), math.random(600), math.random(20,60)))
	end

	player1 = {x = width/2, y = height/2, width = 50, height = 50, speed = 20}
	color = {r = 26, g = 237, b = 19}
end

function love.update(dt)
	time = time + dt

	for _, e in ipairs(enemies) do
		e:update(dt)
	end

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		player1.x = player1.x-player1.speed

		if player1.x < 1 then
			player1.x = 1
		end
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		player1.x = player1.x+player1.speed

		if player1.x > width-player1.width+1 then
			player1.x = width-player1.width+1
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		player1.y = player1.y + player1.speed

		if player1.y > height-player1.height+1 then
			player1.y = height-player1.height+1
		end
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		player1.y = player1.y-player1.speed

		if player1.y < 1 then
			player1.y = 1
		end
	end
end

function love.draw(dt)
	love.graphics.setColor(color.r,color.g,color.b,255)
	love.graphics.rectangle("fill", player1.x , player1.y , player1.width , player1.height)

	for _, e in ipairs(enemies) do
		e:draw()
	end

	love.graphics.setColor(255, 255, 255, 255)
end

function love.keypressed(key)

	-- exits
	if key == 'escape' then
		love.event.quit()
	end
end
