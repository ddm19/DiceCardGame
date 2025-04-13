extends Sprite2D

@onready var player = get_tree().get_root().get_node("Game/Player")
@export var cardData : CardData

func onCollisionEnter(body : Node2D):
	print(body.name)
	print("CONTACTO")
	if(body.name == "Player"):
		player.add_card_from_data(cardData)
