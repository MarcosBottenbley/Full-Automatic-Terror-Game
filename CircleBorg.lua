--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

GlowBorg = require("GlowBorg")

local CircleBorg = {
	--Distance from player at which the glowborg will 
	--stop advancing and start circling around the player
	chase_range = 300,
	--Angle used for moving the glowborg in a circle
	circle_angle = 0,
	--Is the glowborg circling around the player
	circling = false,
	--Time it takes for the glowborg to close in on the player
	--after it starts circling
	closing_time = 12,
	--Variable used to measure distance from player when circling
	player_dist,
	type = 'c'
}
CircleBorg.__index = CircleBorg

setmetatable(CircleBorg, {
	__index = GlowBorg,
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function CircleBorg:_init()
	Enemy._init(self, self.x, self.y, self.vel, self.img, self.width, self.height, self.frames, self.states, self.delay)
	self.player_dist = self.chase_range
end

function CircleBorg:update(dt, swidth, sheight, px, py)
	Enemy.update(self, dt, swidth, sheight)
	
	local angle = math.atan((py - self.y) / (px - self.x))
	
	--if not exploding or circling around player
	if not self.collided then
		if not self.circling then
			--move towards player
			if px - self.x > 0 then
				self.x = self.x + self.vel * dt * math.cos(angle)
				self.y = self.y + self.vel * dt * math.sin(angle)
			else
				self.x = self.x - self.vel * dt * math.cos(angle)
				self.y = self.y - self.vel * dt * math.sin(angle)
			end
			
			if (self.x - px)^2 + (self.y - py)^2 < self.chase_range^2 then
				self.circling = true
				--hacky code to set borg's starting angular position in circle to current position
				if self.x < px then
					self.circle_angle = angle + math.pi
				else
					self.circle_angle = angle
				end
			end
		else
			--circle around player
			self.x = px + self.player_dist * math.cos(self.circle_angle)
			self.y = py + self.player_dist * math.sin(self.circle_angle)
			self.circle_angle = self.circle_angle + (math.pi/2) * dt
			self.player_dist = self.player_dist - (self.chase_range / self.closing_time) * dt
		end
	end
end

function CircleBorg:draw()
	Enemy.draw(self, 100, 100, 255)
end

return CircleBorg
