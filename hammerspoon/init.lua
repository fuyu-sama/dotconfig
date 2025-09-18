-- utils
local function getIndexedSpaces()
    local scr = hs.screen.mainScreen()
    local indexedSpaces = hs.spaces.allSpaces()[scr:getUUID()]
    return indexedSpaces
end


-- space control 模块
local spaceCtrl = {}

spaceCtrl.config = {
    sleepDuration = .5 * 100000,
    alertDuration = 1
}

function spaceCtrl.newSpace()
    local scr = hs.screen.mainScreen()
    hs.spaces.addSpaceToScreen(scr, false)
    local indexedSpaces = getIndexedSpaces()
    hs.spaces.gotoSpace(indexedSpaces[#indexedSpaces])
    hs.timer.usleep(spaceCtrl.config.sleepDuration)
end

function spaceCtrl.gotoSpace(iSpace)
    local indexedSpaces = getIndexedSpaces()
    local totalSpaces = #indexedSpaces
    if iSpace <= totalSpaces then
        hs.spaces.gotoSpace(indexedSpaces[iSpace])
        hs.timer.usleep(spaceCtrl.config.sleepDuration)
    else
        spaceCtrl.newSpace()
    end
end

function spaceCtrl.removeSpace()
    local indexedSpaces = getIndexedSpaces()
    local spaceCount = #indexedSpaces
    local currentSpace = hs.spaces.focusedSpace()
    local icurrentSpace = nil
    for i, spaceID in ipairs(indexedSpaces) do
        if spaceID == currentSpace then
            icurrentSpace = i
        end
    end
    if spaceCount > 1 then
        spaceCtrl.gotoSpace(icurrentSpace - 1)
        hs.timer.usleep(300000)
        hs.spaces.removeSpace(currentSpace)
    end
end

-- https://github.com/mogenson/Drag.spoon
Drag = hs.loadSpoon("Drag")
function spaceCtrl.moveToSpace(spaceIndex)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert("没有找到当前窗口", spaceCtrl.config.alertDuration)
        return false
    end

    local scr = hs.screen.mainScreen()
    local currentSpace = hs.spaces.activeSpaces()[scr:getUUID()]
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

function spaceCtrl.init()
    hs.hotkey.bind({"alt"}, "N", spaceCtrl.newSpace)
    hs.hotkey.bind({"alt"}, "W", spaceCtrl.removeSpace)

    hs.hotkey.bind({"alt"}, "1", function() spaceCtrl.gotoSpace(1) end)
    hs.hotkey.bind({"alt"}, "2", function() spaceCtrl.gotoSpace(2) end)
    hs.hotkey.bind({"alt"}, "3", function() spaceCtrl.gotoSpace(3) end)
    hs.hotkey.bind({"alt"}, "4", function() spaceCtrl.gotoSpace(4) end)
    hs.hotkey.bind({"alt"}, "5", function() spaceCtrl.gotoSpace(5) end)
    hs.hotkey.bind({"alt"}, "6", function() spaceCtrl.gotoSpace(6) end)
    hs.hotkey.bind({"alt"}, "7", function() spaceCtrl.gotoSpace(7) end)
    hs.hotkey.bind({"alt"}, "8", function() spaceCtrl.gotoSpace(8) end)
    hs.hotkey.bind({"alt"}, "9", function() spaceCtrl.gotoSpace(9) end)
    hs.hotkey.bind({"alt"}, "0", function() spaceCtrl.gotoSpace(10) end)


    hs.hotkey.bind({"alt", "shift"}, "1", function() spaceCtrl.moveToSpace(1) end)
    hs.hotkey.bind({"alt", "shift"}, "2", function() spaceCtrl.moveToSpace(2) end)
    hs.hotkey.bind({"alt", "shift"}, "3", function() spaceCtrl.moveToSpace(3) end)
    hs.hotkey.bind({"alt", "shift"}, "4", function() spaceCtrl.moveToSpace(4) end)
    hs.hotkey.bind({"alt", "shift"}, "5", function() spaceCtrl.moveToSpace(5) end)
    hs.hotkey.bind({"alt", "shift"}, "6", function() spaceCtrl.moveToSpace(6) end)
    hs.hotkey.bind({"alt", "shift"}, "7", function() spaceCtrl.moveToSpace(7) end)
    hs.hotkey.bind({"alt", "shift"}, "8", function() spaceCtrl.moveToSpace(8) end)
    hs.hotkey.bind({"alt", "shift"}, "9", function() spaceCtrl.moveToSpace(9) end)
    hs.hotkey.bind({"alt", "shift"}, "0", function() spaceCtrl.moveToSpace(0) end)
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
        return false
    end

    return true
end

function iterm2.init()
    hs.hotkey.bind({"alt"}, "return", function() iterm2.createWindow() end)
end


-- 改进版屏幕切换器（确保激活目标桌面）
local screenSwitcher = {}

-- 配置选项
screenSwitcher.config = {
    hotkeyModifiers = {"alt"},
    moveCursor = true,          -- 是否移动光标
    focusWindow = true,         -- 是否聚焦窗口
    showAlert = false,           -- 是否显示提示
    alertDuration = 1,          -- 提示显示时间
    cursorPosition = "center",  -- 光标位置: "center", "previous", "last"
    activateDesktop = true      -- 确保激活目标桌面
}

-- 存储每个屏幕最后的光标位置
screenSwitcher.lastCursorPositions = {}

-- 激活目标桌面的方法
function screenSwitcher.activateTargetDesktop(targetScreen)
    if not screenSwitcher.config.activateDesktop then
        return
    end
    
    -- 方法1: 使用系统事件激活桌面
    local targetFrame = targetScreen:frame()
    local centerPos = {
        x = targetFrame.x + targetFrame.w / 2,
        y = targetFrame.y + targetFrame.h / 2
    }
    
    -- 确保鼠标在目标屏幕上
    hs.mouse.absolutePosition(centerPos)
    
    -- 方法2: 模拟点击来激活桌面
    hs.timer.doAfter(0.05, function()
        local currentPos = hs.mouse.absolutePosition()
        hs.eventtap.leftClick(currentPos, 0)
    end)
    
    -- 方法3: 使用AppleScript激活Finder（确保桌面激活）
    hs.timer.doAfter(0.1, function()
        local applescript = [[
        tell application "Finder"
            activate
            set visible of front window to false
        end tell
        ]]
        hs.osascript.applescript(applescript)
    end)
end

-- 获取目标屏幕上最合适的窗口
function screenSwitcher.findBestWindowOnScreen(targetScreen)
    local orderedWindows = hs.window.orderedWindows()
    local targetWindow = nil
    
    -- 首先尝试找到标准窗口
    for _, window in ipairs(orderedWindows) do
        if window:screen() == targetScreen and
           window:isStandard() and
           window:isVisible() and
           not window:isMinimized() then
            targetWindow = window
            break
        end
    end
    
    -- 如果没有标准窗口，尝试找到任何可见窗口
    if not targetWindow then
        for _, window in ipairs(orderedWindows) do
            if window:screen() == targetScreen and
               window:isVisible() and
               not window:isMinimized() then
                targetWindow = window
                break
            end
        end
    end
    
    -- 如果还是没有窗口，尝试找到桌面（Finder）
    if not targetWindow then
        local allWindows = hs.window.allWindows()
        for _, window in ipairs(allWindows) do
            if window:screen() == targetScreen and
               window:application() and
               window:application():name() == "Finder" then
                targetWindow = window
                break
            end
        end
    end
    
    return targetWindow
end

function screenSwitcher.switchScreen(direction)
    local screens = hs.screen.allScreens()
    if #screens <= 1 then 
        if screenSwitcher.config.showAlert then
            hs.alert("只有一个屏幕", screenSwitcher.config.alertDuration)
        end
        return 
    end
    
    -- 获取当前屏幕
    local currentWindow = hs.window.focusedWindow()
    local currentScreen = currentWindow and currentWindow:screen() or hs.screen.mainScreen()
    
    -- 保存当前屏幕的光标位置
    local currentMousePos = hs.mouse.absolutePosition()
    screenSwitcher.lastCursorPositions[currentScreen:name()] = currentMousePos
    
    -- 查找当前屏幕索引
    local currentIndex = 1
    for i, screen in ipairs(screens) do
        if screen == currentScreen then
            currentIndex = i
            break
        end
    end
    
    -- 计算目标屏幕索引
    local targetIndex
    if direction == "next" then
        targetIndex = currentIndex % #screens + 1
    else
        targetIndex = currentIndex - 1
        if targetIndex < 1 then targetIndex = #screens end
    end
    
    local targetScreen = screens[targetIndex]
    
    -- 移动光标
    if screenSwitcher.config.moveCursor then
        local targetPos
        
        if screenSwitcher.config.cursorPosition == "last" then
            -- 使用上次在该屏幕的位置
            targetPos = screenSwitcher.lastCursorPositions[targetScreen:name()] or 
                       {x = targetScreen:frame().x + targetScreen:frame().w / 2,
                        y = targetScreen:frame().y + targetScreen:frame().h / 2}
        elseif screenSwitcher.config.cursorPosition == "previous" then
            -- 使用相对位置（保持与当前屏幕的相对位置）
            local currentFrame = currentScreen:frame()
            local targetFrame = targetScreen:frame()
            local relX = (currentMousePos.x - currentFrame.x) / currentFrame.w
            local relY = (currentMousePos.y - currentFrame.y) / currentFrame.h
            
            targetPos = {
                x = targetFrame.x + targetFrame.w * relX,
                y = targetFrame.y + targetFrame.h * relY
            }
        else
            -- 使用中心位置
            targetPos = {
                x = targetScreen:frame().x + targetScreen:frame().w / 2,
                y = targetScreen:frame().y + targetScreen:frame().h / 2
            }
        end
        
        hs.mouse.absolutePosition(targetPos)
    end
    
    -- 查找并聚焦窗口
    local targetWindow = screenSwitcher.findBestWindowOnScreen(targetScreen)
    
    if targetWindow then
        -- 有窗口，聚焦它
        targetWindow:focus()
        if screenSwitcher.config.showAlert then
            hs.alert("屏幕 " .. targetIndex .. ": " .. targetWindow:application():name(), 
                     screenSwitcher.config.alertDuration)
        end
    else
        -- 没有窗口，激活桌面
        screenSwitcher.activateTargetDesktop(targetScreen)
        if screenSwitcher.config.showAlert then
            hs.alert("激活屏幕 " .. targetIndex, screenSwitcher.config.alertDuration)
        end
    end
end

-- 初始化
function screenSwitcher.init()
    hs.hotkey.bind(
        screenSwitcher.config.hotkeyModifiers, "right",
        function() screenSwitcher.switchScreen("next") end
    )
    
    hs.hotkey.bind(
        screenSwitcher.config.hotkeyModifiers, "left",
        function() screenSwitcher.switchScreen("prev") end
    )

    hs.hotkey.bind(
        screenSwitcher.config.hotkeyModifiers, "S",
        function() screenSwitcher.switchScreen("next") end
    )

    if screenSwitcher.config.showAlert then
        hs.alert("屏幕切换器已启用 - 确保桌面激活", 2)
    end
end


local inputSwitcher = {}
-- 定义要监控的终端应用名称
inputSwitcher.config = {
    englishApps = {"iTerm2", "Terminal", "Hyper", "Alacritty", "Code"},
    chineseApps = {"QQ", "微信", "Cherry Studio"},
    englishInputMethod = "com.apple.keylayout.ABC",
    chineseInputMethod = "com.apple.inputmethod.SCIM.ITABC",
    showAlert = false
}

-- 定义输入法状态

-- 获取当前应用
function inputSwitcher.getCurrentApp()
    return hs.application.frontmostApplication():name()
end

-- 切换输入法
function inputSwitcher.switchInputMethod(inputMethod)
    hs.keycodes.currentSourceID(inputMethod)
    if inputSwitcher.config.showAlert then
        hs.alert.show("Switched to " .. inputMethod)
    end
end

-- 监控应用切换事件
function inputSwitcher.init()
    appWatcher = hs.application.watcher.new(function(appName, eventType, app)
        if eventType == hs.application.watcher.activated then
            if hs.fnutils.contains(inputSwitcher.config.englishApps, appName) then
                inputSwitcher.switchInputMethod(inputSwitcher.config.englishInputMethod)
            elseif hs.fnutils.contains(inputSwitcher.config.chineseApps, appName) then
                inputSwitcher.switchInputMethod(inputSwitcher.config.chineseInputMethod)
            else
                if inputSwitcher.config.showAlert then
                    hs.alert.show("No matching app found")
                end
            end
        end
    end)
    appWatcher:start()
end


local function getFrontApp()
    local frontApp = hs.application.frontmostApplication()
    print(frontApp:name())
    hs.alert(frontApp:name())
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "C", getFrontApp)


-- 将当前窗口移动到下一个屏幕（显示器），保持在屏幕上的相对位置与大小
local windowMover = {}
windowMover.config = {
    hotkeyModifiers = {"alt", "shift"},
    showAlert = false
}
local mash = {"alt", "shift"} -- Option = alt, Shift = shift

function windowMover.moveWindowToNextScreenKeepRelative()
    local win = hs.window.focusedWindow()
    if not win then
        if windowMover.showAlert then
            hs.alert.show("没有激活窗口")
        end
        return
    end

    local curScreen = win:screen()
    if not curScreen then
        if windowMover.showAlert then
            hs.alert.show("无法获取窗口所在屏幕")
        end
        return
    end

    local allScreens = hs.screen.allScreens()
    if #allScreens < 2 then
        if windowMover.showAlert then
            hs.alert.show("只有一个屏幕")
        end
        return
    end

    -- 找到当前屏幕在所有屏幕数组中的索引，然后取下一个（循环）
    local curIndex = nil
    for i, s in ipairs(allScreens) do
        if s == curScreen then
            curIndex = i
            break
        end
    end
    if not curIndex then
        if windowMover.showAlert then
            hs.alert.show("找不到当前屏幕索引")
        end
        return
    end
    local nextIndex = curIndex % #allScreens + 1
    local nextScreen = allScreens[nextIndex]

    -- 计算窗口在当前屏幕的相对位置（归一化为0-1）
    local screenFrame = curScreen:frame()
    local winFrame = win:frame()

    local rel = {
        x = (winFrame.x - screenFrame.x) / screenFrame.w,
        y = (winFrame.y - screenFrame.y) / screenFrame.h,
        w = winFrame.w / screenFrame.w,
        h = winFrame.h / screenFrame.h
    }

    -- 将窗口移动到下一个屏幕并按相对位置/大小设置
    local nextFrame = nextScreen:frame()
    local newFrame = {
        x = math.floor(nextFrame.x + rel.x * nextFrame.w + 0.5),
        y = math.floor(nextFrame.y + rel.y * nextFrame.h + 0.5),
        w = math.floor(rel.w * nextFrame.w + 0.5),
        h = math.floor(rel.h * nextFrame.h + 0.5)
    }

    win:setFrame(newFrame)
end

function windowMover.init()
    hs.hotkey.bind(
        windowMover.config.hotkeyModifiers, "s",
        windowMover.moveWindowToNextScreenKeepRelative
    )
end


-- 启动
spaceCtrl.init()
iterm2.init()
screenSwitcher.init()
inputSwitcher.init()
windowMover.init()