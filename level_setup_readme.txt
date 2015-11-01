Right now the editor's pretty limited.
In the meantime, though, this is the format for our level files.
The level files are stored in the /level directory and the variable "level"
in Game decides which file to read.

Background (set at top of level)
BG:[path of background image]

Objects
[three letter code representing object](x1,x2,x3,x4,...)
where x,y,z,w are all arguments for constructor of object. If
the objects' constructor takes less than four arguments, then fill the rest
in as zero. Again, this is less than ideal and I'm working on it.

Ok i worked on it, right now you can put in as many or as few arguments as you want,
just don't put in something that doesn't make sense or the game will probably crash.


The object codes currently are:
pla(x,y) = Player
pwr(x,y) = Powerup (double shot)
rep(x,y) = Health
spd(x,y) = Speed Up
ogb(x,y) = GlowBorg (object)
ocb(x,y) = CircleBorg (object)
ops(x,y) = PhantomShip (object)
osb(x,y) = SunBoss (object)
sgb(x,y,pr,r,sr,sl) = GlowBorg (spawner)
sps(x,y,pr,r,sr,sl) = PhantomShip (spawner)
wrm(x,y) = Wormhole
odm(x,y) = DualMaster (object)
sdm(x,y,pr,r,sr,sl) = DualMaster (spawner)
frm(x,y) = Frame (for camera)
wal(x,y,w,h) = Wall (object)

x,y = object coordinates
w,l = width/height of wall
pr = radius around spawn the player has to enter to trigger spawning 
(if 0, spawns at constant rate)
r = radius to spawn enemies around (this is probably going to get changed)
sr = spawn rate (time between spawns)
sl = spawn limit (how many spawns before the spawner shuts off)