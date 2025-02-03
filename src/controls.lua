local controls = {}

local callbacks = {}

function controls.registerCallback(name, func)
    callbacks[name] = func
end

function controls.mouse()
    if love.mouse.isDown(1) then
        callbacks["mouseClick1Director"]()
    elseif love.mouse.isDown(2) then
        callbacks["mouseClick2Director"]()
    end
end

function controls.keyboard()
    function love.keypressed(key)
        if tonumber(key) and tonumber(key) >= 1 and tonumber(key) <= 9 then
            game.particleType = tonumber(key)
            if tonumber(key) == 8 then game.particleType = 6001 end
            if tonumber(key) == 9 then game.particleType = 6000 end
        elseif key == "r" then
            callbacks["resetGrid"]()
        elseif key == "space" then
            game.running = not game.running
        elseif key == "." then
            game.step = true
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

return controls