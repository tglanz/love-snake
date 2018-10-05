math = require 'math'
queue = require 'queue'

local settings = {
    backColor = { .6, .6, .6, 1 },

    tile = {
        border = {
            horizontalColor = { .9, .9, .9, 1 },
            vertialColor = { .9, .9, .9, 1 }
        }
    },

    snake = {
        limb = {
            color = { .2, .7, .1, 1 },
            corner = { x = .4, y = .4 },
        }
    },

    food = {
        color = { .8, .2, .2, 1 },
        corner = { x = .4, y = .4 },
    },
}

function module.render(arena, snake, foodPosition)

    tileHeight = love.graphics.getHeight() / arena.rows
    tileWidth = love.graphics.getWidth() / arena.cols

    love.graphics.clear(settings.backColor)

    love.graphics.setColor(settings.tile.border.horizontalColor)
    for row=0, arena.rows - 1 do
        y = row * tileHeight
        love.graphics.line(0, y, love.graphics.getWidth(), y)
    end

    love.graphics.setColor(settings.tile.border.vertialColor)
    for col=0, arena.cols - 1 do
        x = col * tileWidth
        love.graphics.line(x, 0, x, love.graphics.getHeight())
    end

    love.graphics.setColor(settings.snake.limb.color)
    range = queue.iterationRange(snake)
    for idx = range.from, range.to do
        position = snake[idx]
        x = position.col * tileWidth
        y = position.row * tileHeight
        love.graphics.rectangle(
            "fill",
            x, y,
            tileWidth, tileHeight,
            settings.snake.limb.corner.x, settings.snake.limb.corner.y
        )
    end

    love.graphics.setColor(settings.food.color)
    x = foodPosition.col * tileWidth
    y = foodPosition.row * tileHeight
    love.graphics.rectangle(
        "fill",
        x, y,
        tileWidth, tileHeight,
        settings.food.corner.x, settings.food.corner.y
    )
end

return module