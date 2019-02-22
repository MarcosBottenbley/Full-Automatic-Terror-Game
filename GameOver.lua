--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

State = require("State")

local GameOver = {name = "GAME OVER",
help = "Press any key to continue"}
GameOver.__index = GameOver

setmetatable(GameOver, {
    __index = State,
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

--- loads the game over screen upon loss and initializes
--- its sound effect

function GameOver:load()
    self.font = love.graphics.newFont("ka1.ttf", 50)
    self.width = self.font:getWidth(self.name)
    self.height = self.font:getHeight(self.name)

    self.fontsmaller = love.graphics.newFont("PressStart2P.ttf", 12)

    lose = love.audio.newSource("sfx/shutdown.mp3")
    lose:setLooping(false)
end

--- Center small inside large.
function center(large, small)
    return large/2 - small/2
end

function GameOver:fadein()
    if self.time < 1 then
        local c = lerp(0, 255, self.time/1)
        return {c, c, c, 255}
    else
        return {255, 255, 255, 255}
    end
end

function GameOver:update(dt)
    self.time = self.time + dt
end

function GameOver:draw()
    --- prints actual text in center
    love.graphics.setFont(self.font)
    love.graphics.setColor(self:fadein())
    love.graphics.print(
        self.name,
        center(width, self.width), center(height, self.height)
    )

    --- after 2 seconds, spawns help instructions at bottom of page

    if self.time > 2 then
        love.graphics.setFont(self.fontsmaller)
        love.graphics.print(
        self.help,
        10, height - 10
        )
    end
end

--- goes to score screen after key is pressed

function GameOver:keyreleased(key)
    if self.time > 1 then
        switchTo(ScoreScreen)
    end
end

function GameOver:keypressed(key)
end

--- upon losing the game, plays sound effect and starts timer

function GameOver:start()
    lose:play()
    self.time = 0
end

function GameOver:stop()
end

return GameOver
