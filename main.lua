time = 0

once_u = false
once_d = false
once_r = false
once_l = false


function love.load(arg)
	math.randomseed(os.time())

	Player = require("Player")
	Enemy = require("Enemy")

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

	player1:draw(player_sprite)
	
	for _, e in ipairs(enemies) do
		e:draw(enemy_sprite)
	end
end

function love.keypressed(key)

	-- exits
	if key == 'escape' then
		love.event.quit()
	end
end
