background = {}
background.img = love.graphics.newImage("images/bg.png")
background.cld = love.graphics.newImage("images/clouds.png")
background.time = 0
background.yoff = 0
background.xoff = 0
background.scrollspeed = 6
background.scale = 2

function background.update(dt)
	background.time = background.time+dt
	background.xoff = background.xoff+dt*background.scrollspeed*math.sin(background.time)/3
	background.yoff = background.yoff+dt*background.scrollspeed
end

function background.draw()
	love.graphics.push()
	love.graphics.scale(background.scale)
	love.graphics.translate(xsize/4,ysize/4)
	love.graphics.rotate(math.sin(background.time/20)/5)
		love.graphics.draw(background.img,(background.xoff%512)-512,(background.yoff%512)-512)
		love.graphics.draw(background.img,(background.xoff%512)-512,(background.yoff%512))
		love.graphics.draw(background.img,(background.xoff%512),(background.yoff%512)-512)
		love.graphics.draw(background.img,background.xoff%512,background.yoff%512)

		love.graphics.setColor(127,127,127,64)
		love.graphics.draw(background.cld,0,((2*background.yoff)%512)-512)
		love.graphics.draw(background.cld,0,(2*background.yoff)%512)
		love.graphics.setColor(255,255,255)
	love.graphics.pop()
end