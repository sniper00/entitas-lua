--  Bring your systems together
local entitas = require("entitas")
local HelloWorldSystem = require('example.HelloWorld.Systems.HelloWorldSystem')
local DebugMessageSystem = require('example.HelloWorld.Systems.DebugMessageSystem')
local CleanupDebugMessageSystem = require('example.HelloWorld.Systems.CleanupDebugMessageSystem')
local Components = require('example.HelloWorld.Components')

local Context = entitas.Context
local Systems = entitas.Systems
local Matcher = entitas.Matcher

local _context = Context.new()

local systems = Systems.new()
systems:add(HelloWorldSystem.new(_context))
systems:add(DebugMessageSystem.new(_context))
systems:add(CleanupDebugMessageSystem.new(_context))

systems:activate_reactive_systems()
systems:initialize()

local _group = _context:get_group(Matcher({Components.DebugMessage}))
assert(_group.entities:size() == 1)
systems:execute()
systems:cleanup()
assert(_group.entities:size() == 0)

systems:clear_reactive_systems()
systems:tear_down()