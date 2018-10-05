

function love.focus(isFocused)
    print("focused: ", isFocused)
end

function love.visible(isVisible)
    print("visible: ", isVisible)
end

function love.mousefocus(isFocused)
    print("mousefocus: ", isFocused)
end

function love.errorhandler(errorMessage)
    print("error handler: ", errorMessage)
end

function love.keypressed(key, scanCode, isRepeat)
    print("keypressed: ", key, scanCode, isRepeat)
end

function love.keyreleased(key, scanCode)
    print("keyreleased: ", key, scanCode)
end

function love.load(arg, unfilteredArg)
    print("load: ", arg, unfilteredArg)
end

function love.mousemoved(x, y, dx, dy, isTouch)
    print("mousemoved: ", x, y, dx, dy, isTouch)
end

function love.mousepressed(x, y, button, isTouch, presses)
    print("mousepressed: ", x, y, dx, dy, isTouch, presses)
end

function love.mousereleased(x, y, button, isTouch, presses)
    print("mousereleased: ", x, y, button, isTouch, presses)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.window.close()
    elseif love.keyboard.isDown("space") then
        rows = rows + 1
    end
end

function love.draw()
    love.graphics.print(string.format("rows %i", rows), 400, 300)
end

function love.quit()
    abortClose = false
    return abortClose
end


