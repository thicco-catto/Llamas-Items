local LlamasItemsMod = table.unpack({...})
local Constants = require("llamas_items_scripts.Constants")
local SpindownTrinket = {}


---@param player EntityPlayer
function SpindownTrinket:OnItemUse(_, _, player)
    local heldTrinket = player:GetTrinket(0)
    local heldTrinket2 = player:GetTrinket(1)

    if heldTrinket == 0 then return end

    --The player has at least 1 trinket
    if heldTrinket2 ~= 0 then
        player:TryRemoveTrinket(heldTrinket2)
    end

    player:TryRemoveTrinket(heldTrinket)

    local newTrinket = heldTrinket-1
    local newTrinket2 = heldTrinket2-1

    if newTrinket > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        player:AddTrinket(newTrinket, false)
    end

    if heldTrinket2 > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        player:AddTrinket(newTrinket2, false)
    end

    return true
end
LlamasItemsMod:AddCallback(ModCallbacks.MC_USE_ITEM, SpindownTrinket.OnItemUse, Constants.ItemId.SPINDOWN_TRINKET)