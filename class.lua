function newClass( constructor, inheritance, _type )
    -- --==:[ Error Handling ]:==--
    if inheritance ~= nil and type(inheritance) ~= "table" and type(inheritance) ~= "string" then
        error("Inheritance must be a table")
    elseif type(inheritance) == "string" then
        _type = inheritance
        inheritance = nil
    end

    if type(constructor) == "table" then
        inheritance = constructor
        constructor = nil
    elseif type(constructor) ~= "function" then
        error("A Moxy class must have a constructor or inherit one")
    end

    -- --==:[ Class ]:==--
    local classMeta = {}
    local class = setmetatable({}, classMeta)
    class.__index = class
    if _type then
        class._type = _type
    else
        class._type = "Class"
    end

    -- --==:[ Inheritance ]:==--
    if inheritance then
        if not inheritance._type then
            error("Inheritance must be a Moxy class")
        end
        local excludeIndexes = {
            ["__index"] = true, ["__newindex"] = true, ["__call"] = true, ["__add"] = true,
            ["__sub"] = true, ["__mul"] = true, ["__div"] = true, ["__mod"] = true,
            ["__unm"] = true, ["__pow"] = true, ["__concat"] = true, ["__eq"] = true,
            ["__lt"] = true, ["__le"] = true, ["__tostring"] = true, ["__gc"] = true,
            ["__mode"] = true, ["__metatable"] = true, ["_type"] = true, ["_base"] = true
        }
        -- Collect all fields and methods to the class
        for key, value in pairs(inheritance) do
            if not excludeIndexes[key] then
                class[key] = value
            end
        end
        class._base = inheritance
    end

    -- --==:[ Constructor ]:==--
    if constructor then
        class._init = constructor
    end

    classMeta.__call = function(t, ...)
        local instance = {}
        setmetatable(instance, class)
        instance._init(instance, ...)
        return instance
    end

    -- --==:[ Inheritance check ]:==--
    class.IsA = function(self, classCheck)
        local meta = getmetatable(self) -- Access base class (containing class._base)
        while meta do
            if meta == classCheck then
                return true
            end
            meta = meta._base
        end
        return false
    end
    
    -- --==:[ Return ]:==--
    return class
end

--[[
    Support:
    - Fields
    - Methods
    - Inheritance
    - Constructor
    - Type checking
    - IsA method (inheritance check)

    Future support:
    - Static methods
    - Static fields
    - Private fields
    - Private methods
    - Public fields
    - Public methods
    - Getters and setters
    - Events
    - Enumerations
    - Interfaces
    - Abstract classes
    - Abstract methods
    - Operator overloading
    - Type casting
    - Type conversion
    - Type checking
    - Type inference
]]