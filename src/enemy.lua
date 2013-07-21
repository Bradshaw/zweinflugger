local enemy_mt = {}
enemy = {}
enemy.all = {}

function enemy.new(x, y)
	local self = setmetatable({},{__index=enemy_mt})
	self.x = x or -xsize+math.random(xsize*3)
	self.y = y or -10
	self.dx = 0
	self.dy = 0
	self.acc = 1
	self.fric = 1
	self.radius = 5
	self.time = math.random()*math.pi
	self.oscillate = 1+math.random()/2
	self.movetarget = {x = math.random(xsize), y = math.random(2*ysize/3)}
	self.mybullets = {}
	self.cooldown = 0.05
	self.shoottime = self.cooldown
	return self
end

function enemy.spawn( ... )
	if #enemy.all<= global.MAXENEMIES then
		table.insert(enemy.all,enemy.new( ... ))
	end
end

function enemy.update(dt)
	local i = 1
	while i<=#enemy.all do
		local v = enemy.all[i]
		if v.purge then
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
				v.purge = true
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
		end
	end
	if self.shoottime<=0 then
		self.shoottime = self.cooldown
		local d = (math.pi/2) + math.sin(self.time*self.oscillate)
		table.insert(self.mybullets, bullet.new(self.x,self.y,math.cos(d)*200,math.sin(d)*200))
	end
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
	love.graphics.circle("fill",self.x,self.y,4)
end