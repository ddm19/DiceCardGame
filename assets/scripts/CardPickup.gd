extends Area2D

@export var card_data: CardData

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	$Sprite2D.texture = card_data.icon

func _on_body_entered(body):
	if body is Player:
		body.add_card_from_data(card_data)
		queue_free()
