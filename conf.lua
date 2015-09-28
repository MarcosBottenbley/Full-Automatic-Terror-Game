--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

function love.conf(t)
	t.version = "0.9.2"
	t.window.title = "First Game"

	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"

	t.window.width = 800
    t.window.height = 600
	t.window.resizable = false

	t.window.vsync = true
	t.console = true		--for testing
end
