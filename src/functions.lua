local functions = {}

local callbacks = {}

function functions.registerCallback(name, func)
    callbacks[name] = func
end

function functions.resetGrid(grid, width, height)
    for x = 1, width do
        grid[x] = {}
        for y = 1, height do
            if x == 1 or y == 1 then
                grid[x][y] = 9999
            elseif x == width or y == height then
                grid[x][y] = 9999
            else
                grid[x][y] = nil
            end
        end
    end
end

function functions.mouseClick1Director(x, y)
    if x < 401 and y < 401 then
        callbacks["spawnParticle"]()
    elseif y < 401 then
        if x > 401 then
            if y < 150 then
                callbacks["selectOption"]()
            else
                callbacks["selectCategory"]()
            end
        end
    else
        callbacks["selectParticle"]()
    end
end

function functions.mouseClick2Director()
    callbacks["eraseParticle"]()
end

function functions.spawnParticle(x, y, grid, size, width, height)

    local startX = x - math.floor(size / 2)
    local startY = y - math.floor(size / 2)
    if startX < 2 then startX = 2 end
    if startY < 2 then startY = 2 end
    local endX = math.min(startX + size, width)
    local endY = math.min(startY + size, height)

    for i = startX, endX do
        for j = startY, endY do
            if not grid[i][j] then
                grid[i][j] = game.particleType
            end
        end
    end

end

function functions.eraseParticle(x, y, grid, size, width, height)

    local startX = x - math.floor(size / 2)
    local startY = y - math.floor(size / 2)
    if startX < 2 then startX = 2 end
    if startY < 2 then startY = 2 end
    local endX = math.min(startX + size - 1, width - 1)
    local endY = math.min(startY + size - 1, height - 1)

    for i = startX, endX do
        for j = startY, endY do
            if grid[i][j] and grid[i][j] ~= 9999 and grid[i][j] ~= 9998 then
                grid[i][j] = nil
            end
        end
    end

end

function functions.selectOption(mouseX, mouseY)
    -- Do nothing for now
end

function functions.selectCategory(mouseX, mouseY)
    -- Do nothing for now
end

function functions.selectParticle(mouseX, mouseY)
    -- Do nothing for now
end

return functions