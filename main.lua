function love.load()
   gamestate = "begin"
   t_idx = 1

   fade = {
      alpha = 0,
      timer = 0,
      floor = 2,
      trigger = true
   }
   
   cursor = {
      hand = love.mouse.newCursor("assets/cursors/hand_cursor.png"),
      wer = love.mouse.newCursor("assets/cursors/wer_cursor.png")}

   fonts = {
      classic = love.graphics.newFont("fonts/BeatrixAntiqua.ttf", 30),
      book = love.graphics.newFont("fonts/BeatrixAntiqua.ttf", 40),
      title = love.graphics.newFont("fonts/BeatrixAntiqua.ttf", 60)
   }
   
   bg = {
      main_background = love.graphics.newImage("assets/main_background.jpg"),
      locker = { sprite = love.graphics.newImage("assets/locker.png"), x = 100, y = 230 },
      glass_tube = { sprite = love.graphics.newImage("assets/glass_tube.png"), x = 700, y = 0 },
      guy = { sprite = love.graphics.newImage("assets/guy.png"), x = 818, y = 440 },
      trash = { sprite = love.graphics.newImage("assets/trash.png"), x = 1500, y = 900 },
      board = { sprite = love.graphics.newImage("assets/board.png"), x = 1100, y = 300 },
      brew = {sprite = love.graphics.newImage("assets/brewing_stand.png"), x = 0, y = 0},
      generator = {sprite = love.graphics.newImage("assets/generator.png"), x = 1030, y = 880}}

   text = {
      "\"Qu'est-ce-que je fais là ?\"",
      "Un sentiment vous ronge de l'intérieur.",
      "Le sentiment d'avoir été duppé par le monde qui vous entoure.",
      "C'est en regardant cette pièce glauque que vous comprenez que le monde n'est pas ce qu'il est réellement.",
      "Il est temps pour vous de le découvrir.",
      "Enquêtez sur ce qu'est la créature dans le tube de verre, essayez de comprendre votre vraie nature.",
      "La surprise ne fait que commencer."
   }
   photo = love.graphics.newImage("assets/photo.jpg")
   
   love.mouse.setCursor(cursor.hand)
   love.graphics.setFont(fonts.title)
   love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
   if (gamestate == "begin") then
      if fade.trigger then
	 fade.timer = fade.timer + dt
	 if (fade.timer > fade.floor) then
	    fade.trigger = false
	 end
      else
	 fade.timer = fade.timer - dt
	 if (fade.timer < 0) then
	    fade.timer = 0
	    fade.trigger = true
	    t_idx = t_idx + 1
	 end
      end
      
      if fade.timer < fade.floor / 2 then
	 fade.alpha = fade.timer / (fade.floor / 2)
      end
   end
end

function love.keypressed(key, scancode, isrepeat)
   if (key == "escape") then
      if (gamestate == "room" or gamestate == "begin") then love.event.quit()
      elseif (gamestate == "photo") then gamestate = "room"
      end
   elseif key == "return" then
      if gamestate == "begin" and fade.timer >= fade.floor / 4 then
	 fade.trigger = false
      end
   end
end

function love.mousepressed(x, y, button, istouch)
   local elem = detectSprite(x, y)

   if (button == 1) then
      if (elem == bg.board) then
	 gamestate = "photo"
	 love.mouse.setCursor(cursor.hand)
      end
   end
end

function love.mousemoved(x, y, dx, dy, istouch)
   local elem = detectSprite(x, y)
   local current = love.mouse.getCursor()

   if (gamestate == "room") then
      if not (elem == bg.main_background) and (current == cursor.hand) then
	 love.mouse.setCursor(cursor.wer)
      elseif (elem == bg.main_background and current == cursor.wer) then
	 love.mouse.setCursor(cursor.hand)
      end
   end
end

function love.draw()
   if (gamestate == "begin") then
      love.graphics.setColor(255, 255, 255, fade.alpha * 255)
      love.graphics.printf({{255, 255, 255}, text[t_idx]}, 60, 1080 / 2 - 60, 1920 - 120, "center")
      if (t_idx > #text) then
	 gamestate = "room"
	 love.graphics.setColor(255, 255, 255, 255)
      end
   elseif (gamestate == "room") then
      love.graphics.draw(bg.main_background, 0, 0)
      love.graphics.draw(bg.locker.sprite, bg.locker.x, bg.locker.y)
      love.graphics.draw(bg.glass_tube.sprite, bg.glass_tube.x, bg.glass_tube.y)
      love.graphics.draw(bg.guy.sprite, bg.guy.x, bg.guy.y)
      love.graphics.draw(bg.generator.sprite, bg.generator.x, bg.generator.y)
      -- love.graphics.draw(table, 818, 440)
      love.graphics.draw(bg.trash.sprite, bg.trash.x, bg.trash.y)
      love.graphics.draw(bg.board.sprite, bg.board.x, bg.board.y)
   elseif (gamestate == "photo") then
      love.graphics.draw(photo, 0, 0, 0, 1920 / photo:getWidth(), 1080 / photo:getHeight())
   end
end

function detectSprite(x, y)
   if (gamestate == "room") then
      if (x >= bg.board.x + bg.board.sprite:getWidth() - 60 and x <= bg.board.x + bg.board.sprite:getWidth() - 15) and (y >= bg.board.y + bg.board.sprite:getHeight() - 60 and y <= bg.board.y + bg.board.sprite:getHeight() - 15) then
	 return (bg.board)
      else
	 return (bg.main_background)
      end
   elseif (gamestate == "photo") then return (photo) end
end
