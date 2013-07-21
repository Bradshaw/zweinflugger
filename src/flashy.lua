flashy = {}

flashy.all = {}

function flashy.add(f)
	table.insert(flashy.all, f)
end

function flashy.stencil()
	love.graphics.rectangle("fill",10,10,10,10)
	local i = 1
	while i<=#flashy.all do
		local v = flashy.all[i]
		if v.purge then
			table.remove(bullet.all, i)
		else
			v:flash()
			i = i + 1
		end
	end
end

function flashy.draw()
	love.graphics.setStencil(flashy.stencil)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",0,0,xsize,ysize)
	love.graphics.setStencil()
	love.graphics.setColor(255,255,255)
end