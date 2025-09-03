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

local function moveWindowToSpace(spaceIndex)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert("没有找到当前窗口")
        return false
    end

    local scr = screen.mainScreen()
    local currentSpace = spaces.activeSpaces()[scr:getUUID()]
    local allSpaces = getIndexedSpaces()

    if spaceIndex > #allSpaces then
        newSpace()
    end

    local targetSpace = allSpaces[spaceIndex]

    if currentSpace == targetSpace then
        return true
    end

    local success = Drag:focusedWindowToSpace(targetSpace)

    return success
end

-- iTerm2 控制模块
local iterm2 = {}

function iterm2.createWindow()
    local applescript = [[
        tell application "iTerm2"
            try
                set newWindow to (create window with default profile)
                activate
                return "success"
            on error errMsg
                return "error: " & errMsg
            end try
        end tell
    ]]

    local ok, result = hs.osascript.applescript(applescript)

    if not ok or string.find(result or "", "error:") then
        hs.alert("❌ 创建 iTerm2 失败", 2)
        return false
    end

    return true
end

hotkey.bind({"alt"}, "return", function() iterm2.createWindow() end)
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
