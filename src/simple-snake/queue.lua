module = {}

function module.create()
    return {
        frontTarget = 0,
        backTarget = -1,
    }
end

function module.pushFront(queue, value)
    queue[queue.frontTarget] = value
    queue.frontTarget = queue.frontTarget + 1
end

function module.pushBack(queue, value)
    queue.backTarget = queue.backTarget - 1
    queue[queue.backTarget] = value
end

function module.popFront(queue, value)
    queue.frontTarget = queue.frontTarget - 1
    queue[queue.frontTarget] = nil
end

function module.popBack(queue, value)
    queue.backTarget = queue.backTarget + 1
    queue[queue.backTarget] = nil
end

function module.peekFront(queue, value)
    return queue[queue.frontTarget - 1]
end

function module.peekBack(queue, value)
    return queue[queue.backTarget + 1]
end

function module.iterationRange(queue)
    return {
        from = queue.backTarget + 1,
        to = queue.frontTarget - 1    
    }
end

return module