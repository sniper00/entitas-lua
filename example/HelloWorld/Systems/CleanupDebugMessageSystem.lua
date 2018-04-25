local util       = require("util")
local Components = require('Components')
local Matcher = require('entitas').Matcher
local class      = util.class

local CleanupDebugMessageSystem = class("CleanupDebugMessageSystem")

function CleanupDebugMessageSystem:ctor(context)
    self.context = context
    self._debugMessages = context:get_group(Matcher({Components.DebugMessage}))
end

function CleanupDebugMessageSystem:cleanup()
    for entity,_ in pairs(self._debugMessages.entities) do
        self.context:destroy_entity(entity)
    end
end

return CleanupDebugMessageSystem