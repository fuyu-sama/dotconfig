local spaces = require("hs.spaces")
local hotkey = require("hs.hotkey")
local screen = require("hs.screen")

-- https://github.com/mogenson/Drag.spoon
Drag = hs.loadSpoon("Drag")

local function getIndexedSpaces()
    local scr = screen.mainScreen()
    local indexedSpaces = spaces.allSpaces()[scr:getUUID()]
    return indexedSpaces
end

local function newSpace()
    local scr = screen.mainScreen()
    spaces.addSpaceToScreen(scr, false)
    local indexedSpaces = getIndexedSpaces()
    spaces.gotoSpace(indexedSpaces[#indexedSpaces])
    hs.timer.usleep(300000)
    hs.alert("桌面" .. #indexedSpaces)
end

local function gotoSpaceEnhance(iSpace)
    local indexedSpaces = getIndexedSpaces()
    local totalSpaces = #indexedSpaces
    if iSpace <= totalSpaces then
        spaces.gotoSpace(indexedSpaces[iSpace])
        hs.timer.usleep(300000)
        hs.alert("桌面" .. iSpace)
    else
        newSpace()
    end
end

local function removeSpace()
    local indexedSpaces = getIndexedSpaces()
    local spaceCount = #indexedSpaces
    local currentSpace = spaces.focusedSpace()
    local icurrentSpace = nil
    for i, spaceID in ipairs(indexedSpaces) do
        if spaceID == currentSpace then
            icurrentSpace = i
        end
    end
    if spaceCount > 1 then
        gotoSpaceEnhance(icurrentSpace - 1)
        hs.timer.usleep(300000)
        spaces.removeSpace(currentSpace)
    end
end

-- Function to move window to space using mouse drag simulation
-- https://github.com/Hammerspoon/hammerspoon/issues/3698#issuecomment-3030151832
local function moveWindowToSpaceByDrag(spaceNumber)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end
    
    -- Calculate window header position (near top-left)
    local frame = win:frame()
    local headerX = frame.x + 15
    local headerY = frame.y + 15
    
    -- Store current mouse position
    local currentMouse = hs.mouse.absolutePosition()
    
    -- Move mouse to window header
    hs.mouse.absolutePosition({x = headerX, y = headerY})
    hs.timer.usleep(10000)  -- Wait 10ms
    
    -- Mouse down (press and hold)
    local mouseDown = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, {x = headerX, y = headerY})
    mouseDown:post()
    hs.timer.usleep(10000)  -- Wait 10ms
    
    -- Press Alt + number key (while holding mouse)
    hs.eventtap.keyStroke({"ctrl"}, tostring(spaceNumber), 0)
    hs.timer.usleep(10000)  -- Wait 10ms
    
    -- Mouse up (release)
    local mouseUp = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, {x = headerX, y = headerY})
    mouseUp:post()
    hs.timer.usleep(10000)  -- Wait 10ms
    
    -- Restore original mouse position
    hs.mouse.absolutePosition(currentMouse)
    
    hs.alert.show("Moved window to space " .. spaceNumber)
end

local function moveWindowToSpace(spaceIndex)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert("没有找到当前窗口")
        return false
    end
    
    local scr = screen.mainScreen()
    local currentSpace = spaces.activeSpaces()[scr:getUUID()]
    local allSpaces = spaces.allSpaces()[scr:getUUID()]
    
    if spaceIndex < 1 or spaceIndex > #allSpaces then
        hs.alert("Space " .. spaceIndex .. " 不存在")
        return false
    end
    
    local targetSpace = allSpaces[spaceIndex]
    
    if currentSpace == targetSpace then
        hs.alert("窗口已经在 Space " .. spaceIndex)
        return true
    end
    
    local success = Drag:focusedWindowToSpace(targetSpace)
    
    if success then
        hs.alert("已将窗口移动到 Space " .. spaceIndex)
        return true
    else
        hs.alert("移动窗口到 Space " .. spaceIndex .. " 失败")
        return false
    end
end

hotkey.bind({"alt"}, "N", newSpace)
hotkey.bind({"alt"}, "D", removeSpace)

hotkey.bind({"alt"}, "1", function() gotoSpaceEnhance(1) end)
hotkey.bind({"alt"}, "2", function() gotoSpaceEnhance(2) end)
hotkey.bind({"alt"}, "3", function() gotoSpaceEnhance(3) end)
hotkey.bind({"alt"}, "4", function() gotoSpaceEnhance(4) end)
hotkey.bind({"alt"}, "5", function() gotoSpaceEnhance(5) end)
hotkey.bind({"alt"}, "6", function() gotoSpaceEnhance(6) end)
hotkey.bind({"alt"}, "7", function() gotoSpaceEnhance(7) end)
hotkey.bind({"alt"}, "8", function() gotoSpaceEnhance(8) end)
hotkey.bind({"alt"}, "9", function() gotoSpaceEnhance(9) end)
hotkey.bind({"alt"}, "0", function() gotoSpaceEnhance(10) end)

hotkey.bind({"alt", "shift"}, "1", function() moveWindowToSpace(1) end)
hotkey.bind({"alt", "shift"}, "2", function() moveWindowToSpace(2) end)
hotkey.bind({"alt", "shift"}, "3", function() moveWindowToSpace(3) end)
hotkey.bind({"alt", "shift"}, "4", function() moveWindowToSpace(4) end)
hotkey.bind({"alt", "shift"}, "5", function() moveWindowToSpace(5) end)
hotkey.bind({"alt", "shift"}, "6", function() moveWindowToSpace(6) end)
hotkey.bind({"alt", "shift"}, "7", function() moveWindowToSpace(7) end)
hotkey.bind({"alt", "shift"}, "8", function() moveWindowToSpace(8) end)
hotkey.bind({"alt", "shift"}, "9", function() moveWindowToSpace(9) end)
hotkey.bind({"alt", "shift"}, "0", function() moveWindowToSpace(0) end)