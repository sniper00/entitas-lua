local util       = require("util")
local entitas    = require('entitas')
local Components = require('Components')
local ReactiveProcessor = entitas.ReactiveProcessor
local Matcher    = entitas.Matcher
local GroupEvent = entitas.GroupEvent

local class      = util.class

local DebugMessageSystem = class("DebugMessageSystem",ReactiveProcessor)

function DebugMessageSystem:ctor(context)
    self.context = context
    DebugMessageSystem.super.ctor(self,context)
end

function DebugMessageSystem:get_trigger()
    --we only care about entities with DebugMessageComponent
    return {Matcher({Components.DebugMessage}),GroupEvent.ADDED}
end

function DebugMessageSystem:filter(entity)
    --good practice to perform a final check in case 
    --the entity has been altered in a different system.
    return entity:has(Components.DebugMessage)
end

function DebugMessageSystem:react(entites)
    for k,entity in pairs(entites) do
        print(entity:get(Components.DebugMessage).message)
    end
end

return DebugMessageSystem
