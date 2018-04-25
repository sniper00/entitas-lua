--  Bring your systems together

package.path = "../../?.lua;"..package.path

local entitas = require('entitas')
local Context = entitas.Context
local Processors = entitas.Processors
local Matcher = entitas.Matcher

local Components = require('Components')
local HelloWorldSystem = require('Systems.HelloWorldSystem')
local DebugMessageSystem = require('Systems.DebugMessageSystem')
local CleanupDebugMessageSystem = require('Systems.CleanupDebugMessageSystem')

local _context = Context.new()

local processors = Processors.new()
processors:add(HelloWorldSystem.new(_context))
processors:add(DebugMessageSystem.new(_context))
processors:add(CleanupDebugMessageSystem.new(_context))

processors:activate_reactive_processors()
processors:initialize()

local _group = _context:get_group(Matcher({Components.DebugMessage}))
assert(_group.entities:size() == 1)
processors:execute()
processors:cleanup()
assert(_group.entities:size() == 0)

processors:clear_reactive_processors()
processors:tear_down()