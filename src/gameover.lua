local state = gstate.new()


function state:init()
end


function state:enter()
	global.ENEMYTIME = 0.5
	killen = 0
	throwtext("Game over")
	cooltorestart = 2
	musicspd = 1
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
	if key=="return" then
		gstate.switch(intro)
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	p1.x = p1.x+(xsize/4-p1.x)*dt
	p2.x = p2.x+(3*xsize/4-p2.x)*dt
	p1.y = p1.y+((ysize/3) * 2-p1.y)*dt
	p2.y = p2.y+((ysize/3) * 2-p2.y)*dt
	musicspd = math.max(0,musicspd - dt*0.25)
	music:setPitch(musicspd)
	cooltorestart = math.max(cooltorestart-dt,0)
	disptime = math.min(2,disptime+dt/1)
	local dt = dt*math.max(musicspd,0.1)
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
	love.graphics.print(text,xsize/2-textoff,ysize/2-(math.pow(disptime,2))*ysize/2-20,0,3,3)
	love.graphics.draw(titleim, xsize/2-titleim:getWidth()/2 ,(ysize/2-100)*disptime/2)
	love.graphics.print("Score: "..(p1.score+p2.score),20,ysize/2,0,2,2)
	love.graphics.print(p1.name..": "..(p1.score),20,ysize/2+25,0,2,2)
	love.graphics.print(p2.name..": "..(p2.score),20,ysize/2+50,0,2,2)

	love.graphics.print("[ENTER] to restart",xsize/2-font:getWidth("[ENTER] to restart")/2,ysize/2+120,0,1,1)
	--flashy.draw()
end

return state