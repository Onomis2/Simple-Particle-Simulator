-- Initialize variables
    -- Global
        -- Libraries
_G.love = require('love')

        --Variables
_G.game = {particleType = 1, running = true, step = true}

    -- Local
        -- Load gamefiles
local particles = require 'src.particles'
local controls = require 'src.controls'
local functions = require 'src.functions'

        -- Game variables
local width, height = 400, 400
local reverse, loopStart, loopGoal, loopStep = false, 0, 0, 0
local mouseX, mouseY = love.mouse.getPosition()
local size = 1
local grid = {}

        -- Screen variables
local windowWidth, windowHeight = love.window.getDesktopDimensions(1)
local offsetX, offsetY, scale

    -- Debugging
local text = {}

--
-- The game
--

-- Executes on load. Sets game to fullscreen and initialises particle boundaries and grid
function love.load()
    love.window.setMode(windowWidth, windowHeight, { fullscreen = true })

    -- Calculate variables that draw the game

    local gameWidth, gameHeight = 500, 500
    
    -- Calculate scale factor for the game (based on the smaller dimension of the screen)
    local scaleX, scaleY = windowWidth / gameWidth, windowHeight / gameHeight
    scale = math.min(scaleX, scaleY)
    
    -- Calculate offsets to center the game area on the screen
    offsetX = (windowWidth - gameWidth * scale) / 2
    offsetY = (windowHeight - gameHeight * scale) / 2


    -- REgister control callbacks
    controls.registerCallback("mouseClick1Director", function() functions.mouseClick1Director(mouseX, mouseY) end)
    controls.registerCallback("mouseClick2Director", function() functions.mouseClick2Director() end)
    controls.registerCallback("resetGrid", function() functions.resetGrid(grid, width, height) end)
    functions.registerCallback("selectOption", function() functions.selectOption(mouseX, mouseY) end)
    functions.registerCallback("selectCategory", function() functions.selectCategory(mouseX, mouseY) end)
    functions.registerCallback("selectParticle", function() functions.selectParticle(mouseX, mouseY) end)
    functions.registerCallback("spawnParticle", function() functions.spawnParticle(math.floor(mouseX), math.floor(mouseY), grid, size, width, height) end)
    functions.registerCallback("eraseParticle", function() functions.eraseParticle(math.floor(mouseX), math.floor(mouseY), grid, size, width, height) end)

    -- Create particle grid
    functions.resetGrid(grid, width, height)
end

-- Executes every frame
function love.update(dt)
-- Controls
    -- Get mouse position
    mouseX, mouseY = love.mouse.getPosition()
    mouseX = math.floor((mouseX - offsetX) / scale)
    mouseY = math.floor((mouseY - offsetY) / scale)

    -- Execute controls
    controls.mouse()
    controls.keyboard()

    -- Run physics
    if game.running or game.step == true then
        -- Step 1 frame at request of user
        if game.step == true then game.step = not game.step end
        
        -- Loop alternator
        if reverse == true then
            loopStart, loopGoal, loopStep = width, 1, -1
        else
            loopStart, loopGoal, loopStep = 1, width, 1
        end
        reverse = not reverse

        -- Apply physics to existing particles
        for x = loopStart, loopGoal, loopStep do
            for y = height, 1, -1 do
                local type = grid[x][y]
                if type and type ~= 9999 then
                    particles[type].behavior(grid, x, y, type)
                end
            end
        end
    end

    -- Debugging
    -- Count all particles on one line (very ugly, should be function)
    local count = 0 for x = 1, width do for y = 1, height do if grid[x][y] and grid[x][y] ~= 9999 then count = count + 1 end end end

    text[1] = "FPS: " .. math.floor(1 / dt)
    text[2] = "Cursor size:" .. size
    text[3] = "type: " .. game.particleType
    text[4] = "Current particles: " .. count
    text[5] = "Monitor Size:" .. windowWidth .. "," .. windowHeight
    text[6] = "Offset:" .. offsetX .. "," .. offsetY
    text[7] = "Mouse:" .. mouseX .."," .. mouseY
    text[8] = "Selected particle: " .. game.particleType
    if grid[mouseX] and grid[mouseX][mouseY] then
    text[9] = "hovering over particle: " .. grid[mouseX][mouseY]
    end
end

-- Draws frames
function love.draw()
    -- Translate to fit on any screen anywhere
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale)

    -- Draw the cursor (Can be a function)
    local halfSize = math.floor(size / 2)
    love.graphics.setColor(1,0,0,1)
    love.graphics.line(
    mouseX - halfSize, mouseY - halfSize,
    mouseX + halfSize, mouseY - halfSize,
    mouseX + halfSize, mouseY + halfSize,
    mouseX - halfSize, mouseY + halfSize,
    mouseX - halfSize, mouseY - halfSize
    )

    -- Draws the actual particles
    for x = 1, width do
        for y = 1, height do
            local type = grid[x][y]
            if type then
                love.graphics.setColor(particles[type].color)
                love.graphics.rectangle("fill", x, y,1,1)
            end
        end
    end

    -- Fill the background for the category and options and elements selector
    love.graphics.setColor(0.1,0.1,0.1,1)
    love.graphics.rectangle("fill", 401, 1, 100, 500)
    love.graphics.rectangle("fill", 1, 401, 500, 100)

    -- Draw Options 
    love.graphics.setColor(1,1,0,1)
    love.graphics.print("Placeholder", 401, 1)

    -- Draw categories
    love.graphics.setColor(1,0,1,1)
    love.graphics.print("Placeholder", 401, 101)

    -- Draw elements
    love.graphics.setColor(0,1,1,1)
    love.graphics.print("Placeholder", 1, 401)

    -- Pop the rest of the game
    love.graphics.pop()


    -- Debugging (Doesn't need to be translated or scaled)
    for index, value in ipairs(text) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(value, 10, index * 10, 0, 1, 1)
    end

end

-- Detect mousewheel movement
function love.wheelmoved(_, y)

    size = math.max(1, math.min(100, size + y))

end