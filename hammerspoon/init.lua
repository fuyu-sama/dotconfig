-- init.lua
-- 导入所有模块
local utils = require("utils")
local spaceCtrl = require("spaceCtrl")
local iterm2 = require("iterm2")
local screenSwitcher = require("screenSwitcher")
local inputSwitcher = require("inputSwitcher")
-- local windowMover = require("windowMover")
-- 启动所有模块
spaceCtrl.init()
iterm2.init()
screenSwitcher.init()
inputSwitcher.init()
-- windowMover.init()