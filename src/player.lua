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
player.img.shipmask = love.graphics.newImage("images/ShipMask.png")
player.img.twoshot = love.graphics.newImage("images/p2shot.png")
player.img.flam = love.graphics.newImage("images/flam.png")

player.bull = bullet.proto()
player.bull.dx = 0
player.bull.dy = -400
player.bull.target = "enemy"
player.bull.radius = 7
function player.bull:draw()
	love.graphics.draw(player.img.twoshot,self.x-3,self.y-3)
end

function player.new(controlscheme, name, number)
	local self = setmetatable({},{__index=player_mt})
	self.number = number or #player.all+1
	self.name = name or "Player "..self.number
	self.x = 100
	self.y = 300
	self.speed = 100
	self.cooldown = 0.1
	self.timesince = 0
	self.input = controlscheme or input.DEFAULTP1
	self.state = player.FIGHTING
	self.damaged = 2
	self.hitpoints = 3
	self.smoke = 0.25+math.random()/4
	table.insert(player.all, self)
	flashy.add(self)
	return self
end

function player.update(dt)
	for i,v in ipairs(player.all) do
		v:update(dt)
	end
end

function player.draw()
	for i,v in ipairs(player.all) do
		v:draw()
	end
end

function player_mt:update(dt)
	self.smoke = self.smoke - dt
	if self.smoke<=0 then
		self.smoke = 0.25+math.random()/4
		splod.jetsmoke(self.x,self.y+20)
	end
	self.damaged = math.max(0,self.damaged-dt)
	if self.state == player.FIGHTING then
		self.x = math.max(2,math.min(xsize-2,self.x+self.input:dx()*dt*self.speed))
		self.y = math.max(2,math.min(ysize-2,self.y+self.input:dy()*dt*self.speed))

		self.timesince = math.max(0,self.timesince-dt)
		if self.timesince<=0 and (true or self.input:attack()) then
			self.timesince = self.cooldown
			bullet.new(player.bull, self.x, self.y)
		end
		for i,v in ipairs(bullet.all) do
			if v.target=="player" then
				local r2 = v.radius*v.radius
				local dx = self.x-v.x
				local dy = self.y-v.y
				local d2 = (dx*dx+dy*dy)
				if d2<r2 and self.damaged<=0 then
					for i=1,3 do
						splod.fire(self.x,self.y)
					end
					for i=1,3 do
						splod.greysmoke(self.x,self.y)
					end
					v.purge = true
					self.hitpoints = self.hitpoints-1
					self.damaged = 1
					if self.hitpoints<= 0 then
						self.state = player.DEAD
					end
				end
			end
		end
	end
end

function player_mt:draw()
	if self.state~=player.DEAD then
		love.graphics.draw(player.img.ship,self.x-3,self.y-3)
		if self.damaged>0 then
			if (gtime*10 - math.floor(gtime*10))>0.5 then
				love.graphics.draw(player.img.shipmask,self.x-3,self.y-3)
			end
		end
		local sc = 0.5+math.random()/3
		local fcol = math.random(127,255)
		if self.damaged>0 and (gtime*10 - math.floor(gtime*10))>0.5 then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(255,fcol/2,fcol/8)
		end	
		love.graphics.draw(player.img.flam,self.x,self.y+7,0,sc,sc,5.5+math.random(),0)
		sc = 0.75*math.random()/2
		love.graphics.setColor(255,255,255)
		love.graphics.draw(player.img.flam,self.x,self.y+8,0,sc,sc,6,0)

	else
		--love.graphics.rectangle("line",self.x-3,self.y-3,6,6)
	end
end

function player_mt:flash()
end