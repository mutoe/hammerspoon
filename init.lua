hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

local hiper = require('hiper').new('rightcmd')

local features = {
  f = function() hs.application.launchOrFocus('Firefox') end,
  w = function() hs.application.launchOrFocus('Wechat') end,
  m = function() hs.application.launchOrFocus('Mail') end,
  n = function() hs.application.launchOrFocus('NetNewsWire') end,
  t = function() hs.application.launchOrFocus('iTerm') end,
  i = function() hs.application.launchOrFocus('IntelliJ IDEA') end,
  -- Pause/Play audio
  p = function() require('hs.eventtap').event.newSystemKeyEvent("PLAY", true):post() end,
}

hiper.load_features(features)

-- Use the standardized config location, if present
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.config/hammerspoon/private/config.lua')
if custom_config then
  print("Loading custom config")
  dofile(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
  privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
  if privatepath then
    hs.alert("You have config in both .config/hammerspoon and .hammerspoon/private.\nThe .config/hammerspoon one will be used.")
  end
else
  -- otherwise fallback to 'classic' location.
  if not privatepath then
    privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private')
    -- Create `~/.hammerspoon/private` directory if not exists.
    hs.fs.mkdir(hs.configdir .. '/private')
  end
  privateconf = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
  if privateconf then
    -- Load awesomeconfig file if exists
    require('private/config')
  end
end

if hsreload_keys then
  hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function() hs.reload() end)
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
if not hspoon_list then
  hspoon_list = {
    "CountDown",
    "WinWin",
  }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
  hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- countdownM modal environment
if spoon.CountDown then
  spoon.ModalMgr:new("countdownM")
  local cmodal = spoon.ModalMgr.modal_list["countdownM"]
  cmodal:bind('', 'escape', 'Deactivate countdownM', function() spoon.ModalMgr:deactivate({ "countdownM" }) end)
  cmodal:bind('', 'Q', 'Deactivate countdownM', function() spoon.ModalMgr:deactivate({ "countdownM" }) end)
  cmodal:bind('', 'S', 'Stop countdownM', function()
    spoon.CountDown:canvasCleanup()
    spoon.ModalMgr:deactivate({ "countdownM" })
  end)
  cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
  cmodal:bind('', '0', '5 Minutes Countdown', function()
    spoon.CountDown:startFor(5)
    spoon.ModalMgr:deactivate({ "countdownM" })
  end)
  for i = 1, 9 do
    cmodal:bind('', tostring(i), string.format("%s Minutes Countdown", 10 * i), function()
      spoon.CountDown:startFor(10 * i)
      spoon.ModalMgr:deactivate({ "countdownM" })
    end)
  end
  cmodal:bind('', 'return', '7 Minutes Countdown', function()
    spoon.CountDown:startFor(7)
    spoon.ModalMgr:deactivate({ "countdownM" })
  end)
  cmodal:bind('', 'space', 'Pause/Resume CountDown', function()
    spoon.CountDown:pauseOrResume()
    spoon.ModalMgr:deactivate({ "countdownM" })
  end)

  -- Register countdownM with modal supervisor
  if hscountdM_keys then
    spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "Enter countdownM Environment", function()
      spoon.ModalMgr:deactivateAll()
      -- Show the keybindings cheatsheet once countdownM is activated
      spoon.ModalMgr:activate({ "countdownM" }, "#FF6347", true)
    end)
  end
end

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
  spoon.ModalMgr:new("resizeM")
  local cmodal = spoon.ModalMgr.modal_list["resizeM"]
  cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
  cmodal:bind('', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
  cmodal:bind('', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
  cmodal:bind('', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
  cmodal:bind('', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)
  cmodal:bind('shift', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
  cmodal:bind('shift', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
  cmodal:bind('shift', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
  cmodal:bind('shift', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)
  cmodal:bind('', 'H', 'Lefthalf of Screen', function() spoon.WinWin:moveAndResize("halfleft") end)
  cmodal:bind('', 'L', 'Righthalf of Screen', function() spoon.WinWin:moveAndResize("halfright") end)
  cmodal:bind('', 'K', 'Uphalf of Screen', function() spoon.WinWin:moveAndResize("halfup") end)
  cmodal:bind('', 'J', 'Downhalf of Screen', function() spoon.WinWin:moveAndResize("halfdown") end)
  -- cmodal:bind('', 'Y', 'NorthWest Corner', function() spoon.WinWin:moveAndResize("cornerNW") end)
  -- cmodal:bind('', 'O', 'NorthEast Corner', function() spoon.WinWin:moveAndResize("cornerNE") end)
  -- cmodal:bind('', 'U', 'SouthWest Corner', function() spoon.WinWin:moveAndResize("cornerSW") end)
  -- cmodal:bind('', 'I', 'SouthEast Corner', function() spoon.WinWin:moveAndResize("cornerSE") end)
  cmodal:bind('', 'U', 'Two-fifth Left of Screen', function() spoon.WinWin:moveAndResize("twoFifthLeft") end)
  cmodal:bind('', 'I', 'Three-fifth Left of Screen', function() spoon.WinWin:moveAndResize("threeFifthLeft") end)
  cmodal:bind('', 'O', 'Two-fifth Right of Screen', function() spoon.WinWin:moveAndResize("twoFifthRight") end)
  cmodal:bind('', 'P', 'Three-fifth Right of Screen', function() spoon.WinWin:moveAndResize("threeFifthRight") end)
  cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:moveAndResize("fullscreen") end)
  cmodal:bind('', 'C', 'Center Window', function() spoon.WinWin:moveAndResize("center") end)
  cmodal:bind('', '=', 'Stretch Outward', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
  cmodal:bind('', '-', 'Shrink Inward', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)
  cmodal:bind('shift', 'H', 'Move Leftward', function() spoon.WinWin:stepResize("left") end, nil, function() spoon.WinWin:stepResize("left") end)
  cmodal:bind('shift', 'L', 'Move Rightward', function() spoon.WinWin:stepResize("right") end, nil, function() spoon.WinWin:stepResize("right") end)
  cmodal:bind('shift', 'K', 'Move Upward', function() spoon.WinWin:stepResize("up") end, nil, function() spoon.WinWin:stepResize("up") end)
  cmodal:bind('shift', 'J', 'Move Downward', function() spoon.WinWin:stepResize("down") end, nil, function() spoon.WinWin:stepResize("down") end)
  cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:moveToScreen("left") end)
  cmodal:bind('', 'right', 'Move to Right Monitor', function() spoon.WinWin:moveToScreen("right") end)
  cmodal:bind('', 'up', 'Move to Above Monitor', function() spoon.WinWin:moveToScreen("up") end)
  cmodal:bind('', 'down', 'Move to Below Monitor', function() spoon.WinWin:moveToScreen("down") end)
  cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:moveToScreen("next") end)
  cmodal:bind('', '[', 'Undo Window Manipulation', function() spoon.WinWin:undo() end)
  cmodal:bind('', ']', 'Redo Window Manipulation', function() spoon.WinWin:redo() end)
  cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

  -- Register resizeM with modal supervisor
  if hsresizeM_keys then
    spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter resizeM Environment", function()
      -- Deactivate some modal environments or not before activating a new one
      spoon.ModalMgr:deactivateAll()
      -- Show an status indicator so we know we're in some modal environment now
      spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
    end)
  end
end

----------------------------------------------------------------------------------------------------
-- cheatsheetM modal environment (Because KSheet Spoon is NOT loaded, cheatsheetM will NOT be activated)
if spoon.KSheet then
  spoon.ModalMgr:new("cheatsheetM")
  local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
  cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
    spoon.KSheet:hide()
    spoon.ModalMgr:deactivate({ "cheatsheetM" })
  end)
  cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
    spoon.KSheet:hide()
    spoon.ModalMgr:deactivate({ "cheatsheetM" })
  end)

  -- Register cheatsheetM with modal supervisor
  if hscheats_keys then
    spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "Enter cheatsheetM Environment", function()
      spoon.KSheet:show()
      spoon.ModalMgr:deactivateAll()
      spoon.ModalMgr:activate({ "cheatsheetM" })
    end)
  end
end

----------------------------------------------------------------------------------------------------
-- Register browser tab typist: Type URL of current tab of running browser in markdown format. i.e. [title](link)
if hstype_keys then
  spoon.ModalMgr.supervisor:bind(hstype_keys[1], hstype_keys[2], "Type Browser Link", function()
    local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
    local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
    if #safari_running > 0 then
      local stat, data = hs.applescript('tell application "Safari" to get {URL, name} of current tab of window 1')
      if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
    elseif #chrome_running > 0 then
      local stat, data = hs.applescript('tell application "Google Chrome" to get {URL, title} of active tab of window 1')
      if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
    end
  end)
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon console
if hsconsole_keys then
  spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "Toggle Hammerspoon Console", function() hs.toggleConsole() end)
end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
