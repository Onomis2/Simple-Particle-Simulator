local interactions = {}

interactions.matrix = {}

interactions.matrix[1] = interactions.matrix[1] or {}       -- Bricks
interactions.matrix[2] = interactions.matrix[2] or {}       -- Water
interactions.matrix[3] = interactions.matrix[3] or {}       -- Sand
interactions.matrix[4] = interactions.matrix[4] or {}       -- Methane
interactions.matrix[5] = interactions.matrix[5] or {}       -- Steam
interactions.matrix[6] = interactions.matrix[6] or {}       -- Fire
interactions.matrix[7] = interactions.matrix[7] or {}       -- Wood
interactions.matrix[6000] = interactions.matrix[6000] or {} -- Rotten wood
interactions.matrix[6001] = interactions.matrix[6001] or {} -- Ash

-- Determine what interaction should take place
function interactions.get(type1, type2)
    if interactions.matrix[type1] and interactions.matrix[type1][type2] then
        return interactions.matrix[type1][type2]
    else
        return interactions.default
    end
end

-- No interaction
function interactions.default(grid, x, y)
    -- Do nothing
end

-- Bricks
    -- Bricks sink in water
    interactions.matrix[1][2] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Bricks sink in gas
    interactions.matrix[1][4] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Bricks sink in steam
    interactions.matrix[1][5] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Bricks sink in fire
    interactions.matrix[1][6] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end

-- Water
    -- Water sinks in methane
    interactions.matrix[2][4] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Water sinks in steam
    interactions.matrix[2][5] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Water sinks in fire
    interactions.matrix[2][6] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end

-- Sand
    -- Sand sinks in water
    interactions.matrix[3][2] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Sand sinks in gas
    interactions.matrix[3][4] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Sand sinks in steam
    interactions.matrix[3][5] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Sand sinks in fire
    interactions.matrix[3][6] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end

-- Methane
    --Something

-- Steam
    -- Steam floats through methane
    interactions.matrix[5][4] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    --[[ Steam floats through fire
    interactions.matrix[5][6] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end]]

-- Fire
    -- Evaporate water
    interactions.matrix[6][2] = function(grid, interactX, interactY)
        if math.random(2) == 1 then grid[interactX][interactY] = 5 end
    end
    -- Burn methane
    interactions.matrix[6][4] = function(grid, interactX, interactY)
        if math.random(140) == 1 then grid[interactX][interactY] = 6 end
    end
    -- Burn wood
    interactions.matrix[6][7] = function(grid, interactX, interactY)
        if math.random(2000) == 1 then grid[interactX][interactY] = 6001 end
    end
    -- Burn rotten wood
    interactions.matrix[6][6000] = function(grid, interactX, interactY)
        if math.random(2000) == 1 then grid[interactX][interactY] = 6001 end
    end

-- Wood
    -- Start rotting when in contact with water
    interactions.matrix[7][2] = function(grid, x, y)
        if math.random(140) == 1 then grid[x][y] = 6000 end
    end

-- Rotten wood
    -- Rot spreads to more wood
    interactions.matrix[6000][7] = function(grid, interactX, interactY)
        if math.random(3000) == 1 then grid[interactX][interactY] = 6000 end
    end

-- Ash
    -- Ash sinks (for now) in water (Make it mix with water later)
    interactions.matrix[6001][2] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Ash sinks in gas
    interactions.matrix[6001][4] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Ash sinks in steam
    interactions.matrix[6001][5] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    -- Ash sinks in fire
    interactions.matrix[6001][6] = function(grid, x, y, swapX, swapY)
        grid[x][y], grid[swapX][swapY] = grid[swapX][swapY], grid[x][y]
    end
    
return interactions
