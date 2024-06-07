

-- Initialize variables
local width, height = love.window.getDesktopDimensions(1)
local grid = {}
local size = 1
local text = {}
local particleType = 1


-- MAIN CODE

-- Executes on load. Sets game to fullscreen and initialises the grid
function love.load()

    love.window.setMode(width, height, {fullscreen = true})
    
    for x = 1, width do
        grid[x] = {}
        for y = 1, height do
            grid[x][y] = nil
        end
    end

end


-- Executes every frame
function love.update(dt)
    --If mouse clicked, get cursor position and execute function
    if love.mouse.isDown(1) then
        local currentX, currentY = love.mouse.getPosition()
        SpawnParticle(currentX, currentY)
    elseif love.mouse.isDown(2) then
        local currentX, currentY = love.mouse.getPosition()
        EraseParticle(currentX, currentY)
    end

    --Apply physics to existing particles
    for x = width, 1, -1 do
        for y = height, 1, -1 do
            local type = grid[x][y]
            if type then
                local moveFunctions = GetMoveFunction(type)
                local moveFunction = moveFunctions[math.random(#moveFunctions)]
                moveFunction(x, y, type)
            end
        end
    end

    -- Debugging
    text[1] = "FPS: " .. math.floor(1 / dt)
    text[2] = "Cursor size:" .. size
    text[3] = "type: " .. particleType
end


-- Draws frames
function love.draw()
    -- Sets colors for each particle
    local colors = {
        [1] = {1, 1, 1}, -- Default
        [2] = {0, 0, 1}, -- Water
        [3] = {1, 0.7, 0.2}, -- Sand
        [4] = {0, 1, 0}, -- Gas
        [5] = {0.5, 0.5, 0.5}, -- Steam
        [6] = {1, 0, 0} -- Fire
    }

    -- Draws the actual particle
    for x = 1, width do
        for y = 1, height do
            local type = grid[x][y]
            if type then
                love.graphics.setColor(colors[type])
                love.graphics.points(x, y)
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
-- Function for mouse wheel movement
function love.wheelmoved(x, y)
    if y > 0 and size < 5000 then
        size = size + 1
    elseif y < 0 and size > 1 then
        size = size - 1
    end
end

-- Function for keyboard keys pressed. Refer to wiki for more information about keys
function love.keypressed(key)
    text[9] = key
    if tonumber(key) and tonumber(key) >= 1 and tonumber(key) <= 9 then
        particleType = tonumber(key)
    elseif key == "r" then
        for x = 1, width do
            grid[x] = {}
            for y = 1, height do
                grid[x][y] = nil
            end
        end
    end
end

-- Function that spawns particles at position of cursor
function SpawnParticle(x, y)
    if x >= 1 and x <= width and y >= 1 and y <= height then
        for i = 0, size - 1 do
            if x + i > width then
                break
            end
            for j = 0, size - 1 do
                if y + j > height then
                    break
                end
                local px, py = x + i, y + j
                if not grid[px][py] then
                    grid[px][py] = particleType
                end
            end
        end
    end
end

-- Function that erases particles at position of mouse
function EraseParticle(x, y)
    for i = 0, size - 1 do
        for j = 0, size - 1 do
            local px, py = x + i, y + j
            if px <= width and py <= height then
                grid[px][py] = nil
            end
        end
    end
end

-- Get list of move functions for the given particle type
function GetMoveFunction(type)
    if type == 1 then
        return {CheckDown}
    elseif type == 2 then
        return {WaterCheckDown,WaterCheckDownLeft,WaterCheckDownRight,WaterCheckLeft,WaterCheckRight}
    elseif type == 3 then
        return {CheckDown, CheckDownLeft, CheckDownRight}
    elseif type == 4 then
        return {CheckUp, CheckUpLeft, CheckUpRight, CheckDown, CheckDownLeft, CheckDownRight ,CheckLeft, CheckRight}
    elseif type == 5 then
        return {SteamCheckDownLeft,SteamCheckDownRight, SteamCheckUp, SteamCheckUpLeft, SteamCheckUpRight, SteamCheckLeft, SteamCheckRight}
    elseif type == 6 then
        return {FireCheckDown,FireCheckDownLeft,FireCheckDownRight,FireCheckLeft,FireCheckRight,FireCheckUp,FireCheckUpLeft,FireCheckUpRight}
    end
    return {}
end

-- Particle movements
function CheckDown(x, y, type)
    if y < height and not grid[x][y + 1] then
        grid[x][y] = nil
        grid[x][y + 1] = type
    end
end

function CheckDownRight(x, y, type)
    if x < width and y < height and not grid[x + 1][y + 1] then
        grid[x][y] = nil
        grid[x + 1][y + 1] = type
    end
end

function CheckDownLeft(x, y, type)
    if x > 1 and y < height and not grid[x - 1][y + 1] then
        grid[x][y] = nil
        grid[x - 1][y + 1] = type
    end
end

function CheckUp(x, y, type)
    if y > 1 and not grid[x][y - 1] then
        grid[x][y] = nil
        grid[x][y - 1] = type
    end
end

function CheckUpRight(x, y, type)
    if x < width and y > 1 and not grid[x + 1][y - 1] then
        grid[x][y] = nil
        grid[x + 1][y - 1] = type
    end
end

function CheckUpLeft(x, y, type)
    if x > 1 and y > 1 and not grid[x - 1][y - 1] then
        grid[x][y] = nil
        grid[x - 1][y - 1] = type
    end
end

function CheckLeft(x, y, type)
    if x > 1 and not grid[x - 1][y] then
        grid[x][y] = nil
        grid[x - 1][y] = type
    end
end

function CheckRight(x, y, type)
    if x < width and not grid[x + 1][y] then
        grid[x][y] = nil
        grid[x + 1][y] = type
    end
end


-- Special partical movements

-- Water
function WaterCheckDown(x, y, type)
    local range = math.random(1,4)
    if y < height and not grid[x][y + range] then
        grid[x][y] = nil
        grid[x][y + range] = type
    end
end

function WaterCheckDownRight(x, y, type)
    local rangeY = math.random(1,2)
    local rangeX = math.random(1,2)
    if x < width and y < height and not grid[x + rangeX][y + rangeY] then
        grid[x][y] = nil
        grid[x + rangeX][y + rangeY] = type
    end
end

function WaterCheckDownLeft(x, y, type)
    local rangeY = math.random(1,2)
    local rangeX = math.random(1,2)
    if x > 1 + rangeX and y < height and not grid[x - rangeX][y + rangeY] then
        grid[x][y] = nil
        grid[x - rangeX][y + rangeY] = type
    end
end

function WaterCheckRight(x, y, type)
    local range = math.random(1,3)
    if x + range < width and not grid[x + range][y] then
        grid[x][y] = nil
        grid[x + range][y] = type
    end
end

function WaterCheckLeft(x, y, type)
    local range = math.random(1,3)
    if x > 1 + range and not grid[x - range][y] then
        grid[x][y] = nil
        grid[x - range][y] = type
    end
end

-- Sand

-- Gas

-- Steam
function SteamCheckUp(x, y, type)
    local range = math.random(1,4)
    if y < height and not grid[x][y - range] then
        grid[x][y] = nil
        grid[x][y - range] = type
    end
end

function SteamCheckUpRight(x, y, type)
    local rangeY = math.random(1,4)
    local rangeX = math.random(1,4)
    if x < width and y < height and not grid[x + rangeX][y - rangeY] then
        grid[x][y] = nil
        grid[x + rangeX][y - rangeY] = type
    end
end

function SteamCheckUpLeft(x, y, type)
    local rangeY = math.random(1,4)
    local rangeX = math.random(1,4)
    if x > 1 + rangeX and y < height and not grid[x - rangeX][y - rangeY] then
        grid[x][y] = nil
        grid[x - rangeX][y - rangeY] = type
    end
end

function SteamCheckRight(x, y, type)
    local range = math.random(1,6)
    if x + range < width and not grid[x + range][y] then
        grid[x][y] = nil
        grid[x + range][y] = type
    end
end

function SteamCheckLeft(x, y, type)
    local range = math.random(1,6)
    if x > 1 + range and not grid[x - range][y] then
        grid[x][y] = nil
        grid[x - range][y] = type
    end
end

function SteamCheckDownRight(x, y, type)
    local rangeX = math.random(1,4)
    if x < width and y < height and not grid[x + rangeX][y + 1] then
        grid[x][y] = nil
        if math.random(1,1000) == 13 then
            grid[x + rangeX][y + 1] = 2
        else
            grid[x + rangeX][y + 1] = type
        end
    end

end

function SteamCheckDownLeft(x, y, type)
    local rangeX = math.random(1,4)
    if x > 1 + rangeX and y < height and not grid[x - rangeX][y + 1] then
        grid[x][y] = nil
        if math.random(1,1000) == 13 then
            grid[x - rangeX][y + 1] = 2
        else
            grid[x - rangeX][y + 1] = type
        end
    end
end

-- Fire
function FireCheckDown(x, y, type)

    if y < height then
        if grid[x][y + 1] == 2 then
            grid[x][y + 1] = 5
        elseif grid[x][y + 1] == 4 then
            grid[x][y + 1] = 6
        end
    end

end

function FireCheckDownRight(x, y, type)
    if x < width and y < height then
        if grid[x + 1][y + 1] == 2 then
            grid[x + 1][y + 1] = 5
        elseif grid[x + 1][y + 1] == 4 then
            grid[x + 1][y + 1] = 6
        end
    end
end

function FireCheckDownLeft(x, y, type)
    if x > 1 and y < height then
        if grid[x - 1][y + 1] == 2 then
        grid[x - 1][y + 1] = 5
        elseif grid[x - 1][y + 1] == 4 then
            grid[x - 1][y + 1] = 6
        end
    end
end

function FireCheckUp(x, y, type)
    if y > 1 then
        if not grid[x][y - 1] then
            grid[x][y] = nil
            grid[x][y - 1] = type
        elseif grid[x][y - 1] == 2 then
            grid[x][y - 1] = 5
        elseif grid[x][y - 1] == 4 then
            grid[x][y - 1] = 6
        end
    end
    if math.random(1,50) == 13 then
        grid[x][y] = nil
    end
end

function FireCheckUpRight(x, y, type)
    if x < width and y > 1 then
        if not grid[x + 1][y - 1] then
            grid[x][y] = nil
            grid[x + 1][y - 1] = type
        elseif grid[x + 1][y - 1] == 2 then
            grid[x + 1][y - 1] = 5
        elseif grid[x + 1][y - 1] == 4 then
            grid[x + 1][y - 1] = 6
        end
    end
    if math.random(1,50) == 13 then
        grid[x][y] = nil
    end
end

function FireCheckUpLeft(x, y, type)
    if x > 1 and y > 1 then
        if not grid[x - 1][y - 1] then
            grid[x][y] = nil
            grid[x - 1][y - 1] = type
        elseif grid[x - 1][y - 1] == 2 then
            grid[x - 1][y - 1] = 5
        elseif grid[x - 1][y - 1] == 4 then
            grid[x - 1][y - 1] = 6
        end
    end
    if math.random(1,50) == 13 then
        grid[x][y] = nil
    end
end

function FireCheckLeft(x, y, type)
    if x > 1 then
        if grid[x - 1][y] == 2 then
            grid[x - 1][y] = 5
        elseif grid[x - 1][y] == 4 then
            grid[x - 1][y] = 6
        end
    end
end

function FireCheckRight(x, y, type)
    if x < width then
        if grid[x + 1][y] == 2 then
            grid[x + 1][y] = 5
        elseif grid[x + 1][y] == 4 then
            grid[x + 1][y] = 6
        end
    end
end