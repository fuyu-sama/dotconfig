-- iterm2.lua
local M = {}

function M.createWindow()
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

function M.init()
    hs.hotkey.bind({"alt"}, "return", M.createWindow)
end

return M