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
	--love.graphics.circle("fill", self.x, self.y, self.r, 100)
	love.graphics.draw(
		enemy_sprite, 
		self.x, self.y, 
		0, 
		.5, .5, 
		enemy_width/2, enemy_width/2
	)
end

function Enemy:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if self.x < enemy_width/4 or self.x > width-enemy_width/4 then
		self:bounce(1)
	end

	if self.y < enemy_height/4 or self.y > height-enemy_height/4 then
		self:bounce(0)
	end
end

function Enemy:direction()
	if math.floor(math.random(0,2)) == 1 then
		self:bounce(1)
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
	
	enemy_sprite = love.graphics.newImage("gfx/gel_smaller.png")
	enemy_width = enemy_sprite:getWidth()
	enemy_height = enemy_sprite:getHeight()
	
	player_sprite = love.graphics.newImage("gfx/toast.jpg")
	player_width = player_sprite:getWidth()
	player_height = player_sprite:getHeight()
	
	blip = love.audio.newSource("sfx/bump.ogg")
	blip:setLooping(false)

	enemies = {}

	for i = 1, 10 do
		table.insert(enemies, Enemy(math.random(800 - enemy_width/2)
		, math.random(600 - enemy_height/2), math.random(20,60)))
	end

	player1 = {x = width/2, y = height/2, 
	width = player_width/2, height = player_height/2, speed = 20}
	--color = {r = 26, g = 237, b = 19}
end

function love.update(dt)
	time = time + dt

	for _, e in ipairs(enemies) do
		e:update(dt)
	end

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		player1.x = player1.x-player1.speed

		if player1.x < (1 + player1.width/4) then
			player1.x = (1 + player1.width/4)
			blip:play()
		end
	end

	if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
		player1.x = player1.x+player1.speed

		if player1.x > width-player1.width/4+1 then
			player1.x = width-player1.width/4+1
			blip:play()
		end
	end

	if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		player1.y = player1.y + player1.speed

		if player1.y > height-player1.height/4+1 then
			player1.y = height-player1.height/4+1
			blip:play()
		end
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		player1.y = player1.y-player1.speed

		if player1.y < (1 + player1.height/4) then
			player1.y = (1 + player1.height/4)
			blip:play()
		end
	end
end

function love.draw(dt)
	--love.graphics.setColor(color.r,color.g,color.b,255)
	--love.graphics.rectangle("fill", player1.x , player1.y , player1.width , player1.height)

	love.graphics.draw(
		player_sprite, 
		player1.x, player1.y, 
		0, 
		.5, .5, 
		player_width/2, player_width/2
	)
	
	for _, e in ipairs(enemies) do
		e:draw()
	end

	--love.graphics.setColor(255, 255, 255, 255)
end

function love.keypressed(key)

	-- exits
	if key == 'escape' then
		love.event.quit()
	end
end
