local Components = require('example.HelloWorld.Components')

local HelloWorldSystem = class("HelloWorldSystem")

function HelloWorldSystem:ctor(context)
    self.context = context
end

function HelloWorldSystem:initialize()
    --create an entity and give it a DebugMessageComponent with
    --the text "Hello World!" as its data
    local entity = self.context:create_entity()
    entity:add(Components.DebugMessage,"HelloWorld")
end


return HelloWorldSystem