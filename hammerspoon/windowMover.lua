-- windowMover.lua
local M = {}

M.config = {
    hotkeyModifiers = {"alt", "shift"},
    showAlert = false
}

function M.moveWindowToNextScreenKeepRelative()
    local win = hs.window.focusedWindow()
    if not win then
        if M.config.showAlert then
            hs.alert.show("没有激活窗口")
        end
        return
    end

    local curScreen = win:screen()
    if not curScreen then
        if M.config.showAlert then
            hs.alert.show("无法获取窗口所在屏幕")
        end
        return
    end

    local allScreens = hs.screen.allScreens()
    if #allScreens < 2 then
        if M.config.showAlert then
            hs.alert.show("只有一个屏幕")
        end
        return
    end

    local curIndex = nil
    for i, s in ipairs(allScreens) do
        if s == curScreen then
            curIndex = i
            break
        end
    end
    if not curIndex then
        if M.config.showAlert then
            hs.alert.show("找不到当前屏幕索引")
        end
        return
    end
    local nextIndex = curIndex % #allScreens + 1
    local nextScreen = allScreens[nextIndex]

    local screenFrame = curScreen:frame()
    local winFrame = win:frame()

    local rel = {
        x = (winFrame.x - screenFrame.x) / screenFrame.w,
        y = (winFrame.y - screenFrame.y) / screenFrame.h,
        w = winFrame.w / screenFrame.w,
        h = winFrame.h / screenFrame.h
    }

    local nextFrame = nextScreen:frame()
    local newFrame = {
        x = math.floor(nextFrame.x + rel.x * nextFrame.w + 0.5),
        y = math.floor(nextFrame.y + rel.y * nextFrame.h + 0.5),
        w = math.floor(rel.w * nextFrame.w + 0.5),
        h = math.floor(rel.h * nextFrame.h + 0.5)
    }

    win:setFrame(newFrame)
end

function M.init()
    hs.hotkey.bind(M.config.hotkeyModifiers, "s", M.moveWindowToNextScreenKeepRelative)
end

return M