--[[
Created: 22.9.2022
Wene
]]

require("func")
require("val")

function love.load()
	
end

function love.update(Dt)
	Input(Dt)
	Shape.A()
	Alert.A(Dt)
end

function love.draw()
	grap.setBackgroundColor(1,1,1,1)
	Shape.Draw()
	Alert.Draw()
	--debug
	Debug()
	if FPS then
		grap.setColor(0,0,0,1)
		grap.rectangle("fill",grap.getWidth()-40,grap.getHeight()-20,40,20)
		grap.setColor(1,1,1,1)
		grap.printf(tostring(love.timer.getFPS()),grap.getWidth()-40,grap.getHeight()-16,40,"center")
		grap.setColor(1,1,1,1)
	end
	grap.print(math.ceil(cam[1]) .. ", " .. math.ceil(cam[2]))
end
