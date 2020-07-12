require("scripts/AdvHero")
require("scripts/Globals")
require("scripts/AdvItem")
require("scripts/AdvItemType")

Globals.TESTING = true

print("Creating Mock Hero")
adv_hero = AdvHero:New("mock_hero")
print(adv_hero:GetString())

print("Creating Mock Item Type")
adv_item_type = AdvItemType:New(0, "helmet", {
    strength = 5,
    constitution = -2,
})

print("Creating Mock Item")
adv_item = AdvItem:New("mock_item", adv_item_type)

print("Equiping Mock Item")
adv_hero:Equip(adv_item)
print(adv_hero:GetString())

print("Unequiping Mock Item")
adv_hero:Unequip(adv_item)
print(adv_hero:GetString())