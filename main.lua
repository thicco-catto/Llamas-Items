local LlamasItemsMod = RegisterMod("Llama's Items", 1)


---loads a file, with no cache
---@param loc string
---@param ... any
---@return any
local function loadFile(loc, ...)
    local _, err = pcall(require, "")
    local modName = err:match("/mods/(.*)/%.lua")
    local path = "mods/" .. modName .. "/llamas_items_scripts/"
    return assert(loadfile(path .. loc .. ".lua"))(...)
end

--Items
loadFile("items/actives/CardReverser", LlamasItemsMod)