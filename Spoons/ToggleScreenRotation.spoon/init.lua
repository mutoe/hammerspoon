--- === ToggleScreenRotation ===
---
--- Toggle rotation on external screens
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ToggleScreenRotation.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ToggleScreenRotation.spoon.zip)
---
--- Makes the following simplifying assumptions:
--- * That you only toggle between two positions for rotated/not
--- rotated (configured in `rotating_angles`, and which apply to all
--- screens)
--- * That "rotated" means "taller than wider", for the purposes of
--- determining if the screen is rotated upon initialization.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ToggleScreenRotation"
obj.version = "0.1"
obj.author = "Diego Zamboni <diego@zzamboni.org>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Spoon self.logger
obj.logger = hs.logger.new('ToggleScreenRotation')

--- ToggleScreenRotation.rotating_angles
--- Variable
--- Two-element table containing the rotation angles for "normal" and "rotated". Defaults to `{ 0, 90 }` and should only be changed if you really know what you are doing.
obj.rotating_angles = { 0, 90 }

-- Internal variable caching the IDs of screens that are currently rotated.
obj._rotated = {}

function obj:setRotation(scrname, rotate)
  self._rotated[scrname] = rotate
  hs.screen.find(scrname):rotate(self.rotating_angles[self._rotated[scrname] and 2 or 1])
end

function obj:toggleRotation(scrname)
  obj:setRotation(scrname, not self._rotated[scrname])
end

return obj
