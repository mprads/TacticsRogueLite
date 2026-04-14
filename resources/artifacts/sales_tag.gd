class_name SalesTag
extends Artifact

@export var amount := 0.15


func init(owner: ArtifactIcon) -> void:
	Events.shop_entered.connect(_on_shop_entered)
	artifact_icon = owner


func _on_shop_entered(shop: Shop) -> void:
	shop.change_item_cost(1 - amount)

	SFXPlayer.play(SFXConfig.get_audio_stream(sfx_key))
	activated.emit()
