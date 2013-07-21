local state = gstate.new()


function state:init()
		player.new(input.DEFAULTP1)
		player.new(input.DEFAULTP2)
		for i=1,3 do
			--enemy.spawn()
		end
		spawncool = 2
		spawntime = 2

end


function state:enter()

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
	background.update(dt)
	spawntime = math.max(0,spawntime-dt)
	if spawntime<=0 then
		for i=1,3 do
			enemy.spawn()
		end
		spawntime = spawncool
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
	--flashy.draw()
end

return state