extends Node

#Battle Events
signal battle_exited
signal battle_won
signal player_turn_ended
signal player_turn_started
signal unit_died(unit: Unit)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

#Battle Reward Events
signal battle_reward_exited

#Shop Events
signal shop_exited
signal shop_entered(shop: Shop)
signal request_purchase_item(item: Item)

#Brewing Events
signal brewing_exited
signal brewing_entered(brewing: Brewing)

#Kiln Events
signal kiln_exited

#Map Events
signal map_exited(room: Room)

#Inventory Events
signal request_add_item(item: Item)
signal request_add_gold(amount: int)
signal request_remove_item(item: Item, count: int)
