require("val")

--[[ SHAPE ]]
--main
function Shape.A()
	if mDown[1][2] and not Shape.move then
		if kDown[2][2] and shape[1]~=nil then
			Shape.move=true
		else
			shape[#shape+1]={ms.getX()+cam[1],ms.getY()+cam[2]}
			Shape.move=true
		end
	end
	if not mDown[1][2] and Shape.move then
		Shape.move=false
	end
	
	if Shape.move then shape[#shape]={ms.getX()+cam[1],ms.getY()+cam[2]} end
	
	if mDown[2][2] and not mDown[1][2] then
		if #shape>2 and not Shape.Isect() then
			table.insert(shapes,shape)
			shape={}
		end
		if #shape<3 and #shape~=0 then
			Alert.Add("Shape must have at least 3 points to be added","E")
		end
	end
end

--intersection check
function Shape.Isect() --It just works
	Isected=false
	if #shape>3 then
		for i,v in pairs(shape) do
			if i~=#shape then
				Isected=Shape.Intersect(shape[#shape],shape[#shape-1],shape[i],shape[i+1])
				if Isected then break end
				Isected=Shape.Intersect(shape[1],shape[#shape],shape[i],shape[i+1])
				if Isected then break end
			end
		end
	end
	if Isected then Alert.Add("Shape intersects itself","E") end
	return Isected
end
function Shape.CCW(A,B,C)
	return (C[2]-A[2])*(B[1]-A[1]) > (B[2]-A[2])*(C[1]-A[1])
end
function Shape.Intersect(A,B,C,D)
	return Shape.CCW(A,C,D) ~= Shape.CCW(B,C,D) and Shape.CCW(A,B,C) ~= Shape.CCW(A,B,D)
end

--[[
https://bryceboe.com/2006/10/23/line-segment-intersection-algorithm/

def ccw(A,B,C):
    return (C.y-A.y)*(B.x-A.x) > (B.y-A.y)*(C.x-A.x)
	
def intersect(A,B,C,D):
    return ccw(A,C,D) != ccw(B,C,D) and ccw(A,B,C) != ccw(A,B,D)
]]

function Shape.Draw()
	grap.setColor(1,0,0,1)
	for i,v in pairs(shape) do
		grap.circle("fill",v[1]-cam[1],v[2]-cam[2],2)
		if #shape~=1 then
			if i~=#shape then
				grap.line(v[1]-cam[1],v[2]-cam[2],shape[i+1][1]-cam[1],shape[i+1][2]-cam[2])
			else
				grap.line(v[1]-cam[1],v[2]-cam[2],shape[1][1]-cam[1],shape[1][2]-cam[2])
			end
		end
	end
	
	grap.setColor(0,0,0,1)
	for i,v in pairs(shapes) do
		for o,b in pairs(v) do
			if o~=#v then
				grap.line(b[1]-cam[1],b[2]-cam[2],v[o+1][1]-cam[1],v[o+1][2]-cam[2])
			else
				grap.line(b[1]-cam[1],b[2]-cam[2],v[1][1]-cam[1],v[1][2]-cam[2])
			end
		end
	end
end

--[[ Alert ]]
--main
function Alert.A(dt)
	Alert.tm=Alert.tm+dt
	for i,v in pairs(alert) do
		v[3]=v[3]+dt
		if v[3]>5 then
			v[4]=v[4]+dt
			if v[4]>1 then
				table.remove(alert,i)
			end
		end
	end
end

function Alert.Add(txt,tp) --text, type
	if Alert.tm>0.5 then
		if tp=="E" then Alert.errSnd:play() end
		table.insert(alert,{txt,tp,0,0}) --text, type, time, deleteTime
		Alert.tm=0
	end
end

function Alert.Draw()
	for i,v in pairs(alert) do
		if v[2]=="E" then
			grap.setColor(1,0,0,0.25)
		end
		grap.rectangle("fill",grap.getWidth()-240,-20+40*i,228,36)
		grap.setColor(0,0,0,1)
		grap.rectangle("line",grap.getWidth()-240,-20+40*i,228,36)
		grap.printf(v[1],grap.getWidth()-232,-16+40*i,212,"left")
	end
end

--[[ INPUT ]]
function Input(dt)
	if kb.isDown("w") then
		cam[2]=cam[2]-cam.spd*dt
	end
	if kb.isDown("s") then
		cam[2]=cam[2]+cam.spd*dt
	end
	if kb.isDown("d") then
		cam[1]=cam[1]+cam.spd*dt
	end
	if kb.isDown("a") then
		cam[1]=cam[1]-cam.spd*dt
	end
	if kDown[2][2] then cam.spd=300 else cam.spd=50 end
end

--MOUSE
function love.mousepressed(x,y,but)
	mDown[but][2]=true
end
function love.mousereleased(x,y,but)
	mDown[but][2]=false
end

--KEYBOARD
function love.keypressed(k,scode,r)
	--Modifier Keys
	if string.sub(scode,2,5)=="ctrl" then kDown[1][2]=true end
	if string.sub(scode,2,6)=="shift" then kDown[2][2]=true end
	if string.sub(scode,2,4)=="alt" then kDown[3][2]=true end
	
	--[[ Shapes ]]
	if k=="r" then
		if kDown[1][2] then
			shapes={}
		end
		shape={}
	end -- RESET SHAPES
	if k=="z" then
		if #shape>1 then
			table.remove(shape,#shape)
		end
	end
	
	--Other
	if k=="m" and kDown[3][2] then debug[1].A=not debug[1].A end --ENABLE MOUSE DEBUG
	if k=="k" and kDown[3][2] then debug[2].A=not debug[2].A end --ENABLE KEYBOARD DEBUG
	if k=="f" and kDown[1][2] and kDown[2][2] then FPS=not FPS end
end
function love.keyreleased(k,scode)
	--Modifier Keys
	if string.sub(scode,2,5)=="ctrl" then kDown[1][2]=false end
	if string.sub(scode,2,6)=="shift" then kDown[2][2]=false end
	if string.sub(scode,2,4)=="alt" then kDown[3][2]=false end
end

--[[ DEBUG ]]
function Debug()
	rY=0
	rX=0
	for i,v in pairs(debug) do
		if v.A then
			v.func(95*rX,95*rY)
			rY=rY+1
			if rY==3 then rX=rX+1 rY=0 end
		end
	end
end

--MOUSE

function debug.mouse(rX,rY)
	grap.setColor(0,0,0,0.5)
	k=0
	x=5+rX
	y=5+rY
	grap.rectangle("fill",x-2,y-2,110,92)
	grap.setColor(0,1,0,1)
	grap.print("#MOUSE-DEBUG",x,y)
	for i,v in pairs(mDown)do
		grap.print(v[1] .. ": " .. tostring(v[2]),x,y+12*i)
		k=i
	end
	k=k+1
	grap.print("X: " .. ms.getX() .. " Y: " .. ms.getY(),x,y+12*k)
	grap.setColor(1,1,1,1)
end

--KEYBOARD
function debug.keyboard(rX,rY)
	grap.setColor(0,0,0,0.5)
	x=5+rX
	y=5+rY
	grap.rectangle("fill",x-2,y-2,130,55)
	grap.setColor(0,1,0,1)
	grap.print("#KEYBOARD-DEBUG",x,y)
	for i,v in pairs(kDown)do
		grap.print(v[1] .. ": " .. tostring(v[2]),x,y+12*i)
	end
	grap.setColor(1,1,1,1)
end

debug=
{
	{A=false,func=debug.mouse}, --MOUSE
	{A=false,func=debug.keyboard} --KEYBOARD
}