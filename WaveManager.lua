--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

local wave
local clear
local timer
local enemies
local level
local maxwave

local WaveManager = {
    wave = 0,
    clear = false,
    timer = 0,
    enemies = {},
    level,
    maxwave,
}
WaveManager.__index = WaveManager

setmetatable(WaveManager, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function WaveManager:_init(lvl)
    -- wave = 0
    -- clear = false
    -- check = false
    -- level = lvl
    -- timer = 0
    -- enemies = {}

    self.level = lvl
    for i = 1, 10 do
        self.enemies[i] = {}
    end
end

function WaveManager:load()
    local create = {}
    local wNum = 1
    local makestuff = false

    --populates creation array with everything specified in level file
    for line in love.filesystem.lines(self.level) do
        if string.find(line, "wave:") ~= nil then
            wNum = tonumber(string.sub(line, 6))
            self.maxwave = tonumber(string.sub(line, 6))
            makestuff = true
        end
        if string.find(line, ":") == nil and makestuff then
            subline = line
            arg = ""
            thing = {}
            table.insert(thing, string.match(subline, "(%a+)%(*"))
            subline = string.sub(subline, 5)
            while arg ~= nil do
                arg = string.match(subline, "(%d+),*")
                if arg ~= nil then
                    subline = string.sub(subline, arg:len() + 2)
                    table.insert(thing, tonumber(arg))
                end
            end
            table.insert(self.enemies[wNum], thing)
        end
    end
end

function WaveManager:update(dt, game)
    -- for _, o in ipairs(objects) do
        -- if o:getID() == 1 then
            -- clear = false
        -- end
    -- end
    -- if clear then check end

    self.timer = self.timer + dt

    if self.timer > 1 then
        self.clear = true
        for _, o in ipairs(objects) do
            if o:getID() == 1 and o:getType() ~= 't' then
                self.clear = false
            end
        end
        self.timer = 0
    end

    if self.clear then
        if self.wave == self.maxwave then
            game:advance()
        else
            self.wave = self.wave + 1
            self.clear = false
            self:start()
        end
    end
end

function WaveManager:start()
    self.numLeft = 0
    for _, object in ipairs(self.enemies[self.wave]) do
        local etype
        if object[1] == "ogb" then
            etype = 'g'
        elseif object[1] == "ocb" then
            etype = 'c'
        elseif object[1] == "ops" then
            etype = 'f'
        elseif object[1] == "odm" then
            etype = 'd'
        elseif object[1] == "tur" then
            etype = 't'
        elseif object[1] == "osc" then
            etype = 's'
        elseif object[1] == "oss" then
            etype = 'b'
        end
        if etype ~= nil then
            local o = ObjectHole(object[2], object[3], etype)
            table.insert(objects, o)
        end
        if object[1] ~= "tur" then
            self.numLeft = self.numLeft + 1
        end
    end
end

function WaveManager:waveDraw(numEnemies)
    if self.wave >= 1 and self.wave <= self.maxwave then
        love.graphics.print(
            "WAVE: " .. self.wave,
            310, 10
        )
    end
    if numEnemies <= 5 and numEnemies > 0 then
        love.graphics.print(
            "ENEMIES REMAINING: " .. numEnemies,
            10, 80
        )
    end
end

function WaveManager:getWave()
    return self.wave
end

return WaveManager
