local LlamasItemsMod = table.unpack({...})
local Constants = require("llamas_items_scripts.Constants")
local CardReverser = {}


---@param player EntityPlayer
function CardReverser:OnItemUse(_, _, player)
    local card
    local slotId

    for i = 0, 1, 1 do
        slotId = i
        card = player:GetCard(i)

        if card ~= 0 then
            break
        end
    end

    local reverseCard = Constants.NORMAL_CARD_TO_REVERSE[card]
    local isReverse = false

    if not reverseCard then
        isReverse = true
        reverseCard = Constants.REVERSE_CARD_TO_NORMAL[card]
    end

    if not reverseCard then return end

    player:SetCard(slotId, Card.CARD_NULL)

    local room = Game():GetRoom()
    local spawningPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)

    local spawnedCard = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, reverseCard, spawningPos, Vector.Zero, player)

    local cardSpr = spawnedCard:GetSprite()
    local data = spawnedCard:GetData()

    data.ReverseCardOrignialAnimationFile = cardSpr:GetFilename()
    cardSpr:Load("gfx/reverse_card.anm2", true)

    if isReverse then
        cardSpr:Play("ReverseToNormal", true)
    else
        cardSpr:Play("NormalToReverse", true)
    end

    data.ReverseCardAnimationPlaying = cardSpr:GetAnimation()

    return true
end
LlamasItemsMod:AddCallback(ModCallbacks.MC_USE_ITEM, CardReverser.OnItemUse, Constants.ItemId.CARD_REVERSER)


---@param card EntityPickup
function CardReverser:OnCardUpdate(card)
    local data = card:GetData()
    if not data.ReverseCardOrignialAnimationFile then return end

    local spr = card:GetSprite()

    if spr:GetFrame() == 20 then
        spr:Load(data.ReverseCardOrignialAnimationFile, true)
        spr:Play("Appear", true)
        spr:SetFrame(20)

        data.ReverseCardOrignialAnimationFile = nil
        data.ReverseCardAnimationPlaying = nil
    end
end
LlamasItemsMod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CardReverser.OnCardUpdate, PickupVariant.PICKUP_TAROTCARD)