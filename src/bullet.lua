local bullet_mt = {}
bullet = {}
bullet.all = {}

function bullet.new( bull, ... )
	local self = bullet.proto()
	if type(bull)=="table" then
		self = bullet.fromProto(bull, ...)
		table.insert(bullet.all, self)
	else
		table.insert(bullet.all, bullet.fromProto(self, bull, ...))
	end
	return self
end

function bullet.fromProto( bull, x, y, dx, dy, target, draw, update )
	local self = setmetatable({},{__index = bull})
	self.x = x or self.x
	self.y = y or self.y
	self.dx = dx or self.dx
	self.dy = dy or self.dy
	self.radius = self.radius
	self.r = self.r
	self.g = self.g
	self.b = self.b
	if update then
		self.update = update
	end
	if draw then
		self.draw = draw
	end
	self.target = target or self.target or "player"
	--table.insert(bullet.all, self)
	return self
end

function bullet.proto()
	local self = setmetatable({},{__index = bullet_mt})
	return self
end

function bullet.update(dt)
	local i = 1
	while i<=#bullet.all do
		local v = bullet.all[i]
		if v.purge or v.x<-10 or v.y<-10 or v.x>xsize+10 or v.y>ysize+10 then
			table.remove(bullet.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function bullet.draw()
	for i,v in ipairs(bullet.all) do
		v:draw()
	end
end

function bullet_mt:update( dt )
	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt
end

function bullet_mt:draw()
	love.graphics.setColor(self.r,self.g,self.b)
	love.graphics.circle("fill",self.x,self.y,self.radius+1)
	love.graphics.setColor(255,255,255)
	love.graphics.circle("fill",self.x,self.y,self.radius)
end