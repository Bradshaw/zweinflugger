local state = gstate.new()


function state:init()

end

function throwtext(t)
	text = t
	textoff = font:getWidth(t)*1.5
	disptime = -1
end

function drawtext()
	
end

function state:enter()
	init()
	disptime = -1
	throwtext("Go!")
	player.all = {}
	enemy.all = {}
	bullet.all = {}
	p1 = player.new(input.DEFAULTP2)
	p1.img = player.img.ship1
	p1.x = xsize/4
	p2 = player.new(input.DEFAULTP1)
	p2.img = player.img.ship2
	p2.x = 3*xsize/4
	for i=1,3 do
		--enemy.spawn()
	end
	spawncool = 1
	spawntime = 2
	music:play()
end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	disptime = math.min(2,disptime+dt/1)
	background.update(dt)
	spawntime = math.max(0,spawntime-dt)
	if spawntime<=0 then
		for i=1,3 do
			enemy.randomtype()
		end
		spawntime = spawncool/global.ENEMYTIME
	end
	splod.update(dt)
	player.update(dt*global.PLAYERTIME)
	enemy.update(dt*global.ENEMYTIME)
	bullet.update(dt*global.BULLETTIME)
end


function state:draw()
	background.draw()
	splod.draw()
	player.draw()
	enemy.draw()
	bullet.draw()
	love.graphics.print(text,xsize/2-textoff,ysize/2-(math.pow(disptime,2))*ysize/2,0,3,3)
	local p1s = "P1:"..p1.score
	local p2s = "P2:"..p2.score
	love.graphics.print(p1s,3,ysize-12,0,1,1)
	love.graphics.print(p2s,xsize-3-font:getWidth(p2s),ysize-12,0,1,1)
	--flashy.draw()
end

return state