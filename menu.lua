menu = {}

function menu:load()
	self.icon = love.graphics.newImage("assets/menu/title.png")
	self.buttons = {
					 love.graphics.newImage("assets/menu/start.png"),
					 love.graphics.newImage("assets/menu/highscore.png"),
					 love.graphics.newImage("assets/menu/quit.png")
				   }
	self.states = {
				   menu = "menu",
			       action = "action"
				  }

	self.current_state = self.states.menu
	self.mousebox = {x = 0, y = 0, width = 10, height = 10}
	self.highscore = 0
	_mousebox = self.mousebox

	self.sounds = {
				   love.audio.newSource("assets/sounds and others/blank.wav"),
				   love.audio.newSource("assets/sounds and others/gunsound.wav"),
				   love.audio.newSource("assets/sounds and others/hurt.wav"),
				   love.audio.newSource("assets/sounds and others/iamdead.wav"),
				   love.audio.newSource("assets/sounds and others/music.wav"),
				   love.audio.newSource("assets/sounds and others/reload.wav"),
				   love.audio.newSource("assets/sounds and others/zombiedeathnew.wav"),
				   love.audio.newSource("assets/sounds and others/zombiespawn.wav")
				}

	_sounds = self.sounds
	_sounds[5]:setLooping()
	love.audio.play(_sounds[5])
end

function menu:update(dt)
	_mousebox.x = love.mouse.getX()
	_mousebox.y = love.mouse.getY()

	menu:highscore_u()
end

function menu:draw()
	love.graphics.draw(self.icon, (screenWidth - self.icon:getWidth()) / 2, ((screenHeight - self.icon:getHeight()) / 2) - 200)
	
	for i = 1, #self.buttons do
		local button = self.buttons[i]
		love.graphics.draw(button, (screenWidth - button:getWidth()) / 2, ((i * 100) + ((screenHeight - button:getHeight()) / 2)) - 100)
	end

	love.graphics.print(self.highscore, 490, 375)
end

function menu:highscore_u()
	if player.score > self.highscore then
		self.highscore = player.score
	end
end

function menu:mousepressed(x, y, b, istouch)
	for i = 1, #self.buttons do
		local ref = self.buttons[i] 
		local button = {}
		button.x = (screenWidth - ref:getWidth()) / 2	 
		button.y = ((i * 100) + ((screenHeight - ref:getHeight()) / 2)) - 100	
		button.width = ref:getWidth()
		button.height = ref:getHeight()
		button.id = i

		if CheckCollision(_mousebox, button) then
			if b == "l" then
				if button.id == 1 then
					self.current_state = self.states.action
					mousebox_reset()
				end

				if button.id == 3 then
					love.event.quit()
				end
			end
		end
	end
end

function mousebox_reset()
	_mousebox.x = 0
	_mousebox.y = 0
end

function menu:fullscreen(key)
	if key == "f1" then
		love.window.setFullscreen(true, "normal")
	end

	if key == "f2" then
		love.window.setFullscreen(false, "normal")
	end

	if key == "o" then
		love.audio.stop(_sounds[5])
	end

	if key == "p" then
		love.audio.play(_sounds[5])
	end
end

--Thats about it now all we have to do is make an exe. Thank you for watching. All the code will be provided. Now lets make the exe. All done.


	-- Ok guys thanks for watching. This has been fun. Comment if you want me to make another video prehaps on Dundel which is a fighting game I made or maybe you want to learn javascript in which case I will make dundel in java script

	-- Any how thanks for watching.

	-- Peace out

	-- :D bye bye