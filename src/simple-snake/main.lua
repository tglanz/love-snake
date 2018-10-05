renderer = require "renderer"
game = require "game"

local state = nil
local isFullscreen = false
local resolutionWidth = 1024
local resoluteionHeight = 768

local function setWindowMode()
    love.window.setMode(resolutionWidth, resoluteionHeight, {
        fullscreen = isFullscreen,
        fullscreentype = "desktop"
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.window.close()
    elseif key == 'space' then
        isFullscreen = not isFullscreen
        setWindowMode()
    end
    game.keyPressed(state, key)
end

function love.load(arg, unfilteredArg)
    setWindowMode()
    state = game.createState()
end

function love.update(dt)
    game.update(state)
end

function love.draw()
    renderer.render(state.arena, state.snake, state.foodPositioner.position)
end

function love.quit()
end


