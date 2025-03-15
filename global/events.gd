extends Node

#Battle Events
signal battle_exited

#Shop Events
signal shop_exited
signal shop_entered(shop: Shop)

#Brewing Events
signal brewing_exited

#Kiln Events
signal kiln_exited

#Map Events
signal map_exited(room: String)

#Inventory Events
signal request_add_item(item: Item)
signal request_remove_item(item: Item)
