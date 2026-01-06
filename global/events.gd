extends Node

#Battle Events
signal battle_exited
signal battle_won
signal battle_lost
signal retry_battle
signal player_turn_ended
signal player_turn_started
signal unit_died(unit: Unit)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)
signal request_update_enemy_intent

#Battle Reward Events
signal battle_reward_exited

#Artifact Events
signal activate_artifacts_by_type(type: Artifact.TYPE)
signal artifacts_activated(type: Artifact.TYPE)
signal unit_shielded(unit: Unit)
signal request_add_artifact(artifact: Artifact)

#Shop Events
signal shop_exited
signal shop_entered(shop: Shop)
signal request_purchase_item(item: Item)
signal request_purchase_bottle(bottle: Bottle)
signal request_purchase_artifact(artifact: Artifact)

#Brewing Events
signal brewing_exited
signal brewing_entered(brewing: Brewing)

#Kiln Events
signal kiln_exited

#Rest Area Events
signal rest_area_exited

#Random Event Events
signal random_event_exited

#Map Events
signal map_exited(room: Room)

#Inventory Events
signal request_add_item(item: Item)
signal request_add_gold(amount: int)
signal request_remove_gold(amount: int)
signal request_remove_item(item: Item, count: int)

#Tooltip Events
signal request_show_tooltip(owner: Node, contents: Dictionary, secondary: Array)
signal hide_tooltip

#Run Stats Events
signal run_stats_damage_dealt
signal run_stats_damage_taken
signal run_stats_oz_used
signal run_stats_ability_used
signal run_stats_potion_used
