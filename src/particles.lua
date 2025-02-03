local particles = {}
local functions = require('src.behavior')

particles[1] = {color = { 1, 1, 1 }, behavior = functions[1]} -- Brick

particles[2] = {color = { 0, 0, 1 }, behavior = functions[2]} -- Water

particles[3] = {color = { 1, 0.7, 0.2 }, behavior = functions[3]} -- Sand

particles[4] = {color = { 0, 1, 0 }, behavior = functions[4]} -- Methane

particles[5] = {color = { 0.5, 0.5, 0.5 }, behavior = functions[5]} -- Steam

particles[6] = {color = { 1, 0, 0 }, behavior = functions[6]} -- Fire

particles[7] = {color ={ 0.9, 0.6, 0.4 }, behavior = functions[7]} -- Wood

particles[6000] = { color = { 0.8, 0.5, 0.5 }, behavior = functions[6000]} -- Rotten wood

particles[6001] = {color = { 0.6, 0.6, 0.6 }, behavior = functions[6001]} -- Ash

particles[9999] = { color = { 0.3, 0.8, 0.3 }, behavior = functions[0]} -- border

return particles