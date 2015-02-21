background = {}
background.img = love.graphics.newImage("images/bg.png")
background.cld = love.graphics.newImage("images/clouds.png")
background.time = 0
background.yoff = 0
background.xoff = 0
background.scrollspeed = 6
background.scale = 2

function background.update(dt)
	background.scale = 2+math.sin(love.timer.getTime()*0.3)*0.1
	background.time = background.time+dt
	background.xoff = background.xoff+dt*background.scrollspeed*math.sin(background.time)/3
	background.yoff = background.yoff+dt*background.scrollspeed
end

function background.draw()
	love.graphics.push()
	love.graphics.translate(xsize/2,ysize/2)
	love.graphics.scale(background.scale)
	love.graphics.rotate(math.sin(background.time/20)/5)
	love.graphics.translate(-xsize/2,-ysize/2)
		local plxoff = (p1.x+p2.x)/2-xsize
		local plyoff = (p1.y+p2.y)/2-ysize
		love.graphics.draw(background.img,((background.xoff-plxoff*0.1)%512)-512,((background.yoff-plyoff*0.1)%512)-512)
		love.graphics.draw(background.img,((background.xoff-plxoff*0.1)%512)-512,((background.yoff-plyoff*0.1)%512))
		love.graphics.draw(background.img,((background.xoff-plxoff*0.1)%512),((background.yoff-plyoff*0.1)%512)-512)
		love.graphics.draw(background.img,(background.xoff-plxoff*0.1)%512,(background.yoff-plyoff*0.1)%512)

		love.graphics.setColor(127,127,127,32)
		love.graphics.draw(background.cld,(-plxoff*0.2%512),((2*background.yoff-plyoff*0.2)%512)-512)
		love.graphics.draw(background.cld,(-plxoff*0.2%512),(2*background.yoff-plyoff*0.2)%512)
		love.graphics.setColor(255,255,255)
	love.graphics.pop()
end