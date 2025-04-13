extends Node

@onready var cardSlots: Array = [
	$Card1, $Card2, $Card3, $Card4, $Card5, $Card6
]
@onready var player: Player = get_node("/root/Game/Player")
@onready var descriptionLabel: Label = get_node("/root/InGameUi/Inventory_Menu/Inventory_Container/Panel/Info") 
func updateCardTextures():
	for i in range(min(player.cardsList.size(), cardSlots.size())):
		var card = player.cardsList[i]
		var textureRect = cardSlots[i] as TextureRect
		if card and textureRect:
			textureRect.texture = card.icon

func _ready():
	for i in range(cardSlots.size()):
		var textureRect = cardSlots[i] as TextureRect
		if textureRect:
			textureRect.connect("mouse_entered", Callable(self, "_on_card_hovered").bind(i))  # Usamos bind para pasar el índice
			textureRect.connect("mouse_exited", Callable(self, "_on_card_exited"))

func _on_card_hovered(card_index: int):
	var card = player.cardsList[card_index]
	if card:
		descriptionLabel.text = card.description 

func _on_card_exited():
	descriptionLabel.text = ""
