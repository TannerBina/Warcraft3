require("scripts/AdvHero")
require("scripts/Globals")
require("scripts/AdvItem")
require("scripts/AdvItemType")
require("scripts/AdvBuff")

Globals.TESTING = true

print("Creating Mock Hero")
adv_hero = AdvHero:New("mock_hero")
print(adv_hero:GetString())
print("---------------")

print("Creating Mock Item Type")
adv_item_type = AdvItemType:New(0, "helmet", {
    strength = 5,
    constitution = -2,
})
print("---------------")

print("Creating Mock Item")
adv_item = AdvItem:New("mock_item", adv_item_type)
print("---------------")

print("Equiping Mock Item")
adv_hero:Equip(adv_item)
print(adv_hero:GetString())
print("---------------")

print("Failing to equip mock item")
adv_hero:Equip(adv_item)
print(adv_hero:GetString())
print("---------------")

print("Unequiping Mock Item")
adv_hero:Unequip(adv_item)
print(adv_hero:GetString())
print("---------------")

print("Increasing Hero Soldier Level")
adv_hero:IncreaseProfessionLevel("soldier")
print(adv_hero:GetString())
print("---------------")

print("Creating Buff")
adv_buff = AdvBuff:New(0)
adv_buff.level = 0
adv_buff.stats = {
    strength = 10,
    dexterity = -2,
}
remaining_duration = 10
print("---------------")

print("Adding buff to hero")
co = adv_hero:AddBuff(adv_buff)
print(adv_hero:GetString())
print("---------------")

print("Creating duplicate buff")
adv_buff_2 = AdvBuff:New(0)
adv_buff_2.level = 2
adv_buff_2.stats = {
    strength = 12,
    luck = 5,
}
remaining_duration = 5
print("---------------")

print("Adding duplicate buff to hero")
co2 = adv_hero:AddBuff(adv_buff_2)
print(adv_hero:GetString())
print("---------------")

print("Removing first buff (No effect)")
coroutine.resume( co )
print(adv_hero:GetString())
print("---------------")

print("Removing second buff")
coroutine.resume(co2)
print(adv_hero:GetString())
print("---------------")