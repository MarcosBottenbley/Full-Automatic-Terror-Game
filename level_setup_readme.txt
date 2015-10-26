Right now the editor's pretty limited.
In the meantime, though, this is the format for our level files.
The level files are stored in the /level directory and the variable "level"
in Game decides which file to read.

Background (set at top of level)
BG:[path of background image]

Objects
[three letter code representing object](x,y,z,w)
where x,y,z,w are all arguments for constructor of object. If
the objects' constructor takes less than four arguments, then fill the rest
in as zero. Again, this is less than ideal and I'm working on it.
The object codes currently are:
pla = Player
pwr = Powerup (double shot)
rep = Health
spd = Speed Up
ogb = GlowBorg (object)
ocb = CircleBorg (object)
ops = PhantomShip (object)
osb = SunBoss (object)
sgb = GlowBorg (spawner)
sps = PhantomShip (spawner)
wrm = Wormhole
odm = DualMaster (object)
sdm = DualMaster (spawner)
frm = Frame (for camera)
wal = Wall (object)

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
