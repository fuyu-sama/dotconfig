-- utils.lua
local M = {}

function M.getIndexedSpaces()
    local scr = hs.screen.mainScreen()
    local indexedSpaces = hs.spaces.allSpaces()[scr:getUUID()]
    return indexedSpaces
end

return M