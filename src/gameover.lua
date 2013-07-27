local state = gstate.new()


function state:init()
end


function state:enter()
	global.ENEMYTIME = 0.5
	killen = 0
	throwtext("Game over")
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
	love.graphics.print(text,xsize/2-textoff,ysize/2-(math.pow(disptime,2))*ysize/2-20,0,3,3)
	love.graphics.draw(titleim,0,(ysize/2-100)*disptime/2)
	love.graphics.print("Score: "..(p1.score+p2.score),20,ysize/2,0,2,2)
	love.graphics.print(p1.name..": "..(p1.score),20,ysize/2+25,0,2,2)
	love.graphics.print(p2.name..": "..(p2.score),20,ysize/2+50,0,2,2)
	--flashy.draw()
end

return state