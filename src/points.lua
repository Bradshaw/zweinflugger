local points_mt = {}
points = {}
points.all = {}
points.img = love.graphics.newImage("images/points.png")

function points.new(pl, x, y)
	local self = setmetatable({}, {__index=points_mt})
	self.x = x
	self.y = y
	local a = math.random()*math.pi*2
	self.dx = math.cos(a)*30
	self.dy = math.sin(a)*30
	self.pl = pl
	self.spinoff = math.random()*math.pi
	self.spinspd = (math.random()*2-1)*10
	table.insert(points.all, self)
	return self
end

function points.update( dt )
	local i = 1
	while i<=#points.all do
		local v = points.all[i]
		if v.purge then
			v.pl.score = v.pl.score + 1
			table.remove(points.all, i)
		else
			v:update(dt)
			i = i+1
		end

	end
end

function points.draw(  )
	for i,v in ipairs(points.all) do
		v:draw()
	end
end

function points_mt:update( dt )
	local dx = self.pl.x - self.x
	local dy = self.pl.y - self.y
	local d = math.sqrt(dx*dx+dy*dy)
	if d<10 then
		self.purge = true
	end
	local nx = dx/d
	local ny = dy/d
	self.dx = self.dx+nx*dt*100
	self.dy = self.dy+ny*dt*100
	self.x = self.x+self.dx*dt
	self.y = self.y+self.dy*dt
	self.dx = self.dx-self.dx*dt
	self.dy = self.dy-self.dy*dt
end

function points_mt:draw()
	if self.pl == p1 then
		love.graphics.setColor(255,64,64,math.random(0,127))
	else
		love.graphics.setColor(64,64,255,math.random(0,127))
	end
	love.graphics.setBlendMode("additive")
	love.graphics.draw(points.img, self.x, self.y,self.spinoff+love.timer.getTime()*self.spinspd,0.5,0.5,points.img:getWidth()/2,points.img:getHeight()/2)
	love.graphics.setBlendMode("alpha")
end
