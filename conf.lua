--- Marcos Bottenbley
--- mbotten1@jhu.edu

--- Rebecca Bushko
--- rbushko1@jhu.edu

--- Adam Ellenbogen
--- aellenb1@jhu.edu

--- David Miller
--- dmill118@jhu.edu

math.randomseed(os.time())
local titles = {
	"Space Game 3000",
	--"More like DULL Automatic Terror",
	--"More like Full FARTomatic Terror",
	--"More like Full Automatic TERRIBLE",
	"Made with 100% Farm-Raised Roseda Beef",
	--"We're boned",
	"Put your glasses on, nothing will be wrong",
	"Oh no some enemy robot fighter ships or something",
	"Working Working Title",
	"Like Asteroids, but less fun",
	"To win the game, you must defeat me, Peter Froehlich",
	"Press P to win",
	"Gold release in the streets, pre-alpha in the sheets",
	"Game of the Century",
	"Game of the Millenium",
	"It's like Skyrim with guns, except not",
	"\"Fantastic... A tour de force\"   -You",
	"The developers formerly known as BEMB",
	"A+ Material",
	"Okay, Fine, A- Material",
	"The Quest for Peace",
	"Toast Quest: Revenge of the Blobs",
	"All talk, no action",
	"Stop! You've violated the law. Pay the court a fine or serve your sentence. Your stolen goods are now forfeit.",
	"The Citizen Kane of video games",
	"The Citizen Kane of movies",
	"Solitaire",
	"600.255: Lua and LOVE",
	"Featuring Dante from the Devil May Cry series",
	"FAT 2 is canceled",
	"It's not a bug, it's a feature",
	"Pew Pew Simulator 2015",
	"Go directly to Space Jail. Do not pass Space Go. Do not collect 200 Space Dollars.",
	"This is a great game and you are having fun",
	"Full Automatic Terror: Episode IX of the Myrwioxthyyyg Chronicles",
	"Pre-order today!",
	"If only you could talk to the glowborgs...",
	"Big Ships: Over the Road Spacing",
	"Star Citizen Pre-Pre-Pre-Alpha",
	"YOU are the terror",
	"Humans rule",
	"Don't touch the walls, ok?",
	"Officially Regretting Not Making This a Dating Sim",
	"It's just like Starfox 64, if Starfox 64 had three levels",
	"Original* Soundtrack By David Miller                         *stolen",
	"Call of Duty: Black Ops III",
	"Backgammon",
	"3D Pinball",
	"As fun as watching paint explode"
}

local titlestring = titles[math.random(#titles)]

function love.conf(t)
	t.version = "0.9.2"
	t.window.title = titlestring

	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"

	t.window.width = 800
    t.window.height = 600
	t.window.resizable = false

	t.window.vsync = true
	t.console = true		--for testing
end
