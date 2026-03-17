class_name Upcharge
extends Artifact

@export var amount := 0.10


func init(owner: ArtifactIcon) -> void:
	Events.shop_entered.connect(_on_shop_entered)


func _on_shop_entered(shop: Shop) -> void:
	shop.change_item_cost(1 - amount)

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()
