-- inputSwitcher.lua
local M = {}

M.config = {
    englishApps = {"iTerm2", "Terminal", "Hyper", "Alacritty", "Code"},
    chineseApps = {"QQ", "微信", "Cherry Studio"},
    englishInputMethod = "com.apple.keylayout.ABC",
    chineseInputMethod = "com.apple.inputmethod.SCIM.ITABC",
    showAlert = false
}

function M.getCurrentApp()
    return hs.application.frontmostApplication():name()
end

function M.switchInputMethod(inputMethod)
    hs.keycodes.currentSourceID(inputMethod)
    if M.config.showAlert then
        hs.alert.show("Switched to " .. inputMethod)
    end
end

function M.init()
    appWatcher = hs.application.watcher.new(function(appName, eventType, app)
        if eventType == hs.application.watcher.activated then
            if hs.fnutils.contains(M.config.englishApps, appName) then
                M.switchInputMethod(M.config.englishInputMethod)
            elseif hs.fnutils.contains(M.config.chineseApps, appName) then
                M.switchInputMethod(M.config.chineseInputMethod)
            else
                if M.config.showAlert then
                    hs.alert.show("No matching app found")
                end
            end
        end
    end)
    appWatcher:start()
end

return M