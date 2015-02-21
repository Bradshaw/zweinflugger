local enemy_mt = {}
enemy = {}
enemy.all = {}
enemy.img = {}
enemy.img[1] = love.graphics.newImage("images/enemy.png")
enemy.img[2] = love.graphics.newImage("images/enemy2.png")
enemy.img[3] = love.graphics.newImage("images/enemy3.png")
enemy.tur = love.graphics.newImage("images/turret.png")
enemy.bullim = {}
enemy.bullim.aim = love.graphics.newImage("images/aim.png")
enemy.bullim.aimbatch = love.graphics.newSpriteBatch(enemy.bullim.aim)
enemy.bullim.sin = love.graphics.newImage("images/sin.png")
enemy.bullim.sinbatch = love.graphics.newSpriteBatch(enemy.bullim.sin)
enemy.bullim.scatter = love.graphics.newImage("images/scatter.png")
enemy.bullim.scatterbatch = love.graphics.newSpriteBatch(enemy.bullim.scatter)
enemy.bullsnd = {}
enemy.bullsnd.aim = love.audio.newSource("audio/Laser_Shoot3.ogg")
enemy.bullsnd.aim:setPitch(1.5)
enemy.bullsnd.aim:setVolume(1)
enemy.bullsnd.scatter = love.audio.newSource("audio/pew.ogg")
enemy.bullsnd.scatter:setPitch(0.5)
enemy.bullsnd.scatter:setVolume(0.4)
enemy.bullsnd.sin = love.audio.newSource("audio/sinshot.ogg")
enemy.bullsnd.sin:setPitch(1)
enemy.bullsnd.sin:setVolume(0.7)
enemy.hitsnd = love.audio.newSource("audio/Explosion4.ogg")
enemy.hitsnd:setVolume(0.4)

function enemy.new(x, y)
	local self = setmetatable({},{__index=enemy_mt})
	self.x = x or -10+math.random(0,xsize+20)
	self.y = y or -10
	self.dx = 0
	self.dy = 0
	self.acc = 1
	self.hitpoints = 3
	self.fric = 1
	self.radius = 5
	self.time = math.random()*math.pi
	self.oscillate = 1+math.random()/2
	self.movetarget = {x = math.random(xsize), y = math.random(2*ysize/3)}
	self.mybullets = {}
	self.cooldown = 1
	self.shoottime = self.cooldown
	self.lastang = (math.pi/2)
	self.doShoot = self.scattershoot
	return self
end

function enemy.randomtype(...)
	if #enemy.all<= global.MAXENEMIES then
		local e = enemy.new( ... )
		local ss = math.random(1,#enemy.shootstyles)
		e.doShoot = enemy.shootstyles[ss]
		e.img = enemy.img[ss]
		table.insert(enemy.all,e)
	end
end

function enemy.spawn( ... )
	if #enemy.all<= global.MAXENEMIES then
		table.insert(enemy.all,enemy.new( ... ))
	end
end

function enemy.update(dt)
	enemy.bullim.aimbatch:clear()
	enemy.bullim.sinbatch:clear()
	enemy.bullim.scatterbatch:clear()
	local i = 1
	while i<=#enemy.all do
		local v = enemy.all[i]
		if v.purge then
			shake = math.min(1,shake+0.1)
			for _,b in ipairs(v.mybullets) do
				b.shotby = v.shotby
				b.purge = true
			end
			table.remove(enemy.all,i)
		else
			v:update(dt)
			i=i+1
		end
	end
	
end

function enemy.draw()
	for i,v in ipairs(enemy.all) do
		v:draw()
	end
end

function bdraw(self)
	self.bim:add(self.x,self.y,0,1,1,self.bim:getImage():getWidth(),self.bim:getImage():getHeight())
end

function enemy_mt:aimshoot()
	self.cooldown = 0.75/shotdiff
	if self.shoottime<=0 then
		self.snd = self.snd or enemy.bullsnd.aim
		if self.x>0 and self.y>0 and self.x<xsize and self.y<ysize then
			self.snd:stop()
			self.snd:rewind()
			self.snd:play()
		end
		self.target = self.target or player.all[math.random(1,#player.all)]
		self.shoottime = self.cooldown
		local dx = self.target.x-self.x
		local dy = self.target.y-self.y
		local d = math.sqrt(dx*dx+dy*dy)
		local nx = dx/d
		local ny = dy/d
		b = bullet.new(self.x,self.y,nx*75*shotdiff,ny*75*shotdiff)
		b.worth = 5
		b.radius = 6
		b.draw = bdraw
		b.bim = enemy.bullim.aimbatch
		table.insert(self.mybullets, b)
		lastang = math.atan2(dy,dx)
	end
end

function enemy_mt:scattershoot()
	self.cooldown = 0.75/shotdiff
	if self.shoottime<=0 then
		self.snd = self.snd or enemy.bullsnd.scatter
		if self.x>0 and self.y>0 and self.x<xsize and self.y<ysize then
			self.snd:stop()
			self.snd:rewind()
			self.snd:play()
		end
		self.target = self.target or player.all[math.random(1,#player.all)]
		self.shoottime = self.cooldown
		local d = (math.pi/2) + (math.random()*2-1)*math.pi/4
		for i=1,5 do
			local ld = d+(math.random()*2-1)/20
			local rspeed = 50*(0.8+math.random()*0.4)
			local b = bullet.new(self.x,self.y,math.cos(ld)*rspeed*shotdiff,math.sin(ld)*rspeed*shotdiff)
			b.worth = 1
			b.radius = 1.5
			b.draw = bdraw
			b.bim = enemy.bullim.scatterbatch
			table.insert(self.mybullets, b)
		end
		self.lastang = d
	end
end

function enemy_mt:sinshoot()
	self.cooldown = 0.2/shotdiff
	if self.shoottime<=0 then
		self.snd = self.snd or enemy.bullsnd.sin
		if self.x>0 and self.y>0 and self.x<xsize and self.y<ysize then
			self.snd:stop()
			self.snd:rewind()
			self.snd:play()
		end
		self.shoottime = self.cooldown
		local d = (math.pi/2) + math.sin(self.time*self.oscillate)
		local b = bullet.new(self.x,self.y,math.cos(d)*100*shotdiff,math.sin(d)*100*shotdiff)
		b.worth = 1
		b.radius = 3
		b.draw = bdraw
		b.bim = enemy.bullim.sinbatch
		table.insert(self.mybullets, b)
		self.lastang = d
	end
end

enemy.shootstyles = {
	enemy_mt.scattershoot,
	enemy_mt.aimshoot,
	enemy_mt.sinshoot
}

function enemy_mt:die(shooter)
	self.shotby = shooter
	if true or enemy.hitsnd:isStopped() then
		enemy.hitsnd:setPitch(0.9+math.random()*0.2)
		enemy.hitsnd:stop()
		enemy.hitsnd:rewind()
		enemy.hitsnd:play()
	end
	self.purge=true
	for i=1,3 do
		splod.fire(self.x,self.y)
	end
	for i=1,3 do
		splod.greysmoke(self.x,self.y)
	end
	for i,v in ipairs(self.mybullets) do
		--v.purge = true
	end
end

function enemy_mt:update(dt)
	self.time = self.time+dt
	self.shoottime = math.max(0,self.shoottime-dt)
	for i,v in ipairs(bullet.all) do
		if v.target=="enemy" then
			local r2 = v.radius*v.radius
			local dx = self.x-v.x
			local dy = self.y-v.y
			local d2 = (dx*dx+dy*dy)
			local d = math.sqrt(d2)
			if d<v.radius+self.radius then
				global.ENEMYTIME = (global.ENEMYTIME*99 + 1)/100
				--print(global.ENEMYTIME)
				v.purge = true
				self.hitpoints = self.hitpoints-1
				for i=1,3 do
					splod.fire(self.x,self.y)
				end
				if self.hitpoints<=0 then
					v.firedby.streak = v.firedby.streak+1
					--v.firedby.score = v.firedby.score + math.pow(math.floor(v.firedby.streak*global.ENEMYTIME+1),2)
					self:die(v.firedby)
				end
			end
		end
	end
	self:doShoot()
	local dx = self.movetarget.x - self.x
	local dy = self.movetarget.y - self.y
	self.dx = self.dx - self.dx*self.fric*dt
	self.dy = self.dy - self.dy*self.fric*dt
	self.dx = self.dx + dx * dt * self.acc
	self.dy = self.dy + dy * dt * self.acc
	self.x = self.x+self.dx * dt
	self.y = self.y+self.dy * dt
	if math.abs(dx)<10 and math.abs(dy)<10 then
		self.movetarget = {x = math.random(xsize), y = math.random(2*ysize/3)}
	end
end

function enemy_mt:draw()
	love.graphics.draw(self.img,self.x,self.y,0,1,1,self.img:getWidth()/2,self.img:getHeight()/2)
	--love.graphics.draw(enemy.tur,self.x,self.y,self.lastang,1,1,5,enemy.tur:getHeight()/2)
end