extends Node
class_name CardDatabase

@export var all_cards : Array[CardData] = [
	preload("res://assets/cards/basic_magic.tres"),
	preload("res://assets/cards/basic_ranged.tres"),
	preload("res://assets/cards/basic_sword.tres")
]

static var instance: CardDatabase

func _ready():
	instance = self

func get_card_by_name(name: String) -> CardData:
	for card in all_cards:
		if card.card_name == name:
			return card
	return null
