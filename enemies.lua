enemies = {}

function enemies:load()
	self.enemy_table = {}
	self.images = {
					left = love.graphics.newImage("assets/enemy/left.png"),
					right = love.graphics.newImage("assets/enemy/right.png"),
					up = love.graphics.newImage("assets/enemy/up.png"),
					down = love.graphics.newImage("assets/enemy/down.png"),
				  }

	self.timer_left = 200
	self.timer_right = 300
	self.timer_up = 400
	self.timer_down = 500

	self.speed = 150
	self.enemy_speed = 200

	self.death_anim = {
					   left = love.graphics.newImage("assets/enemy/death_left.png"),
					   right = love.graphics.newImage("assets/enemy/death_right.png"),
					   up = love.graphics.newImage("assets/enemy/death_up.png"),
					   down = love.graphics.newImage("assets/enemy/death_down.png"),
					  }
end

function enemies:update(dt)
	enemies:timer(dt)
	enemies:spawn(dt)
	enemies:enemy_update(dt)
	enemies:death_animation(dt)
end

function enemies:draw()
	love.graphics.setColor(255, 255, 255)
	for i, e in pairs(self.enemy_table) do
		if e.death == false then
			love.graphics.draw(self.images[e.direction], e.x, e.y)
		else
			love.graphics.draw(e.death_img, e.current_quad, e.x, e.y)
		end
	end
end

function enemies:timer(dt)
	self.timer_left = self.timer_left - self.speed * dt
	self.timer_right = self.timer_right - self.speed * dt
	self.timer_up = self.timer_up - self.speed * dt
	self.timer_down = self.timer_down - self.speed * dt
end

function enemies:spawn(dt)
	if self.timer_left <= 0 then
		self.timer_left = 200
		love.audio.play(_sounds[8])
		enemy = {}
		enemy.width = 96
		enemy.height = 96
		enemy.x = -enemy.width
		enemy.y = (screenHeight - enemy.height) / 2
		enemy.direction = "left"
		enemy.death = false
		enemy.fps = 5
		enemy.anim_timer = 1 / enemy.fps
		enemy.xoff = 0
		enemy.death_img = self.death_anim[enemy.direction]
		enemy.current_quad = love.graphics.newQuad(enemy.xoff, 0, enemy.width, enemy.height, enemy.death_img:getDimensions())
		table.insert(self.enemy_table, enemy)
	end
	
	if self.timer_right <= 0 then
		love.audio.play(_sounds[8])
		self.timer_right = 300
		enemy = {}
		enemy.width = 96
		enemy.height = 96
		enemy.x = screenWidth
		enemy.y = (screenHeight - enemy.height) / 2
		enemy.direction = "right"
		enemy.death = false
		enemy.fps = 5
		enemy.anim_timer = 1 / enemy.fps
		enemy.xoff = 0
		enemy.death_img = self.death_anim[enemy.direction]
		enemy.current_quad = love.graphics.newQuad(enemy.xoff, 0, enemy.width, enemy.height, enemy.death_img:getDimensions())
		table.insert(self.enemy_table, enemy)
	end
	
	if self.timer_up <= 0 then
		love.audio.play(_sounds[8])
		self.timer_up = 400
		enemy = {}
		enemy.width = 96
		enemy.height = 96
		enemy.x = (screenWidth - enemy.width) / 2
		enemy.y = -enemy.height
		enemy.direction = "up"
		enemy.death = false
		enemy.fps = 5
		enemy.anim_timer = 1 / enemy.fps
		enemy.xoff = 0
		enemy.death_img = self.death_anim[enemy.direction]
		enemy.current_quad = love.graphics.newQuad(enemy.xoff, 0, enemy.width, enemy.height, enemy.death_img:getDimensions())
		table.insert(self.enemy_table, enemy)
	end

	if self.timer_down <= 0 then
		love.audio.play(_sounds[8])
		self.timer_down = 500
		enemy = {}
		enemy.width = 96
		enemy.height = 96
		enemy.x = (screenWidth - enemy.width) / 2
		enemy.y = screenHeight
		enemy.direction = "down"
		enemy.death = false
		enemy.fps = 5
		enemy.anim_timer = 1 / enemy.fps
		enemy.xoff = 0
		enemy.death_img = self.death_anim[enemy.direction]
		enemy.current_quad = love.graphics.newQuad(enemy.xoff, 0, enemy.width, enemy.height, enemy.death_img:getDimensions())
		table.insert(self.enemy_table, enemy)
	end
end

function enemies:enemy_update(dt)
	for i, e in pairs(self.enemy_table) do
		if e.death == false then
			if e.direction == "up" then
				if e.y > screenHeight or player.game_over == true  then
					table.remove(self.enemy_table, i)
				end
				e.y = e.y + self.enemy_speed * dt
			end

			if e.direction == "down" then
				if e.y < 0 or player.game_over == true  then
					table.remove(self.enemy_table, i)
				end
				e.y = e.y - self.enemy_speed * dt
			end

			if e.direction == "left" then
				if e.x > screenWidth or player.game_over == true  then
					table.remove(self.enemy_table, i)
				end
				e.x = e.x + self.enemy_speed * dt
			end

			if e.direction == "right"  then
				if e.x < 0 or player.game_over == true then
					table.remove(self.enemy_table, i)
				end
				e.x = e.x - self.enemy_speed * dt
			end
		end
	end
end

function enemies:death_animation(dt)
	for i, e in pairs(self.enemy_table) do
		if e.death == true then
			e.anim_timer = e.anim_timer - dt

			if e.anim_timer <= 0 then
				e.anim_timer = 1 / e.fps

				e.xoff = e.xoff + 96
				
				if e.xoff >= e.death_img:getWidth() then
					table.remove(self.enemy_table, i)
				end
			end
			e.current_quad = love.graphics.newQuad(e.xoff, 0, e.width, e.height, e.death_img:getDimensions())
		end
	end
end