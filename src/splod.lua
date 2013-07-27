local splod_mt = {}
splod = {}
splod.all = {}

splod.eight = {}
for i=1,8 do
	table.insert(splod.eight,love.graphics.newQuad(8*(i-1),0,8,8,64,8))
end
splod.eight.image = love.graphics.newImage("images/splod1.png")
splod.eight.off = {x=4,y=4}

function splod.new(x,y,dx,dy,anim,perframe,r,g,b,a)
	local self = setmetatable({},{__index=splod_mt})
	self.x = x
	self.y = y
	self.dx = dx or 0
	self.dy = dy or 0
	self.time = 0
	self.frame = 1
	self.anim = anim or splod.eight
	self.perframe = perframe or 0.1
	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255
	self.scale = 1
	self.rot = math.random()*2*math.pi
	return self
end

function splod.spawn( ... )
	local s = splod.new(...)
	table.insert(splod.all, s)
	return s
end

function splod.greysmoke(x,y)
	local light = math.random(64,180)
	local s = splod.spawn(
		x,
		y+math.random(-3,3),
		math.random(-20,20),
		math.random(-20,20),
		splod.eight,
		0.05+math.random()*0.05,
		light,
		light,
		light,
		255
	)
	s.scale = 2
end
function splod.jetsmoke(x,y)
	local light = math.random(64,180)
	splod.spawn(
		x+math.random(-3,3),
		y+math.random(-3,3),
		math.random(-5,5),
		200,
		splod.eight,
		0.05+math.random()*0.05,
		light,
		light,
		light,
		255
	)
end
function splod.fire(x,y)
	local light = math.random(127,255)
	local s = splod.spawn(
		x+math.random(-2,2),
		y+math.random(-2,2),
		math.random(-10,10),
		math.random(-10,10),
		splod.eight,
		0.05+math.random()*0.05,
		light,
		light/2,
		light/4,
		255
	)
	s.scale = 1.5
end


function splod.update(dt)
	local i = 1
	while i<=#splod.all do
		local v = splod.all[i]
		if v.purge or v.x<-10 or v.y<-10 or v.x>xsize+10 or v.y>ysize+10 then
			table.remove(splod.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function splod.draw()
	for i,v in ipairs(splod.all) do
		v:draw()
	end
end

function splod_mt:update( dt )
	self.time = self.time + dt
	if self.time>=self.perframe then
		if self.frame<#self.anim then
			self.frame=self.frame+1
			self.time=self.time-self.perframe
		else
			self.purge = true
		end
	end
	self.x = self.x+self.dx*dt
	self.y = self.y+self.dy*dt
end

function splod_mt:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(self.r,self.g,self.b,self.a)
	love.graphics.drawq(self.anim.image,self.anim[self.frame],self.x,self.y,self.rot,self.scale,self.scale,self.anim.off.x,self.anim.off.y)
	love.graphics.setColor(r,g,b,a)
end