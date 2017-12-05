
# entitas-lua
Entitas ECS implementation in Lua. 

entitas-lua is a port of [Entitas ECS for C# and Unity](https://github.com/sschmid/Entitas-CSharp)

entitas-lua reference [entitas-python](https://github.com/Aenyhm/entitas-python)

# Overview

## Components
```lua
local MakeComponent = require('entitas.MakeComponent')
local Position = MakeComponent("Position", "x", "y", "z")
local Movable = MakeComponent("Movable", "speed")
local Person = MakeComponent("Person", "name","age")
```
## Entity
```lua
local entity = Entity.new()
entity:activate(0)
entity:add(Position, 1, 4, 5)
assert(entity:has(Position))
assert(entity:has_any(Position))

local pos = entity:get(Position)
assert(pos.x == 1)
assert(pos.y == 4)
assert(pos.z == 5)

entity:replace(Position, 5, 6)
assert(entity:get(Position).x == 5)
assert(entity:get(Position).y == 6)
```
## Context
```lua
local _context = Context.new()
local entity = _context:create_entity()
entity:add(Position, 1, 4, 5)
```
## Group
```lua
local _context = Context.new()
local _entity = _context:create_entity()

_entity:add(Movable, 1)

local _group = _context:get_group(Matcher({Movable}))

assert(_group.entities:size() == 1)
assert(_group:single_entity():has(Movable))
```

## Entity Collector
```lua
local context = Context.new()
local group = context:get_group(Matcher({Position}))
local collector = Collector.new()
collector:add(group, GroupEvent.added)
collector:clear_collected_entities()
collector:deactivate()
```

## Entity Index
```lua
local context = Context.new()
local group = context:get_group(Matcher({Person}))
local index = EntityIndex.new(Person, group, 'age')
context:add_entity_index(index)
local adam = context:create_entity()
adam:add(Person, 'Adam', 42)
local eve = context:create_entity()
eve:add(Person, 'Eve', 42)

local idx = context:get_entity_index(Person)
local entities = idx:get_entities(42)
```

## Setup example
```lua
local _context = Context.new()
local processors = Processors.new()
processors:add(StartGame)
processors:add(MoveSystem)
processors:add(EndSystem)

processors:initialize()

processors:execute()

processors:tear_down()
```
