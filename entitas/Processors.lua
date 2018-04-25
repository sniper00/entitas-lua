local util              = require("util")
local class             = util.class
local table_insert      = table.insert
local ReactiveProcessor = require("entitas.ReactiveProcessor")

local M = class("Processors")

local function isinstance(a, b)
    if a.__cname == b.__cname then
        return true
    end

    while a and a.super do
        if a.super.__cname == b.__cname then
            return true
        end
        a = a.super
    end

    return false
end

function M:ctor()
    self._initialize_processors = {}
    self._execute_processors = {}
    self._cleanup_processors = {}
    self._tear_down_processors = {}
end

function M:add(processor)
    if processor.initialize then
        table_insert(self._initialize_processors, processor)
    end

    if processor.execute then
        table_insert(self._execute_processors, processor)
    end

    if processor.cleanup then
        table_insert(self._cleanup_processors, processor)
    end

    if processor.tear_down then
        table_insert(self._tear_down_processors, processor)
    end
end

function M:initialize()
    for _, processor in pairs(self._initialize_processors) do
        processor:initialize()
    end
end

function M:execute()
    for _, processor in pairs(self._execute_processors) do
        processor:execute()
    end
end

function M:cleanup()
    for _, processor in pairs(self._cleanup_processors) do
        processor:cleanup()
    end
end

function M:tear_down()
    for _, processor in pairs(self._tear_down_processors) do
        processor:tear_down()
    end
end

function M:activate_reactive_processors()
    for _, processor in pairs(self._execute_processors) do
        if isinstance(processor, ReactiveProcessor) then
            processor:activate()
        end

        if isinstance(processor, M) then
            processor:activate_reactive_processors()
        end
    end
end

function M:deactivate_reactive_processors()
    for _, processor in pairs(self._execute_processors) do
        if isinstance(processor, ReactiveProcessor) then
            processor:deactivate()
        end

        if isinstance(processor, M) then
            processor:deactivate_reactive_processors()
        end
    end
end

function M:clear_reactive_processors()
    for _, processor in pairs(self._execute_processors) do
        if isinstance(processor, ReactiveProcessor) then
            processor:clear()
        end

        if isinstance(processor, M) then
            processor:clear_reactive_processors()
        end
    end
end

return M
