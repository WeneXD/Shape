grap = love.graphics
kb = love.keyboard
ms = love.mouse
--Input
mDown={
{"L",false},
{"R",false},
{"M",false},
{"B",false},
{"F",false}
}
kDown={
{"CTRL",false},
{"SHIFT",false},
{"ALT",false}
}

--Other
FPS=false
cam={0,0,spd=50}

--Shape
shapes={}
shape={}
Shape=
{
move=false,
sMove=false,
sM={0,0,0,0},
sMShape={}
}

--Alerts
alert={}
Alert=
{
tm=0,
errSnd=love.audio.newSource("Sounds/ERROR.wav","static")
}