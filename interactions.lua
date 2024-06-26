-- This file will get important in the future, but it's complete giberish right now. Please ignore this file.

if type == 5 and math.random(1, 1000) == 13 then    -- If steam, turn into water
    grid[x][y] = 2
elseif type == 6 and math.random(1, 100) == 13 then -- If fire, die
    grid[x][y] = nil

                            -- Particle interactions
                            if grid[newX][newY] == 2 and grid[newX][newY - 1] == 1 or grid[newX][newY - 1] == 3 then
                                grid[newX][newY] = grid[newX][newY - 1]
                                grid[newX][newY - 1] = 2
                            elseif type == 6 then
                                for i = -3, 3 do
                                    for j = -4, 1 do
                                        if grid[x+i][y+j] == 4 then                               -- Turn gas into fire
                                            grid[x+i][y+j] = 6
                                        elseif grid[x+i][y+j] == 2 and math.random(1,5) == 1 then -- Turn water into steam
                                            grid[x+i][y+j] = 5
                                        end
                                    end
                                end
                            end