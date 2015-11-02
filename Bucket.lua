--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local Bucket = {
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
	self.objects = {}
end

function Bucket:add(obj)
	if self:contains(obj) and not self:alreadyContains(obj) then
		table.insert(self.objects, obj)
	end
end

function Bucket:remove()
	local x = 1
	for _, o in ipairs(self.objects) do
		if not self:contains(o) then
			table.remove(self.objects, x)
		end
		x = x + 1
	end
end

function Bucket:contains(obj)
	local valid = false
	if obj:getID() ~= 4 and obj:getID() ~= 10 then
		local hb = obj:getHitBoxes()

		for _, b in ipairs(hb) do
			if b[1] + b[3] >= self.x and b[1] - b[3] <= self.x + self.width then
				if b[2] + b[3] >= self.y and b[2] - b[3] <= self.y + self.height then
					valid = true
				end
			end
		end
	else
		local x = obj:getX()
		local y = obj:getY()
		if x >= self.x and x <= self.x + self.width then
			if y >= self.y and y <= self.y + self.height then
				valid = true
			end
		end
	end
	return valid
end

function Bucket:alreadyContains(obj)
	local valid = false
	for _, o in ipairs(self.objects) do
		if o == obj then
			valid = true
		end
	end

	return valid
end

function Bucket:update(dt)
	local length = table.getn(self.objects)
	
	for i=1, length do
		if self.objects[(length + 1) - i]:isDead() then
			table.remove(self.objects,(length + 1) - i)
		end
	end
	
	length = table.getn(self.objects)
	
	for i=1, length - 1 do
		for j = i + 1, length do
			if self:valid(self.objects[i], self.objects[j]) then
				if self:touching(self.objects[i], self.objects[j]) then
					self.objects[i]:collide(self.objects[j])
					self.objects[j]:collide(self.objects[i])
				end
			end
		end
	end
	
	
	--self:remove()
end

function Bucket:valid(obj1, obj2)
	local valid = false

	local vc1 = obj1:getValid()
	local vc2 = obj2:getValid()

	--is obj2 in obj1's valid collisions list?
	for _, c in ipairs(vc1) do
		if c == obj2:getID() then
			valid = true
		end
	end
	
	if obj1.collided or obj2.collided then
		valid = false
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
	local num = table.getn(self.objects)
	if num > 0 then
		love.graphics.setColor(0,255,0,255)
		love.graphics.rectangle("line", self.x, self.y, self.width-1, self.height-1)
		love.graphics.print(tostring(num), self.x + self.width/2, self.y + self.height/2)
	end
	love.graphics.setColor(255, 255, 255, 255)
end

function Bucket:getNumObjects(...)
	return table.getn(self.objects)
end

return Bucket