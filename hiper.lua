local realFlagMask = {
  [0x37] = 8, -- lcmd  0000 1000
  [0x36] = 16, -- rcmd 0001 0000
  [0x3a] = 32, -- lalt 0010 0000
  [0x3d] = 64, -- ralt 0100 0000
  [0x3b] = 1, -- lctrl 0000 0001
  [0x3e] = 8192, -- rctrl 10 0000 0000 0000
  [0x38] = 2, -- lshift 0000 0010
  [0x3c] = 4, -- rshift 0000 0100
}

local log = hs.logger.new('Hiper', 'debug')

Hiper = {}
Hiper.new = function(key_name)
  local self = {
    features = {},
    key = hs.keycodes.map[key_name],
  }

  local modifierHandler = function(event)
    local keyCode = event:getKeyCode()
    if keyCode ~= self.key then return false end

    local realFlags = event:getRawEventData().CGEventData.flags
    local mask = realFlagMask[self.key]
    if mask == nil then return false end

    if (realFlags & mask) == mask then
      if not self.featureTap:isEnabled() then
        log.d('featureTap start')
        self.featureTap:start()
      end
    else
      if self.featureTap:isEnabled() then
        log.d('featureTap stop')
        self.featureTap:stop()
        -- self.modifierTap:stop()
        -- self.modifierTap:start()
      end
    end
    return false
  end

  local featureHandler = function(event)
    local keyCode = event:getKeyCode()
    local eventType = "up"
    if event:getType() == hs.eventtap.event.types.keyDown then
      if event:getProperty(hs.eventtap.event.properties['keyboardEventAutorepeat']) == 0 then
        eventType = "down"
      else
        eventType = "repeat"
      end
    end

    if keyCode == self.key then return eventType ~= "up" end

    if self.features[keyCode] ~= nil then
      log.d('featureHandler', event:getKeyCode())
      if eventType == "down" then
        self.features[keyCode]()
        return true
      end
    end

    return false
  end

  self.featureTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, featureHandler)
  self.modifierTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, modifierHandler)
  self.modifierTap:start()

  self.load_features = function(features)
    for key, feature in pairs(features) do
      if type(feature) == 'string' then
        features[key] = function() hs.application.launchOrFocus(feature) end
      else
        features[key] = feature
      end
      self.features[hs.keycodes.map[key]] = features[key]
    end
  end

  return self
end

return Hiper
