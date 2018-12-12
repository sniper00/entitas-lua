
# entitas-lua
Entitas ECS implementation in Lua. 

entitas-lua is a port of [Entitas ECS for C# and Unity](https://github.com/sschmid/Entitas-CSharp)

entitas-lua reference [entitas-python](https://github.com/Aenyhm/entitas-python)

# Run Test and Example
```
    ./lua test/test_entity_system.lua
    ./lua example/HelloWorld/Example.lua
```

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
    assert(entity:has_any({Position}))

    local pos = entity:get(Position)
    assert(pos.x == 1)
    assert(pos.y == 4)
    assert(pos.z == 5)

    entity:replace(Position, 5, 6)

    entity:replace(Person, "wang")

    assert(entity:get(Position).x == 5)
    assert(entity:get(Position).y == 6)

    entity:remove(Position)
    assert(not entity:has(Position))

    entity:add(Position, 1, 4, 5)
    entity:add(Movable, 0.56)
    assert(entity:has_all({Position, Movable}))
    entity:destroy()
    assert(not entity:has_all({Position, Movable}))
```
## Context
```lua
    local _context = Context.new()
    local _entity = _context:create_entity()

    assert(Context.create_entity)
    assert(Context.has_entity)
    assert(Context.destroy_entity)
    assert(Context.get_group)
    assert(Context.set_unique_component)
    assert(Context.get_unique_component)

    assert(_context:has_entity(_entity))
    lu.assertEquals(_context:entity_size(), 1)
    _context:destroy_entity(_entity)
    assert(not _context:has_entity(_entity))

    -- reuse
    local _e2 = _context:create_entity()
    assert(_context:has_entity(_entity))
    lu.assertEquals(_context:entity_size(), 1)


    _context:set_unique_component(Counter,101)
    local cmp = _context:get_unique_component(Counter)
    assert(cmp.num == 101)
```
## Group
```lua
    local _context = Context.new()
    local _entity = _context:create_entity()

    _entity:add(Movable, 1)

    local _group = _context:get_group(Matcher({Movable}))
    local _group2 = _context:get_group(Matcher({Movable}))
    assert(_group==_group2)

    assert(_group.entities:size() == 1)
    assert(_group:single_entity():has(Movable))

    assert(_group:single_entity() == _entity)
    _entity:replace(Movable, 2)
    assert(_group:single_entity() == _entity)
    _entity:remove(Movable)
    assert(not _group:single_entity())

    _entity:add(Movable, 3)

    local _entity2 = _context:create_entity()
    _entity2:add(Movable, 10)
    lu.assertEquals(_group.entities:size(), 2)
    local entities = _group.entities

    assert(entities:has(_entity))
    assert(entities:has(_entity2))
```

## Entity Collector
```lua
    local context = Context.new()
    local group = context:get_group(Matcher({Position}))
    local pair = {}
    pair[group] = GroupEvent.ADDED|GroupEvent.REMOVED
    local collector = Collector.new(pair)
    local _entity = context:create_entity()
    _entity:add(Position,1,2,3)
    lu.assertEquals(collector.entities:size(),1)
    context:destroy_entity(_entity)
    lu.assertEquals(collector.entities:size(),0)
    collector:clear_entities()
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

    assert(entities:has(adam))
    assert(entities:has(eve))
```

## Setup example
```lua
    -------------------------------------------
    local StartGame = class("StartGame")
    function StartGame:ctor(context)
        self.context = context
    end

    function StartGame:initialize()
        print("StartGame initialize")
        local entity = self.context:create_entity()
        entity:add(Movable,123)
    end

    -------------------------------------------
    local EndSystem = class("EndSystem")
    function EndSystem:ctor(context)
        self.context = context
    end

    function EndSystem:tear_down()
        print("EndSystem tear_down")
    end

    -------------------------------------------
    local MoveSystem = class("MoveSystem", ReactiveSystem)

    function MoveSystem:ctor(context)
        MoveSystem.super.ctor(self, context)
    end

    local trigger = {
        {
            Matcher({Movable}),
            GroupEvent.ADDED | GroupEvent.UPDATE
        }
    }

    function MoveSystem:get_trigger()
        return trigger
    end

    function MoveSystem:filter(entity)
        return entity:has(Movable)
    end

    function MoveSystem:execute(es)
        es:foreach(function( e  )
            print("ReactiveSystem: add entity with component Movable.",e)
        end)
    end

    local _context = Context.new()
    local systems = Systems.new()
    systems:add(StartGame.new(_context))
    systems:add(MoveSystem.new(_context))
    systems:add(EndSystem.new(_context))

    systems:initialize()

    systems:execute()

    systems:tear_down()
```
## [A complete example](https://github.com/sniper00/BallGame)