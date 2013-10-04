local input_mt = {}
input = {}

--[[

keyboard controls :
{up, down, left, right, attack}



]]
love.keyboard.isBown = love.keyboard.isDown
love.keyboard.isDown = function(key, ...)
	if key then
		if type(key)=="table" then
			for i,v in ipairs(key) do
				local truth = love.keyboard.isDown(v)
				if truth then return true end
			end
		else
			return love.keyboard.isBown(key) or love.keyboard.isDown(...)
		end
	end
	return false
end

function input.new(mode, controls)
	local self = setmetatable({},{__index = input_mt})
	self.mode = mode or "keyboard"
	self.controls = controls or {"up", "down", "left", "right", "rctrl"}
	if self.mode == "keyboard" then
		self.up = function(self) return love.keyboard.isDown(self.controls[1]) end
		self.down = function(self) return love.keyboard.isDown(self.controls[2]) end
		self.left = function(self) return love.keyboard.isDown(self.controls[3]) end
		self.right = function(self) return love.keyboard.isDown(self.controls[4]) end
		self.attack = function(self) return love.keyboard.isDown(self.controls[5]) end
	elseif self.mode == "joystickbtn" then

	elseif self.mode == "joystickaxes" then

	end
	return self
end

function input_mt:dx()
	local dx = 0
	if self:left() then
		dx=dx-1
	end
	if self:right() then
		dx=dx+1
	end
	return dx
end

function input_mt:dy()
	local dy = 0
	if self:up() then
		dy=dy-1
	end
	if self:down() then
		dy=dy+1
	end
	return dy
end

input.DEFAULTP1 = input.new("keyboard",{"up", "down", "left", "right", "rctrl"})
input.DEFAULTP2 = input.new("keyboard",{"q", "z", "a", "s", "lctrl"})