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
	shotdiff = 0.75
	shake = 0
	disptime = -1
	throwtext("Go!")
	player.all = {}
	enemy.all = {}
	bullet.all = {}
	points.all = {}
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
	shotdiff = shotdiff+dt/240
	shake = math.max(0,shake - dt*5)
	disptime = math.min(2,disptime+dt/1)
	background.update(dt)
	spawntime = math.max(0,spawntime-dt)
	if spawntime<=0 then
		for i=1,3 do
			enemy.randomtype()
		end
		spawntime = spawncool/global.ENEMYTIME
	end
	points.update(dt)
	splod.update(dt)
	player.update(dt*global.PLAYERTIME)
	enemy.update(dt*global.ENEMYTIME)
	bullet.update(dt*global.BULLETTIME)
end

function lerp(a,b,n)
	return b*n+a*(1-n)
end

function state:draw()
	love.graphics.push()
	local plxoff = (p1.x+p2.x)/2-xsize/2
	local plyoff = (p1.y+p2.y)/2-ysize/2
	love.graphics.translate(-plxoff*0.1,-plyoff*0.1)
	love.graphics.translate(math.sin(love.timer.getTime()*60)*shake*20,math.cos(love.timer.getTime()*63)*shake*20)
	background.draw()
	points.draw()
	if p1.state == player.DEAD then
		love.graphics.setBlendMode("additive")
		for i=1,3 do
			love.graphics.setColor(255,255,255,math.random(0,127))
			local a = math.random()*math.pi*2
			local d = math.random()*5
			local a2 = math.random()*math.pi*2
			local d2 = math.random()*7
			local l = math.random()
			if i==1 and math.random()>0.8 then
				splod.magic(lerp(p1.x,p2.x,l)+math.cos(a2)*d2,lerp(p1.y,p2.y,l)+math.sin(a2)*d2,p1)
			end
			love.graphics.line(p1.x+math.cos(a)*d,p1.y+math.sin(a)*d,
				 lerp(p1.x,p2.x,l)+math.cos(a2)*d2,lerp(p1.y,p2.y,l)+math.sin(a2)*d2,
				 p2.x,p2.y)
		end
		love.graphics.setBlendMode("alpha")
	elseif p2.state == player.DEAD then
		love.graphics.setBlendMode("additive")
		for i=1,3 do
			love.graphics.setColor(255,255,255,math.random(0,127))
			local a = math.random()*math.pi*2
			local d = math.random()*5
			local a2 = math.random()*math.pi*2
			local d2 = math.random()*7
			local l = math.random()
			if i==1 and math.random()>0.8 then
				splod.magic(lerp(p1.x,p2.x,l)+math.cos(a2)*d2,lerp(p1.y,p2.y,l)+math.sin(a2)*d2,p2)
			end
			love.graphics.line(p1.x,p1.y,
				lerp(p1.x,p2.x,l)+math.cos(a2)*d2,lerp(p1.y,p2.y,l)+math.sin(a2)*d2,
				p2.x+math.cos(a)*d,p2.y+math.sin(a)*d)
		end
		love.graphics.setBlendMode("alpha")
	end
	love.graphics.setColor(255,255,255)
	splod.draw()
	player.draw()
	bullet.draw()
	enemy.draw()
	love.graphics.pop()
	love.graphics.setColor(255,255,255)

	if p1.state == player.DEAD or p2.state == player.DEAD then
		love.graphics.setColor(255,255,255)
		if (gtime*10 - math.floor(gtime*10))>0.5 then
			love.graphics.rectangle("line",1,1,xsize-1,ysize-1)
		end
	end
	love.graphics.print(text,xsize/2-textoff,ysize/2-(math.pow(disptime,2))*ysize/2,0,3,3)
	local p1s = "P1:"..p1.score
	local p2s = "P2:"..p2.score
	love.graphics.print(p1s,3,ysize-12,0,1,1)
	love.graphics.print(p2s,xsize-3-font:getWidth(p2s),ysize-12,0,1,1)
end

return state