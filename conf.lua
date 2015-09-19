function love.conf(t)
	t.identity = nil
	t.version = "0.9.2"
	t.window.title = "First Game"

	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"

	t.window.width = 800
    t.window.height = 600
	t.window.resizable = false

	t.window.vsync = true
	t.console = true
end
