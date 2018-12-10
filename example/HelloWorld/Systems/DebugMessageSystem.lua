local util       = require("util")
local class      = util.class
local ReactiveSystem = require("entitas.ReactiveSystem")
local Matcher = require('entitas.Matcher')
local Components = require('example.HelloWorld.Components')
local GroupEvent = require("entitas.GroupEvent")

local class      = util.class

local DebugMessageSystem = class("DebugMessageSystem",ReactiveSystem)

function DebugMessageSystem:ctor(context)
    self.context = context
    DebugMessageSystem.super.ctor(self,context)
end

function DebugMessageSystem:get_trigger()
    --we only care about entities with DebugMessageComponent
    return {
        {Matcher({DebugMessageComponent}),GroupEvent.ADDED}
    }
end

function DebugMessageSystem:filter(entity)
    --good practice to perform a final check in case 
    --the entity has been altered in a different system.
    return entity:has(Components.DebugMessage)
end

function DebugMessageSystem:execute(entites)
    entites:foreach(function(e)
        print(e:get(DebugMessageComponent).message)
    end)
end

return DebugMessageSystem
