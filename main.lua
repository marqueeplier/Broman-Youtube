require "player"
require "enemies"
require "menu"

function love.load()
	menu:load()
	player:load()
	enemies:load()
end

function love.update(dt)
	if menu.current_state == "menu" then
		menu:update(dt)
	end
	
	if menu.current_state == "action" then 
		player:update(dt)
		enemies:update(dt)
	end
end

function love.draw()
	if menu.current_state == "menu" then
		menu:draw()
	end
		
	if menu.current_state == "action" then
		player:draw()
		enemies:draw()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	player:state_manager(key)
	player:add_bullet(key)
	player:reset(key)

	menu:fullscreen(key)
	if key == "m" then
		menu.current_state = menu.states.menu
		mousebox_reset()
	end
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, b, istouch)
	if menu.current_state == "menu" then
		menu:mousepressed(x, y, b, istouch)
	end
end