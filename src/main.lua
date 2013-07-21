function init()
global = {
		RATE = 300,
		MAX_DT = 1/30,
		TIMESCALE = 1,
		PLAYERTIME = 0.8,
		ENEMYTIME = 0.5,
		BULLETTIME = 0.7,
		MAXENEMIES = 10
	}
	time = 0
	gtime = 0
	xsize = 200
	ysize = 400
	scale = 2
end

function love.load(arg)
	init()
	fontim = love.graphics.newImage("images/myfont.png")
	fontim:setFilter("nearest","nearest")
	font = love.graphics.newImageFont(fontim,
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%_`'*__[]\"" ..
    "<>&#=$")
	love.graphics.setFont(font)
	titleim = love.graphics.newImage("images/title.png")
	music = love.audio.newSource("audio/tweinflugger.ogg")
	music:setLooping(true)
	love.graphics.setMode( xsize*scale, ysize*scale, false, false, 0 )
	love.graphics.setDefaultImageFilter("nearest","nearest")
	love.graphics.setLine(1,"rough")
	screen = love.graphics.newCanvas(512,512)
	screen:setFilter("nearest","nearest")
	require("input")
	require("background")
	require("splod")
	require("flashy")
	require("player")
	require("enemy")
	require("bullet")
	gstate = require "gamestate"
	game = require("game")
	intro = require("intro")
	gameover = require("gameover")
	gstate.switch(intro)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function keyreleased(key, uni)
	gstate.keyreleased(key)
end

function love.update(dt)
	time = time + math.min(dt, global.MAX_DT)*global.TIMESCALE
	gtime = gtime + math.min(dt, global.MAX_DT)*global.TIMESCALE
	while time>0 do
		time = time-(1/global.RATE)
		gstate.update(1/global.RATE)
	end
end

function love.draw()
	screen:clear()
	love.graphics.setCanvas(screen)
	gstate.draw()
	love.graphics.push()
	love.graphics.setCanvas()
	love.graphics.scale(scale,scale)
	love.graphics.draw(screen)
	love.graphics.pop()
end
