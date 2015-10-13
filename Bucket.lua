--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Bucket = {
	objects = {},
	row = 0, col = 0,
	ID = 0, neighbors = {}
}
Bucket.__index = Bucket

setmetatable(Bucket, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Bucket:_init(x, y, width, height, row, col, rows, cols)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.row = row
	self.col = col
	self.rows = rows
	self.cols = cols
end

function Bucket:printBucket( ... )
	print("BUCKET MOTHERFUCKER!")
end

function Bucket:getX(...)
	return self.x
end

function Bucket:getY(...)
	return self.y
end

function Bucket:getWidth(...)
	return self.width
end

function Bucket:getHeight(...)
	return self.height
end

function Bucket:getNeighborRows(...)
	local nrows = {}

	--middle rows
	nrows[4] = self.row
	nrows[5] = self.row

	--top rows
	if self.row - 1 > 0 then
		nrows[1] = self.row - 1
		nrows[2] = self.row - 1
		nrows[3] = self.row - 1
	else
	    nrows[1] = nil
		nrows[2] = nil
		nrows[3] = nil
	end

	--bottom rows
	if self.row + 1 < self.rows then
		nrows[6] = self.row + 1
		nrows[7] = self.row + 1
		nrows[8] = self.row + 1
	else
	    nrows[6] = nil
		nrows[7] = nil
		nrows[8] = nil
	end

	return nrows
end

function Bucket:getNeighborCols(...)
	local ncols = {}

	--middle columns
	ncols[4] = self.col
	ncols[5] = self.col

	--top columns
	if self.col - 1 > 0 then
		ncols[1] = self.col - 1
		ncols[2] = self.col - 1
		ncols[3] = self.col - 1
	else
	    ncols[1] = nil
		ncols[2] = nil
		ncols[3] = nil
	end

	--bottom columns
	if self.col + 1 < self.cols then
		ncols[6] = self.col + 1
		ncols[7] = self.col + 1
		ncols[8] = self.col + 1
	else
	    ncols[6] = nil
		ncols[7] = nil
		ncols[8] = nil
	end

	return ncols
end

function Bucket:addNeighbor(n, neighbor)
	self.neighbors[n] = neighbor
end

function Bucket:add(obj)
	if self:isInside(obj) then
		table.insert(self.objects, obj)
	end
end

function Bucket:remove()
	local x = 1
	for _, o in ipairs(self.objects) do
		if self:isInside(o) == false then
			table.remove(self.objects, x)
		end
		x = x + 1
	end
end

function Bucket:isInside(obj)
	local valid = false
	local x = obj:getX()
	local y = obj:getY()
	local width = obj:getWidth()
	local height = obj:getHeight()
	if x - width >= self.x or x + width <= self.x + self.width then
		if y - height >= self.y or y + height <= self.y + self.height then
			valid = true
		end
	end
	return valid
end

function Bucket:update(dt,px,py)
	--[[
	local playerx = 0
	local playery = 0
	local x = 1
	for _, o in ipairs(self.objects) do
		-- update Spawn

		if x == 1 then
			playerx = o:getX()
			playery = o:getY()
		end

		if o:getID() == 4 then
			o:update(dt, playerx, playery)
		end

		o:update(dt, bg_width, bg_height, playerx, playery)

		if o:getID() == 3 and
			o:exited_screen(bg_width + player:getWidth(), bg_height + player:getHeight()) then
			table.remove(self.objects, x)
		end

		if o:getID() == 1 and o:getType() == 'f' then
			o:shoot(dt,playerx,playery)
		end

		x = x + 1
	end

	local length = table.getn(self.objects)
	for i=1, length - 1 do
		for j = i + 1, length do
			if self.objects[i]:getID() ~= self.objects[j]:getID() and self.objects[i].collided == false and self.objects[j].collided == false then
				if self:valid(self.objects[i], self.objects[j]) then
					if self:touching(self.objects[i], self.objects[j]) then

						-- self.objects collided
						self.objects[i].collided = true
						self.objects[j].collided = true
						-- set to explode
						self.objects[i].current_state = 2
						self.objects[i].current_frame = 1
						self.objects[j].current_state = 2
						self.objects[j].current_frame = 1
					end
				end
				--shitty powerup collision code
				if self.objects[i]:getID() ~= 4 and self.objects[j]:getID() ~= 4 then
					if self:touching(self.objects[i], self.objects[j]) then
						if self.objects[i]:getID() == 2 and self.objects[j]:getID() == 5 then
							self.objects[i].powerup = true
							self.objects[j].collided = true
						elseif self.objects[i]:getID() == 5 and self.objects[j]:getID() == 2 then
							self.objects[j].powerup = true
							self.objects[i].collided = true
						end
					end
				end
			end
		end
	end

	--check for when to end explosion animation and remove object
	for i=0, length - 1 do
		if self.objects[length - i].collided then
			if self.objects[length - i].timer > .58 then
				table.remove(self.objects, length - i)
				score = score + 200
				enemy_count = enemy_count - 1
			elseif self.objects[length - i]:getID() == 3  or self.objects[length - i]:getID() == 5 then
				table.remove(self.objects, length - i)
			else
				self.objects[length - i].timer = self.objects[length - i].timer + dt
			end
		end
	end
	--]]

	--checks to see if any of the self.objects went to neighbor
	for _, o in ipairs(self.objects) do
		for i=1, 8 do
			if self.neighbors[i] ~= nil then
				self.neighbors[i]:add(o)
			end
		end
	end

	--checks to see if any self.objects left
	self:remove()
end

function Bucket:valid(obj1, obj2)
	local valid = false

	local id_one = obj1:getID()
	local id_two = obj2:getID()

	if id_one ~= 4 and id_two ~= 4 and id_one ~= 5 and id_two ~= 5 then
		if (id_one == 2 and id_two ~= 3) or (id_two == 2 and id_one ~= 3) or id_one == 1 or id_two == 1 then
			valid = true
		end
	end

	return valid
end

function Bucket:touching(obj1, obj2)

	local hb_1 = obj1:getHitBoxes()
	local hb_2 = obj2:getHitBoxes()

	local length1 = table.getn(hb_1)
	local length2 = table.getn(hb_2)

	if length1 >= length2 then
		for i = 1, length1 do
			for j = 1, length2 do
				local x_dist = math.pow(hb_1[i][1]-hb_2[j][1],2)
				local y_dist = math.pow(hb_1[i][2]-hb_2[j][2],2)
				local d = math.sqrt(x_dist + y_dist)

				if d < hb_1[i][3] + hb_2[j][3] then
					return true
				end
			end
		end
	else
		for i = 1, length2 do
			for j = 1, length1 do
				local x_dist = math.pow(hb_2[i][1]-hb_1[j][1],2)
				local y_dist = math.pow(hb_2[i][2]-hb_1[j][2],2)
				local d = math.sqrt(x_dist + y_dist)

				if d < hb_2[i][3] + hb_1[j][3] then
					return true
				end
			end
		end
	end
end

function Bucket:draw()
	--[[
	for _, o in ipairs(self.objects) do
		o:draw()
	end
	--]]

	--local num = table.getn(self.objects)
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	--love.graphics.print(tostring(num), self.x, self.y, 0, 1, 1, self.width/2, self.height/2)
	love.graphics.print("(" .. tostring(self.row) .. tostring(self.col) .. ")", self.x, self.y, 0, 1, 1, self.width/2, self.height/2)
	love.graphics.setColor(255, 255, 255, 255)
end

function Bucket:drawHitBoxes(obj)
	if obj:getID() == 2 or obj:getID() == 1 then
		local t = o:getHitBoxes()
		for _, h in ipairs(t) do
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.circle("line", h[1], h[2], h[3], 100)
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
end

return Bucket