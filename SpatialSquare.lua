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

function Bucket:_init(x,y,width,height, row, col, rows, cols)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.row = row
	self.col = col
	self.rows = rows
	self.cols = cols
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
end

function Bucket:addNeighbor(n, neighbor)
	self.neighbors[n] = neighbor
end

function Bucket:add(obj)
	table.insert(objects, obj)
end

function Bucket:remove()
	local x = 1
	for _, o in ipairs(objects) do
		if self:isInside(o) == false then
			table.remove(objects, x)
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

function Bucket:update()
	local length = table.getn(objects)
	for i=1, length - 1 do
		for j = i + 1, length do
			if objects[i]:getID() ~= objects[j]:getID() and objects[i].collided == false and objects[j].collided == false then
				if self:valid(objects[i], objects[j]) then
					if self:touching(objects[i], objects[j]) then

						-- objects collided
						objects[i].collided = true
						objects[j].collided = true
						-- set to explode
						objects[i].current_state = 2
						objects[i].current_frame = 1
						objects[j].current_state = 2
						objects[j].current_frame = 1
					end
				end
				--shitty powerup collision code
				if objects[i]:getID() ~= 4 and objects[j]:getID() ~= 4 then
					if self:touching(objects[i], objects[j]) then
						if objects[i]:getID() == 2 and objects[j]:getID() == 5 then
							objects[i].powerup = true
							objects[j].collided = true
						elseif objects[i]:getID() == 5 and objects[j]:getID() == 2 then
							objects[j].powerup = true
							objects[i].collided = true
						end
					end
				end
			end
		end
	end

	for _, o in ipairs(objects) do
		for i=1, 8 do
			if neighbors[i] ~= nil and neighbors[i]:isInside(o) then
				neighbors[i]:add(o)
			end
		end
	end
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