-- screenSwitcher.lua
local M = {}

-- 配置选项
M.config = {
    hotkeyModifiers = {"alt"},
    moveCursor = true,
    focusWindow = true,
    showAlert = false,
    alertDuration = 1,
    cursorPosition = "center",
    activateDesktop = true
}

-- 存储每个屏幕最后的光标位置
M.lastCursorPositions = {}

-- 激活目标桌面的方法
function M.activateTargetDesktop(targetScreen)
    if not M.config.activateDesktop then
        return
    end
    
    local targetFrame = targetScreen:frame()
    local centerPos = {
        x = targetFrame.x + targetFrame.w / 2,
        y = targetFrame.y + targetFrame.h / 2
    }
    
    hs.mouse.absolutePosition(centerPos)
    
    hs.timer.doAfter(0.05, function()
        local currentPos = hs.mouse.absolutePosition()
        hs.eventtap.leftClick(currentPos, 0)
    end)
    
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
function M.findBestWindowOnScreen(targetScreen)
    local orderedWindows = hs.window.orderedWindows()
    local targetWindow = nil
    
    for _, window in ipairs(orderedWindows) do
        if window:screen() == targetScreen and
           window:isStandard() and
           window:isVisible() and
           not window:isMinimized() then
            targetWindow = window
            break
        end
    end
    
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

function M.switchScreen(direction)
    local screens = hs.screen.allScreens()
    if #screens <= 1 then 
        if M.config.showAlert then
            hs.alert("只有一个屏幕", M.config.alertDuration)
        end
        return 
    end
    
    local currentWindow = hs.window.focusedWindow()
    local currentScreen = currentWindow and currentWindow:screen() or hs.screen.mainScreen()
    
    local currentMousePos = hs.mouse.absolutePosition()
    M.lastCursorPositions[currentScreen:name()] = currentMousePos
    
    local currentIndex = 1
    for i, screen in ipairs(screens) do
        if screen == currentScreen then
            currentIndex = i
            break
        end
    end
    
    local targetIndex
    if direction == "next" then
        targetIndex = currentIndex % #screens + 1
    else
        targetIndex = currentIndex - 1
        if targetIndex < 1 then targetIndex = #screens end
    end
    
    local targetScreen = screens[targetIndex]
    
    if M.config.moveCursor then
        local targetPos
        
        if M.config.cursorPosition == "last" then
            targetPos = M.lastCursorPositions[targetScreen:name()] or 
                       {x = targetScreen:frame().x + targetScreen:frame().w / 2,
                        y = targetScreen:frame().y + targetScreen:frame().h / 2}
        elseif M.config.cursorPosition == "previous" then
            local currentFrame = currentScreen:frame()
            local targetFrame = targetScreen:frame()
            local relX = (currentMousePos.x - currentFrame.x) / currentFrame.w
            local relY = (currentMousePos.y - currentFrame.y) / currentFrame.h
            
            targetPos = {
                x = targetFrame.x + targetFrame.w * relX,
                y = targetFrame.y + targetFrame.h * relY
            }
        else
            targetPos = {
                x = targetScreen:frame().x + targetScreen:frame().w / 2,
                y = targetScreen:frame().y + targetScreen:frame().h / 2
            }
        end
        
        hs.mouse.absolutePosition(targetPos)
    end
    
    local targetWindow = M.findBestWindowOnScreen(targetScreen)
    
    if targetWindow then
        targetWindow:focus()
        if M.config.showAlert then
            hs.alert("屏幕 " .. targetIndex .. ": " .. targetWindow:application():name(), 
                     M.config.alertDuration)
        end
    else
        M.activateTargetDesktop(targetScreen)
        if M.config.showAlert then
            hs.alert("激活屏幕 " .. targetIndex, M.config.alertDuration)
        end
    end
end

function M.init()
    hs.hotkey.bind(M.config.hotkeyModifiers, "right", function() M.switchScreen("next") end)
    hs.hotkey.bind(M.config.hotkeyModifiers, "left", function() M.switchScreen("prev") end)
    hs.hotkey.bind(M.config.hotkeyModifiers, "S", function() M.switchScreen("next") end)

    if M.config.showAlert then
        hs.alert("屏幕切换器已启用 - 确保桌面激活", 2)
    end
end

return M