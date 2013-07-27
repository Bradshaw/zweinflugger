require("input")
require("bullet")
local player_mt = {}
player = {}
player.all = {}
player.WAITING = 0
player.FIGHTING = 1
player.DEAD = 2



player.img = {}
player.img.ship = love.graphics.newImage("images/Ship.png")
player.img.ship1 = love.graphics.newImage("images/Ship1.png")
player.img.ship2 = love.graphics.newImage("images/Ship2.png")
player.img.shipmask = love.graphics.newImage("images/ShipMask.png")
player.img.oneshot = love.graphics.newImage("images/p1shot.png")
player.img.twoshot = love.graphics.newImage("images/p2shot.png")
player.img.flam = love.graphics.newImage("images/flam.png")
player.img.shield = love.graphics.newImage("images/shield.png")

player.bull = bullet.proto()
player.bull.dx = 0
player.bull.dy = -400
player.bull.target = "enemy"
player.bull.radius = 7

player.explosnd = love.audio.newSource("audio/Explosion2.ogg")
player.explosnd:setVolume(0.5)

player.alertsnd = love.audio.newSource("audio/woah.ogg")
player.alertsnd:setPitch(-1)
player.alertsnd:setVolume(0.2)

function player.bull:draw()
	if self.firedby.number == 1 then
		love.graphics.draw(player.img.oneshot,self.x-3,self.y-3)
	else
		love.graphics.draw(player.img.twoshot,self.x-3,self.y-3)
	end
end

function player.new(controlscheme, name, number)
	local self = setmetatable({},{__index=player_mt})
	self.startoff = 200
	self.img = player.img.ship
	self.number = number or #player.all+1
	self.name = name or "Player "..self.number
	self.snd = love.audio.newSource("audio/thud.ogg")
	self.snd:setVolume(0.1)
	self.x = 100
	self.y = 300
	self.score = 0
	self.speed = 100
	self.cooldown = 0.1
	self.timesince = 0
	self.input = controlscheme or input.DEFAULTP1
	self.state = player.FIGHTING
	self.damaged = 2
	self.hitpoints = 2
	self.streak = 0
	self.smoke = 0.25+math.random()/4
	self.shieldrnd = math.random()*math.pi
	table.insert(player.all, self)
	flashy.add(self)
	return self
end

function player.update(dt)
	local bothdeath = true
	for i,v in ipairs(player.all) do
		v:update(dt)
	end
	if p1.state==player.DEAD and p2.state==player.DEAD then
		gstate.switch(gameover)
	end
end

function player.draw()
	for i,v in ipairs(player.all) do
		v:draw()
	end
end

function player_mt:update(dt)
	self.startoff = self.startoff-self.startoff*dt
	if self.state == player.FIGHTING then
		if self.streak>10 and self.hitpoints<2 then
			self.hitpoints = 2
		end
		self.smoke = self.smoke - dt
		if self.smoke<=0 then
			self.smoke = 0.25+math.random()/4
			splod.jetsmoke(self.x,self.y+20+self.startoff)
		end
		self.damaged = math.max(0,self.damaged-dt)
		self.x = math.max(2,math.min(xsize-2,self.x+self.input:dx()*dt*self.speed))
		self.y = math.max(2,math.min(ysize-2,self.y+self.input:dy()*dt*self.speed))

		self.timesince = math.max(0,self.timesince-dt)
		if self.timesince<=0 and (true or self.input:attack()) and self.startoff<20 and self.damaged==0 then
			if self.number == 1 or p1.state == player.DEAD or p1.damaged~=0 then
				self.snd:stop()
				self.snd:rewind()
				self.snd:play()
			end
			self.timesince = self.cooldown
			local b = bullet.new(player.bull, self.x, self.y+self.startoff)
			b.firedby = self
		end
		for i,v in ipairs(bullet.all) do
			if v.target=="player" then
				local r2 = v.radius*v.radius
				local dx = self.x-v.x
				local dy = self.y-v.y
				local d2 = (dx*dx+dy*dy)
				if d2<r2 and self.damaged<=0 then
					player.explosnd:stop()
					player.explosnd:rewind()
					player.explosnd:play()
					for i=1,3 do
						splod.fire(self.x,self.y+self.startoff)
					end
					for i=1,3 do
						splod.greysmoke(self.x,self.y+self.startoff)
					end
					v.purge = true
					self.hitpoints = self.hitpoints-1
					self.damaged = 1
					self.streak = 0
					if self.hitpoints<= 0 then
						self.state = player.DEAD
						self.damaged = 5
						throwtext("SURVIVE!")
					end
				end
			end
		end
	elseif self.state == player.DEAD then
		self.damaged = self.damaged-dt
		if self.damaged<=0 then
			self.state = player.FIGHTING
			self.damaged = 2
			self.x = 100
			self.y = 300
			self.startoff = 200
			self.hitpoints = 1
		end
		if player.alertsnd:isStopped() then
			player.alertsnd:play()
		end
	end
end

function player_mt:draw()
	if self.state~=player.DEAD then
		love.graphics.draw(self.img,self.x-3,self.y-6+self.startoff)
		if self.damaged>0 then
			if (gtime*10 - math.floor(gtime*10))>0.5 then
				love.graphics.draw(player.img.shipmask,self.x-3,self.y-6+self.startoff)
			end
		end
		local sc = 0.5+math.random()/3
		local fcol = math.random(127,255)
		if self.damaged>0 and (gtime*10 - math.floor(gtime*10))>0.5 then
			love.graphics.setColor(255,255,255)
		else
			if self.number == 1 then
				love.graphics.setColor(255,fcol/2,fcol/8)
			else
				love.graphics.setColor(fcol/2,fcol/2,255)
			end
		end	
		love.graphics.draw(player.img.flam,self.x,self.y+7+self.startoff,0,sc,sc,5.5+math.random(),0)
		sc = 0.75*math.random()
		love.graphics.setColor(255,255,255)
		love.graphics.draw(player.img.flam,self.x,self.y+8+self.startoff,0,sc,sc,6,0)
		if self.hitpoints==2 then
			love.graphics.setColor(255,255,255,128+64*math.sin(gtime*8+self.shieldrnd))
			love.graphics.setBlendMode("additive")
			love.graphics.draw(player.img.shield,self.x,self.y+self.startoff,gtime+self.shieldrnd*3,1+math.sin(self.shieldrnd+gtime*3)*0.1,1+math.sin(self.shieldrnd+gtime*5)*0.1,7.5,8)
			love.graphics.setColor(255,255,255)
			love.graphics.setBlendMode("alpha")
		end

	else
		love.graphics.setColor(255,255,255)
		if (gtime*10 - math.floor(gtime*10))>0.5 then
			love.graphics.rectangle("line",1,1,xsize-2,ysize-2)
		end
	end
end

function player_mt:flash()
end