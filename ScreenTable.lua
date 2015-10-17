--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local ScreenTable = {}
ScreenTable.__index = ScreenTable

setmetatable(ScreenTable, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function ScreenTable:_init(rows, cols, swidth, sheight)
	local bucket_width = swidth/rows
	local bucket_height = sheight/cols
	for i=1, rows do
		buckets[i] = {}
		for j=1, cols do
			local temp = Bucket(i-1 * bucket_width,j-1 * bucket_height,bucket_width,bucket_height,i,j,rows,cols)
			buckets[i][j]= temp
		end
	end

	--sets neighbors
	for x=1, rows do
		for y=1, cols do
			local nr = buckets[x][y]:getNeighborRows()
			local nc = buckets[x][y]:getNeighborCols()

			for n=1, 8 do
				if nr[n] ~= nil and nc[n] ~= nil then
					buckets[x][y]:addNeighbor(n,buckets[nr[n]][nc[n]])
				else
				    buckets[x][y]:addNeighbor(n,nil)
				end
			end
		end
	end
end