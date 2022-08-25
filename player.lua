player = {}

function player:load()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	
	love.graphics.setBackgroundColor(202, 204, 206)

	font = love.graphics.newFont(40)
	love.graphics.setFont(font)

	self.icon = love.graphics.newImage("assets/player/icon.png")
	self.images = {
					left = love.graphics.newImage("assets/player/left.png"),
					right = love.graphics.newImage("assets/player/right.png"),
					up = love.graphics.newImage("assets/player/up.png"),
					down = love.graphics.newImage("assets/player/down.png"),
					left_reload = love.graphics.newImage("assets/player/reload_left.png"),
					right_reload = love.graphics.newImage("assets/player/reload_right.png"),
					up_reload = love.graphics.newImage("assets/player/reload_up.png"),
					down_reload = love.graphics.newImage("assets/player/reload_down.png"),
					left_shoot = love.graphics.newImage("assets/player/shoot_left.png"),
					right_shoot = love.graphics.newImage("assets/player/shoot_right.png"),
					up_shoot = love.graphics.newImage("assets/player/shoot_up.png"),
					down_shoot = love.graphics.newImage("assets/player/shoot_down.png"),
				  }

	self.bullet_img = {
						left = love.graphics.newImage("assets/player/bullet_left.png"),
						right = love.graphics.newImage("assets/player/bullet_right.png"),
						up = love.graphics.newImage("assets/player/bullet_up.png"),
						down = love.graphics.newImage("assets/player/bullet_down.png")
					  }

	self.width = 96
	self.height = 96

	self.directions = {left = "left", right = "right", up = "up", down = "down"}
	self.current_direction = self.directions.up

	self.current_img = self.images[self.current_direction]
	self.x = (screenWidth - self.width) / 2
	self.y = (screenHeight - self.height) / 2
	
	self.bullet_xoff = 40
	self.bullet_yoff = 10

	self.bullets = {}
	self.bullets_left = 15

	self.score = 0
	self.counter = 0
	self.health = 100
	self.game_over = false
	self.background_counter = 0

	background_load()
end

function player:update(dt)
	if not love.keyboard.isDown("r") and not love.keyboard.isDown("z") then
		self.current_img = self.images[self.current_direction]
	end
	player:bullets_update(dt)
	player:collisions(dt)
	player:score_update(dt)
end

function player:draw()

	love.graphics.setColor(255, 255, 255)
	background_draw()
	love.graphics.draw(self.current_img, self.x, self.y)

-- bullets

	for i, b in pairs(self.bullets) do
		love.graphics.draw(b.img, b.x, b.y)
	end
-- Other stuff
	
	love.graphics.draw(self.icon, 10, 10)
	love.graphics.setColor(100, 255, 100)
	love.graphics.rectangle("fill", 90, 30, self.health * 2, 20)
	if self.bullets_left <= 5 then
		love.graphics.setColor(255, 0, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end	
	love.graphics.print("15/"..self.bullets_left, 600, 30)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.score, 400, 30)

	if self.game_over == true then
		love.graphics.print("You died :) \n'R'to Restart\n Final Score: "..self.score, (screenWidth - 200) / 2, (screenHeight - 100) / 2)
	end

	love.graphics.setColor(255, 0, 0, 100)

	for i, e in pairs(enemies.enemy_table) do
		if CheckCollision(e, player) then
			love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
		end
	end
end

function player:state_manager(key)
	if key == "up" then
		self.current_direction = self.directions.up
		self.bullet_xoff = 40
		self.bullet_yoff = 10
	end

	if key == "down" then
		self.current_direction = self.directions.down
		self.bullet_xoff = 40
		self.bullet_yoff = 80
	end

	if key == "left" then
		self.current_direction = self.directions.left
		self.bullet_xoff = 0
		self.bullet_yoff = 40
	end

	if key == "right" then
		self.current_direction = self.directions.right
		self.bullet_xoff = 80
		self.bullet_yoff = 40
	end
end

function player:bullets_update(dt)
	for i, b in pairs(self.bullets) do
		if b.direction == "up" then
			if b.y < 0 then
				table.remove(self.bullets, i)
			end
			b.y = b.y - b.speed * dt
		end

		if b.direction == "down" then
			if b.y > screenHeight then
				table.remove(self.bullets, i)
			end
			b.y = b.y + b.speed * dt
		end

		if b.direction == "left" then
			if b.x < 0 then
				table.remove(self.bullets, i)
			end
			b.x = b.x - b.speed * dt
		end

		if b.direction == "right" then
			if b.x > screenWidth then
				table.remove(self.bullets, i)
			end
			b.x = b.x + b.speed * dt
		end
	end
end

function player:add_bullet(key)
	if key == "z" and self.bullets_left > 0 then
		self.bullets_left = self.bullets_left - 1
		self.current_img = self.images[tostring(self.current_direction).."_shoot"]
		love.audio.play(_sounds[2])
		bullet = {}
		bullet.x = self.x + self.bullet_xoff 
		bullet.y = self.y + self.bullet_yoff
		bullet.width = 10
		bullet.height = 10
		bullet.direction = self.current_direction
		bullet.speed = 500
		bullet.img = self.bullet_img[self.current_direction]
		table.insert(self.bullets, bullet)
	end

	if key == "z" and self.bullets_left <= 0 then
		love.audio.play(_sounds[1])
	end

	if key == "r" then
		love.audio.play(_sounds[6])
		self.bullets_left = 15 
		self.current_img = self.images[tostring(self.current_direction).."_reload"]
	end
end

function player:collisions(dt)
	for i1, b in pairs(self.bullets) do
		for i2, e in pairs(enemies.enemy_table) do 
			if CheckCollision(b, e) then
				self.score = self.score + 1
				self.counter = self.counter + 1
				self.background_counter = self.background_counter + 1
				e.death = true
				love.audio.play(_sounds[7])
				table.remove(self.bullets, i1)
			end
		end
	end

	for i2, e in pairs(enemies.enemy_table) do 
		if CheckCollision(e, self) and e.death == false then
			self.health = self.health - 100 * dt
			love.audio.play(_sounds[3])
		end
	end
end

function player:score_update(dt)
	if self.counter >= 15 then
		self.counter = 0
		self.health = 100
	end

	if self.background_counter >= 25 then
		self.background_counter = 0
		background_no = background_no + 1
		enemies.enemy_speed = enemies.enemy_speed + 100
		enemies.speed = enemies.speed + 1
		current_background = backgrounds[background_no]
		
		if background_no >= #backgrounds then
			background_no = 0
		end
	end
	
	if self.health <= 0 then
		love.audio.play(_sounds[4])
		self.health = 0
		self.game_over = true
	end
end

function player:reset(key)
	if key == "r" and self.game_over == true then
		self.game_over = false
		self.health = 100
		self.score = 0
		self.counter = 0
		enemies.speed = 150
		enemies.enemy_speed = 200
	end
end

function background_load()
	backgrounds = {
					love.graphics.newImage("assets/backgrounds/grass.png"),
					love.graphics.newImage("assets/backgrounds/mud.png"),
					love.graphics.newImage("assets/backgrounds/cobble.png"),
					love.graphics.newImage("assets/backgrounds/sand.png"),
				  }

	background_no = 1
	current_background = backgrounds[background_no] 
end

function background_draw()
	for y = 0, screenHeight, current_background:getHeight() do
		for x = 0, screenWidth, current_background:getWidth() do
			love.graphics.draw(current_background, x, y)
		end
	end
end

function CheckCollision(a, b)
	return a.x < b.x + b.width and
		   b.x < a.x + a.width and
		   a.y < b.y + b.height and
		   b.y < a.y + a.height
end