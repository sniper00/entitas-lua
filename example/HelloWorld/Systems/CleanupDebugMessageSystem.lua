local util       = require("util")
local class      = util.class
local Components = require('example.HelloWorld.Components')
local Matcher = require('entitas.Matcher')
local DebugMessageComponent = Components.DebugMessage

local CleanupDebugMessageSystem = class("CleanupDebugMessageSystem")

function CleanupDebugMessageSystem:ctor(context)
    self.context = context
    self._debugMessages = context:get_group(Matcher({DebugMessageComponent}))
end

function CleanupDebugMessageSystem:cleanup()
    local entitas = self._debugMessages.entities
    entitas:foreach(function ( e )
        self.context:destroy_entity(e)
    end)
end

return CleanupDebugMessageSystem