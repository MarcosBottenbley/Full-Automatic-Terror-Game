Right now the editor's pretty limited.
I'm not sure how to read out of a file that isn't in the save directory, 
so I have the game create the level0 file if it doesn't exist using a 
hardcoded string. This sort of defeats the whole purpose, though, and makes
it even harder to actually design levels. I'll work on fixing it.

In the meantime, though, this is the format for our level files.

Background (set at top of level)
BG:[path of background image]

Objects
[three letter code representing object](x,y,z,w) 
where x,y,z,w are all arguments for constructor of object. If
the objects' constructor takes less than four arguments, then fill the rest
in as zero. Again, this is less than ideal and I'm working on it.
The object codes currently are:
pla = Player
pwr = Powerup
ogb = GlowBorg (object)
ops = PhantomShip (object)
sgb = GlowBorg (spawner)
sps = PhantomShip (spawner)


Here's our "level zero" file for an example:

BG:gfx/large_bg.png
pla(1000,1000,0,0)
pwr(950,950,0,0)
sgb(200,400,300,0)
sps(1200,1200,100,0)
sgb(500,1000,300,0)
sps(1000,200,300,0)
sgb(1200,1600,300,0)
sgb(100,1600,300,0)
ogb(100,100,0,0)