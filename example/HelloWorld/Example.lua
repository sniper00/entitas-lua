--  Bring your systems together

package.path = "../../?.lua;"..package.path

local entitas = require('entitas')
local Context = entitas.Context
local Systems = entitas.Systems
local Matcher = entitas.Matcher

local Components = require('Components')
local HelloWorldSystem = require('Systems.HelloWorldSystem')
local DebugMessageSystem = require('Systems.DebugMessageSystem')
local CleanupDebugMessageSystem = require('Systems.CleanupDebugMessageSystem')

local _context = Context.new()

local systems = Systems.new()
systems:add(HelloWorldSystem.new(_context))
systems:add(DebugMessageSystem.new(_context))
systems:add(CleanupDebugMessageSystem.new(_context))

systems:initialize()
systems:activate_reactive_systems()

local _group = _context:get_group(Matcher({Components.DebugMessage}))
assert(_group.entities:size() == 1)
systems:execute()
systems:cleanup()
assert(_group.entities:size() == 0)

systems:clear_reactive_systems()
systems:tear_down()