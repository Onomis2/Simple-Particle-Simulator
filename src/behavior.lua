local behavior = {}
local interactions = require("src.interactions")

-- No behavior
behavior[0] = function(grid)
    -- Do nothing
    return grid
end

-- Brick behavior
behavior[1] = function(grid,x,y, type)
    if grid[x] and grid[x][y + 1] == nil then
        grid[x][y] = nil
        grid[x][y + 1] = type
    else 
        local interaction = interactions.get(type, grid[x][y + 1])
        interaction(grid, x, y, x, y + 1)
    end
    return grid
end

    -- Water behavior
    behavior[2] = function(grid, x, y, type)
        local newY = y
        local newX = x

        for i = 1, 3 do
            if grid[x] and grid[x][y + i] == nil then
                newY = y + i
                grid[x][newY - 1] = nil
                grid[x][newY] = type
            else
                local interaction = interactions.get(type, grid[x][newY + 1])
                interaction(grid, x, newY, x, newY + 1)
                if grid[x][newY] ~= type then   --
                    newY = newY + 1             -- Replace for more efficient code later. As this generates a lot of lagg
                end                             --
                break
            end
        end

        local direction = math.random(2) == 1 and {1, math.random(3,9)} or {-1, math.random(-3,-9)}

        for i = direction[1], direction[2], direction[1] do
            if grid[x + i] and grid[x + i][newY] == nil then
                newX = x + i
                grid[newX - direction[1]][newY] = nil
                grid[newX][newY] = type
            else
                local interaction = interactions.get(type, grid[newX - direction[1]][newY])
                interaction(grid, newX, newY, newX - direction[1], newY)
                break
            end
        end

        return grid
    end



-- Sand behavior
behavior[3] = function(grid, x, y, type)
    if grid[x] and grid[x][y + 1] == nil then
        grid[x][y] = nil
        grid[x][y + 1] = type
    else
        local interaction = interactions.get(type, grid[x][y + 1])
        interaction(grid, x, y, x, y + 1)
    end

    local direction = math.random(2) == 1 and 1 or -1

    if grid[x + direction] and grid[x + direction][y + 1] == nil then
        grid[x][y + 1] = nil
        grid[x + direction][y + 1] = type
    else
        local interaction = interactions.get(type, grid[x + direction][y + 1])
        interaction(grid, x, y, x + direction, y + 1)
    end

    return grid
end

-- Methane behavior
behavior[4] = function(grid, x, y, type)
    local directions = { {0, 1}, {0, -1}, {1, 0}, {-1, 0} }
    local dir = directions[math.random(#directions)]
    
    local newX, newY = x + dir[1], y + dir[2]

    if not grid[newX] then grid[newX] = {} end
    if not grid[newX][newY] then
        grid[x][y] = nil
        grid[newX][newY] = type
    end

    return grid
end

-- Steam behavior
behavior[5] = function(grid, x, y, type)

    if math.random(1,5000) == 1 then
        grid[x][y] = 2
        return grid
    end

    local newY = y
    local newX = x

    for i = 1, 3 do
        if grid[x] and grid[x][y - i] == nil then
            newY = y -i
            grid[x][newY + 1] = nil
            grid[x][newY] = type
        else
            local interaction = interactions.get(type, grid[x][newY - 1])
            interaction(grid, x, newY, x, newY - 1)
            if grid[x][newY] ~= type then   --
                newY = newY - 1             -- Replace for more efficient code later. As this generates a lot of lagg
            end                             --
            break
        end
    end

    local direction = math.random(2) == 1 and {1, math.random(3,9)} or {-1, math.random(-3,-9)}

    for i = direction[1], direction[2], direction[1] do
        if grid[x + i] and grid[x + i][newY] == nil then
            newX = x + i
            grid[newX - direction[1]][newY] = nil
            grid[newX][newY] = type
        else
            local interaction = interactions.get(type, grid[newX - direction[1]][newY])
            interaction(grid, newX, newY, newX - direction[1], newY)
            break
        end
    end

    return grid
end

-- Fire behavior
behavior[6] = function(grid, x, y, type)
    local newY = 0

    -- Chance do extinguish
    if math.random(1,70) == 1 then grid[x][y] = nil return grid end
    
    -- Interact with environment
    for i=-5,5 do
        for j=-5,5 do
            if grid[x + i] and grid[x + i][y + j] then
                local interaction = interactions.get(type, grid[x + i][y + j])
                interaction(grid, x + i, y + j)
            end
        end
    end

    if grid[x] and grid[x][y - 1] == nil then
        grid[x][y] = nil
        grid[x][y - 1] = type
        newY = y - 1
    else
        local interaction = interactions.get(type, grid[x][y - 1])
        interaction(grid, x, y, x, newY)
        if grid[x][y] ~= type then
            newY = newY - 1             -- Replace for more efficient code later. As this generates a lot of lagg
        end
    end

    local direction = math.random(2) == 1 and 1 or -1

    if grid[x + direction] and grid[x + direction][newY] == nil then
        grid[x][newY] = nil
        grid[x + direction][newY] = type
    else
        local interaction = interactions.get(type, grid[x + direction][y + 1])
        interaction(grid, x, y, x + direction, newY)
    end

    return grid
end

-- Wood behavior
behavior[7] = function(grid, x, y, type)

    --Interact with environment
    for i=-1,1 do
        for j=-1,1 do
            local interaction = interactions.get(type, grid[x + i][y + j])
            interaction(grid, x, y, x + i, y + j)
        end
    end

    return grid
end

-- Rotten wood
behavior[6000] = function(grid, x, y, type)

    --Interact with environment
    for i=-1,1 do
        for j=-1,1 do
            local interaction = interactions.get(type, grid[x + i][y + j])
            interaction(grid, x + i, y + j)
        end
    end

    -- Exfoliate methane
    if math.random(5000) == 1 and grid[x][y - 1] == nil then grid[x][y - 1] = 4 end

    -- Very small chance to disintegrate/be completely comsumed by rot
    if math.random(75000) == 1 then grid[x][y] = nil end

    return grid
end

-- Ash
behavior[6001] = function(grid, x, y, type)
    
    if grid[x] and grid[x][y + 1] == nil then
        grid[x][y] = nil
        grid[x][y + 1] = type
    else
        local interaction = interactions.get(type, grid[x][y + 1])
        interaction(grid, x, y, x, y + 1)
    end

    local direction = math.random(2) == 1 and 1 or -1

    if grid[x + direction] and grid[x + direction][y + 1] == nil then
        grid[x][y + 1] = nil
        grid[x + direction][y + 1] = type
    else
        local interaction = interactions.get(type, grid[x + direction][y + 1])
        interaction(grid, x, y, x + direction, y + 1)
    end

    return grid
end

return behavior