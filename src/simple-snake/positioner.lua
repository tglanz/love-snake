module = { }

function module.create(autoRepositionTime, rows, cols)
    positioner = {
        autoRepositionTime = autoRepositionTime,
        updateTime = -1,

        position = {
            row = nil,
            col = nil,
        }
    }
    return positioner
end

local function reposition(positioner, rows, cols)
    positioner.position.row = love.math.random(rows - 1)
    positioner.position.col = love.math.random(cols - 1)
    positioner.updateTime = love.timer.getTime()
    print("repositioned to", positioner.position.row, positioner.position.col)
end

function module.forcedReposition(positioner, rows, cols)
    reposition(positioner, rows, cols)
end

function module.timelyReposition(positioner, rows, cols)
    if love.timer.getTime() - positioner.updateTime > positioner.autoRepositionTime then
        reposition(positioner, rows, cols)
    end
end

return module
