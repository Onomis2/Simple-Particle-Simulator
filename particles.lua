local particles = {
    [1] = { -- Default
        move = function(grid, x, y)
            local moves = {
                { x = x, y = y + 1 }
            }
            return moves
        end
    },
    [2] = { -- Water
        move = function(grid, x, y)
            local scope = math.random(1,12)
            local moves = {
                { x = x, y = y + math.random(1, 5) },
            }
            for i=1,scope do
                if grid[x + i][y] ~= nil then
                    table.insert(moves, {x = x + i - 1, y = y})
                    break
                elseif not grid[x + i][y] then
                    if not grid[x + i] [y + 1] then
                        table.insert(moves, {x = x + i, y = y + 1})
                        break
                    elseif not grid[x + i][y] and i == scope then
                        table.insert(moves, {x = x + i, y = y})
                    end
                end
            end
            for i=1,scope do
                if grid[x - i][y] ~= nil then
                    table.insert(moves, {x = x - i + 1, y = y})
                    break
                elseif not grid[x - i][y] then
                    if not grid[x - i] [y + 1] then
                        table.insert(moves, {x = x - i, y = y + 1})
                        break
                    elseif not grid[x - i][y] and i == scope then
                        table.insert(moves, {x = x - i, y = y})
                    end
                end
            end
            return moves
        end
    },
    [3] = { -- Sand
        move = function(grid, x, y)
            local moves = {
                { x = x,     y = y + 1 },
                { x = x - 1, y = y + 1 },
                { x = x + 1, y = y + 1 }
            }
            return moves
        end
    },
    [4] = { -- Gas
        move = function(grid, x, y)
            local moves = {
                { x = x,     y = y - 1 },
                { x = x - 1, y = y - 1 },
                { x = x + 1, y = y - 1 },
                { x = x,     y = y + 1 },
                { x = x - 1, y = y + 1 },
                { x = x + 1, y = y + 1 },
                { x = x - 1, y = y },
                { x = x + 1, y = y }
            }
            return moves
        end
    },
    [5] = { -- Steam
        move = function(grid, x, y)
            local moves = {
                { x = x,     y = y - 1 },
                { x = x - 1, y = y - 1 },
                { x = x + 1, y = y - 1 },
                { x = x - 1, y = y },
                { x = x + 1, y = y }
            }
            return moves
        end
    },
    [6] = { -- Fire
        move = function(grid, x, y)
            local moves = {
                { x = x - 1, y = y },
                { x = x + 1, y = y },
                { x = x,     y = y - 1 },
                { x = x - 1, y = y - 1 },
                { x = x + 1, y = y - 1 }
            }
            return moves
        end
    },
    [7] = { -- Strange Matter
        move = function(grid, x, y)
            local moves = {
                { x = math.random(1, 250), y = math.random(1, 250) },
            }
            return moves
        end
    }
}
return particles