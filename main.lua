-- Initialize variables
local width, height = 250, 250
local offsetWidth, offsetHeight = 50, 20
local size = 1
local particleType = 1
local windowWidth, windowHeight = love.window.getDesktopDimensions(1)
local gameWidth = windowWidth - (windowWidth / math.ceil(windowWidth - 80))
local gameHeight = windowHeight - (windowHeight / math.ceil(windowHeight - 50))
local scaleWidth, scaleHeight = gameWidth / width, gameHeight / height
local grid = {}
local text = {}

-- Load gamefiles
local particles = require 'particles'

-- Sets colors for each particle
local colors = {
    [1] = { 1, 1, 1 },          -- Default
    [2] = { 0, 0, 1 },          -- Water
    [3] = { 1, 0.7, 0.2 },      -- Sand
    [4] = { 0, 1, 0 },          -- Gas
    [5] = { 0.5, 0.5, 0.5 },    -- Steam
    [6] = { 1, 0, 0 },          -- Fire
    [7] = { 0.3, 1, 0.3 },      -- Strange Matter
    [8] = { 0.9, 0.6, 0.4 },    -- Wood
    [9998] = { 0.5, 0.5, 0.5 }, -- Border
    [9999] = { 0.3, 0.8, 0.3 }  -- Boundary
}

-- MAIN CODE

-- Executes on load. Sets game to fullscreen and initialises particle boundaries and grid
function love.load()
    love.window.setMode(windowWidth, windowHeight, { fullscreen = true })

    -- Create boundary for particles
    for x = -100, windowWidth do
        grid[x] = {}
        for y = -100, windowHeight do
            if x == 1 or y == 1 then
                grid[x][y] = 9999
            elseif x == width - offsetWidth or y == height - offsetHeight then
                grid[x][y] = 9999
            else
                grid[x][y] = nil
            end
        end
    end

    -- Create border and initialise grid
    for x = 1, width - offsetWidth do
        grid[x] = {}
        for y = 1, height - offsetHeight do
            if x == 1 or y == 1 then
                grid[x][y] = 9998
            elseif x == width - offsetWidth or y == height - offsetHeight then
                grid[x][y] = 9998
            else
                grid[x][y] = nil
            end
        end
    end

end

-- Executes every frame
function love.update(dt)

    local particleAmount = 0
    -- If mouse clicked, get cursor position and execute function
    if love.mouse.isDown(1) then
        local currentX, currentY = love.mouse.getPosition()
        SpawnParticle(math.floor((currentX - offsetWidth) / scaleWidth),
            math.floor((currentY - offsetHeight) / scaleHeight))
    elseif love.mouse.isDown(2) then
        local currentX, currentY = love.mouse.getPosition()
        EraseParticle(math.floor((currentX - offsetWidth) / scaleWidth),
            math.floor((currentY - offsetHeight) / scaleHeight))
    end

    -- Apply physics to existing particles
    for x = 1, width - offsetWidth do
        for y = height - offsetHeight, 1, -1 do
            local type = grid[x][y]
            if type and type ~= 9998 and type ~= 9999 then -- If not border nor boundry, check particle type
                local particle = particles[type]
                if particle and particle.move then
                    local moves = particle.move(grid, x, y)
                    local move = moves[math.random(#moves)]
                    local newX, newY = move.x, move.y
                    local gridvalue = grid[newX][newY]
                    particleAmount = particleAmount + 1
                    if newX > 0 and newX <= width - offsetWidth and newY > 0 and newY <= height - offsetHeight and not gridvalue then
                        grid[newX][newY] = type
                        grid[x][y] = nil
                    end

                        -- Particle interactions
                    if grid[newX][newY] == 2 then
                        if grid[newX][newY - 1] == 1 or grid[newX][newY - 1] == 3 then
                            grid[newX][newY] = grid[newX][newY - 1]
                            grid[newX][newY - 1] = 2
                        end
                    elseif grid[newX][newY] == 5 then                                  -- If steam, turn into water
                        if math.random(1, 1000) == 13 then
                            grid[newX][newY] = 2
                        elseif grid[newX][newY - 1] == 2 then
                            grid[newX][newY] = 2
                            grid[newX][newY - 1] = 5
                        end
                    elseif grid[newX][newY] == 6 and math.random(1, 7) == 3 then       -- If fire, die
                        grid[newX][newY] = nil
                    elseif grid[newX][newY] == 6 and newY == 2 then
                        grid[newX][newY] = nil
                    elseif grid[newX][newY] == 6 then
                        for i = -3, 3 do
                            for j = -4, 1 do
                                if grid[newX+i][newY+j] == 4 then                               -- Turn gas into fire
                                    grid[newX+i][newY+j] = 6
                                elseif grid[newX+i][newY+j] == 2 and math.random(1,5) == 3 then -- Boil water into steam
                                    grid[newX+i][newY+j] = 5
                                end
                            end
                        end
                    elseif grid[newX][newY] == 7 and math.random(1,25) == 13 then
                        grid[newX][newY] = nil;
                    end
                end
            end
        end
    end
    

    -- Debugging
    text[1] = "FPS: " .. math.floor(1 / dt)
    text[2] = "Cursor size:" .. size
    text[3] = "type: " .. particleType
    text[4] = "Current particles: " .. particleAmount
end

-- Draws frames
function love.draw()

    -- Draw the cursor
    local mouseX, mouseY = love.mouse.getPosition()
    local startX = mouseX - math.floor(size / 2)
    local startY = mouseY - math.floor(size / 2)
    local endX = math.min(startX + size - 1, width - offsetWidth - 1)
    local endY = math.min(startY + size - 1, height - offsetHeight - 1)
    text[9] = mouseX .. "," .. mouseY
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    for x = startX, endX do
        for y = startY, endY do
            if x == startX or x == endX or y == startY or y == endY then
                love.graphics.rectangle("line", x, y, 1, 1)
            end
        end
    end
    -- Draws the actual particle
    for x = 1, width - offsetWidth do
        for y = 1, height - offsetHeight do
            local type = grid[x][y]
            if type then
                if colors[type] == nil then -- If no color is associated with type, throw error and paint grey
                    text[4] = "There are unknown particles in the simulation!!" .. x .. "," .. y
                    love.graphics.setColor(1, 1, 1, 0.5)
                    love.graphics.rectangle("fill", (x * scaleWidth) + offsetWidth, (y * scaleHeight) + offsetHeight,
                        scaleWidth, scaleHeight)
                else
                    love.graphics.setColor(colors[type])
                    love.graphics.rectangle("fill", (x * scaleWidth) + offsetWidth, (y * scaleHeight) + offsetHeight,
                        scaleWidth, scaleHeight)
                end
            end
        end
    end

    -- Debugging
    for a, b in pairs(text) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(b, 10, a * 10, 0, 1, 1)
    end

end

-- FUNCTIONS

-- Function for keyboard keys pressed. Refer to wiki for more information about keys
function love.keypressed(key)

    text[9] = key
    if tonumber(key) and tonumber(key) >= 1 and tonumber(key) <= 9 then
        particleType = tonumber(key)
    elseif key == "r" then
        for x = 1, width - offsetWidth do
            grid[x] = {}
            for y = 1, height - offsetHeight do
                if x == 1 or y == 1 then
                    grid[x][y] = 9998
                elseif x == width - offsetWidth or y == height - offsetHeight then
                    grid[x][y] = 9998
                else
                    grid[x][y] = nil
                end
            end
        end
    end

end

-- Function for mouse wheel movement
function love.wheelmoved(x, y)

    if y > 0 and size < 100 then
        size = size + 1
    elseif y < 0 and size > 1 then
        size = size - 1
    end
    
end

function SpawnParticle(x, y)

    local startX = x - math.floor(size / 2)
    local startY = y - math.floor(size / 2)
    if startX < 2 then startX = 2 end
    if startY < 2 then startY = 2 end
    local endX = math.min(startX + size - 1, width - offsetWidth - 1)
    local endY = math.min(startY + size - 1, height - offsetHeight - 1)

    for i = startX, endX do
        for j = startY, endY do
            if not grid[i][j] then
                grid[i][j] = particleType
            end
        end
    end

end


-- Function that erases particles at position of mouse
function EraseParticle(x, y)

    local startX = x - math.floor(size / 2)
    local startY = y - math.floor(size / 2)
    if startX < 2 then startX = 2 end
    if startY < 2 then startY = 2 end
    local endX = math.min(startX + size - 1, width - offsetWidth - 1)
    local endY = math.min(startY + size - 1, height - offsetHeight - 1)

    for i = startX, endX do
        for j = startY, endY do
            if grid[i][j] and grid[i][j] ~= 9999 and grid[i][j] ~= 9998 then
                grid[i][j] = nil
            end
        end
    end

end
