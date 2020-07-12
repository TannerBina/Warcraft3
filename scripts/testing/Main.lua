require("AdvUnit")
require("Globals")
require("AdvItem")

Globals.TESTING = true

print("Creating Mock Unit")
adv_unit = AdvUnit:New("mock_unit")
print(adv_unit:GetString())

print("Creating Mock Item")
adv_item = AdvItem:New("mock_item", {strength = 5, constitution = -3})

print("Equiping Mock Item")
adv_item:EquipTo(adv_unit)
print(adv_unit:GetString())

print("Unequiping Mock Item")
adv_item:UnequipTo(adv_unit)
print(adv_unit:GetString())