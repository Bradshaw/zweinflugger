local state = gstate.new()


function state:init()
end


function state:enter()
	init()
	disptime = -1
	--throwtext("Go!")
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
	global.ENEMYTIME = 0.5
	killen = 0
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
	if key=="escape" or key=="l" then
		love.event.push("quit")
	end
	if key=="return" or key=="j" or key=="q" or key=="a" or key=="s" or key=="z" then
		gstate.switch(game)
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	disptime = math.min(2,disptime+dt/1)
	background.update(dt)
	splod.update(dt)
	--player.update(dt*global.PLAYERTIME)
	killen = math.max(0,killen-dt)
	enemy.update(dt*global.ENEMYTIME)
	if enemy.all[1] and killen<=0 then
		killen = 0.1+math.random()*0.1
		enemy.all[1]:die()
		enemy.all[1].purge = true
	end
	bullet.update(dt*global.BULLETTIME)
end


function state:draw()
	background.draw()
	splod.draw()
	--player.draw()
	enemy.draw()
	bullet.draw()
	love.graphics.draw(titleim,xsize/2-100, ysize/2-75 +   math.pow(((gtime*3)%2)-1,4)*25)
	love.graphics.print("By Kevin\"Gaeel\" Bradshaw",xsize/2-font:getWidth("By Kevin \"Gaeel\" Bradshaw")/2,ysize/2+50,0,1,1)
	love.graphics.print("Made in 48 hours for",xsize/2-font:getWidth("Made in 48 hours for")/2,ysize/2+65,0,1,1)
	love.graphics.print("Funkyture 2.0",xsize/2-font:getWidth("Funkyture 2.0")/2,ysize/2+80,0,1,1)
	love.graphics.print("For mini-Gaby",xsize/2-font:getWidth("For mini-Gaby")/2,ysize/2+120,0,1,1)
	--flashy.draw()
end

return state