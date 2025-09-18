-- spaceCtrl.lua
local utils = require("utils")
local Drag = hs.loadSpoon("Drag")

local M = {}

M.config = {
    sleepDuration = .5 * 100000,
    alertDuration = 1
}

function M.newSpace(gotoNewSpace)
    local scr = hs.screen.mainScreen()
    hs.spaces.addSpaceToScreen(scr, false)
    local indexedSpaces = utils.getIndexedSpaces()
    if gotoNewSpace then
        hs.spaces.gotoSpace(indexedSpaces[#indexedSpaces])
    end
    hs.timer.usleep(M.config.sleepDuration)
end

function M.gotoSpace(iSpace)
    local indexedSpaces = utils.getIndexedSpaces()
    local totalSpaces = #indexedSpaces
    if iSpace <= totalSpaces then
        hs.spaces.gotoSpace(indexedSpaces[iSpace])
        hs.timer.usleep(M.config.sleepDuration)
    else
        M.newSpace()
    end
end

function M.removeSpace()
    local indexedSpaces = utils.getIndexedSpaces()
    local spaceCount = #indexedSpaces
    local currentSpace = hs.spaces.focusedSpace()
    local icurrentSpace = nil
    for i, spaceID in ipairs(indexedSpaces) do
        if spaceID == currentSpace then
            icurrentSpace = i
        end
    end
    if spaceCount > 1 then
        M.gotoSpace(icurrentSpace - 1)
        hs.timer.usleep(300000)
        hs.spaces.removeSpace(currentSpace)
    end
end

-- https://github.com/mogenson/Drag.spoon
function M.moveToSpace(spaceIndex)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert("没有找到当前窗口", M.config.alertDuration)
        return false
    end

    local scr = hs.screen.mainScreen()
    local currentSpace = hs.spaces.activeSpaces()[scr:getUUID()]
    local allSpaces = utils.getIndexedSpaces()

    if spaceIndex > #allSpaces then
        M.newSpace(false)
    end

    local targetSpace = allSpaces[spaceIndex]

    if currentSpace == targetSpace then
        return true
    end

    local success = Drag:focusedWindowToSpace(targetSpace)

    return success
end

function M.init()
    hs.hotkey.bind({"alt"}, "N", M.newSpace)
    hs.hotkey.bind({"alt"}, "W", M.removeSpace)

    for i = 1, 10 do
        local key = tostring(i % 10) -- 0 对应 10
        hs.hotkey.bind({"alt"}, key, function() M.gotoSpace(i) end)
        hs.hotkey.bind({"alt", "shift"}, key, function() M.moveToSpace(i) end)
    end
end

return M