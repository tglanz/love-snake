modules = {
    queue = require "queue",
    positioner = require "positioner"   
}

local settings = {

    averageUps = 20,

    directions = {
        up = { x = 0, y = -1 },
        down = { x = 0, y = 1 },
        right = { x = 1, y = 0 },
        left = { x = -1, y = 0 },
    },
}

local function areDirectionsOpposites(a, b)
    return a.x == -1 * b.x and a.y == -1 * b.y
end

local function arePositionsEqual(a, b)
    return a.row == b.row and a.col == b.col
end

local function extendSnake(snake, direction)
    head = modules.queue.peekFront(snake)
    nextHead = { row = head.row + direction.y, col = head.col + direction.x }
    modules.queue.pushFront(snake, nextHead)
    return nextHead
end

local function trimSnake(snake)
    modules.queue.popBack(snake)
end

local function cycleSnake(snake, rows, cols)
    range = queue.iterationRange(snake)
    for idx=range.from, range.to do
        limb = snake[idx]
        limb.row = limb.row + rows
        limb.row = limb.row % rows
        limb.col = limb.col + cols
        limb.col = limb.col % cols
    end
end

local function isSnakeOverlapPositioner(snake, positioner)
    snakeRange = modules.queue.iterationRange(snake)
    for idx=snakeRange.from, snakeRange.to do
        if arePositionsEqual(snake[idx], positioner.position) then
            return true
        end
    end
    return false
end

local function isSnakeAccident(snake, checkWalls, rows, cols)
    headPosition = modules.queue.iterationRange(snake)
    range = modules.queue.iterationRange(snake)
    for idx=range.from, range.to do
        limbPosition = snake[idx]
        if arePositionsEqual(limbPosition, headPosition) then
            return true
        end
        if checkWalls then
            if (limbPosition.row >= rows) or (limbPosition.row < 0) then
                return true
            end
            if (limbPosition.col >= cols) or (limbPosition.col < 0) then
                return true
            end
        end
    end
    return false
end

function module.createState()
    arena = {
        rows = 30,
        cols = 30
    }

    snake = modules.queue.create()
    modules.queue.pushFront(snake, { row = arena.rows / 2, col = arena.cols / 2 })
    
    direction = {
        x = settings.directions.right.x,
        y = settings.directions.right.y,
    }

    return {
        lastUpdateTime = 0,
        dtForUpdates = 1 / settings.averageUps,

        arena = arena,

        pendingDirection = nil,
        direction = direction,

        isDead = false,
        snake = snake,

        foodPositioner = modules.positioner.create(3000, arena.rows, arena.cols),
        isCyclic = true
    }
end

function module.keyPressed(state, key)
    isValid = true

    local newDirection=state.direction
    if key == "up" then newDirection = settings.directions.up
    elseif key == "down" then newDirection = settings.directions.down
    elseif key == "right" then newDirection = settings.directions.right
    elseif key == "left" then newDirection = settings.directions.left
    end

    if not areDirectionsOpposites(state.direction, newDirection) then
        state.pendingDirection = newDirection
    end
end

function module.update(state)

    if state.isDead then return end

    now = love.timer.getTime()
    delta = now - state.lastUpdateTime
    if delta <= state.dtForUpdates then
        return
    end

    if state.pendingDirection ~= nil then
        state.direction.x = state.pendingDirection.x
        state.direction.y = state.pendingDirection.y
        state.pendingDirection = nil
    end

    local arena = state.arena
    local snake = state.snake
    local foodPositioner = state.foodPositioner
    local direcion = state.direction

    newHead = extendSnake(snake, direction)
    if arePositionsEqual(newHead, foodPositioner.position) then
        modules.positioner.forcedReposition(foodPositioner, arena.rows, arena.cols)
    else
        trimSnake(snake)
        modules.positioner.timelyReposition(foodPositioner, arena.rows, arena.cols)
    end

    if state.isCyclic then cycleSnake(snake, arena.rows, arena.cols) end

    if isSnakeAccident(snake, not state.isCyclic, arena.rows, arena.cols) then
        state.isDead = true
        print("DEAD")
    else
        while isSnakeOverlapPositioner(snake, foodPositioner) do
            modules.positioner.forcedReposition(foodPositioner, arena.rows, arena.cols)
        end
    end
    
    state.lastUpdateTime = love.timer.getTime()
end

return module
