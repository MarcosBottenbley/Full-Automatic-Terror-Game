--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Bucket = {
	objs = {},
	row = 0, col = 0,
	ID = 0
}
Bucket.__index = Bucket

setmetatable(Bucket, {
	__call = function (cls, ... )
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function Bucket:_init(x, y, width, height, row, col, rows, cols, id)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.row = row
	self.col = col
	self.rows = rows
	self.cols = cols
	self.ID = id
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
	if self:contains(obj) and not self:alreadyContains(obj) then
		table.insert(self.objs, obj)
	end
end

function Bucket:remove()
	local x = 1
	for _, o in ipairs(self.objs) do
		if not self:contains(o) then
			table.remove(self.objs, x)
		end
		x = x + 1
	end
end

function Bucket:contains(obj)
	local valid = false
	local x = obj:getX()
	local y = obj:getY()
	local owidth = obj:getWidth()
	local oheight = obj:getHeight()
	if x - owidth >= self.x or x + owidth <= self.x + self.width then
		if y - oheight >= self.y or y + oheight <= self.y + self.height then
			valid = true
		end
	end
	return valid
end

function Bucket:alreadyContains(obj)
	local valid = false
	for _, o in ipairs(self.objs) do
		if o == obj then
			valid = true
		end
	end

	return valid
end

function Bucket:update()
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
	local num = table.getn(self.objs)
	print(self.objs)
	if num > 0 then
		love.graphics.setColor(0,255,0,255)
	else
		love.graphics.setColor(255,0,0,255)
	end

	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.print(tostring(num), self.x + self.width/2, self.y + self.height/2)
	love.graphics.setColor(255, 255, 255, 255)
end

return Bucket