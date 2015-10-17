--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

Bucket = require("Bucket")

local ScreenTable = {
	rows, cols,
	buckets = {}, bucket_width,
	bucket_height
}
ScreenTable.__index = ScreenTable

setmetatable(ScreenTable, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ScreenTable:_init(rows, cols, swidth, sheight)
	self.rows = rows
	self.cols = cols
	self.bucket_width = swidth/rows
	self.bucket_height = sheight/cols
	local id = 0
	for i=1, self.rows do
		self.buckets[i] = {}
		for j=1, self.cols do
			local temp = Bucket((i-1) * self.bucket_width,
								(j-1)* self.bucket_height,
								self.bucket_width,
								self.bucket_height,
								i,
								j,
								self.rows,
								self.cols,
								id)

			self.buckets[i][j] = temp
			id = id + 1
		end
	end
end

function ScreenTable:update(objs)
	for _, o in ipairs(objs) do
		self:insert(o)
	end

	for i = 1, self.rows do
		for j = 1, self.cols do
			self.buckets[i][j]:update()
		end
	end
end

function ScreenTable:insert(obj)
	for i = 1, self.rows do
		for j = 1, self.cols do
			self.buckets[i][j]:add(obj)
		end
	end
end

function ScreenTable:draw(...)
	for i = 1, self.rows do
		for j = 1, self.cols do
			self.buckets[i][j]:draw()
		end
	end
end

return ScreenTable