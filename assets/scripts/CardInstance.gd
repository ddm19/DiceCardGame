extends Node
class_name CardInstance

var card_name: String
var description: String
var icon: Texture2D
var cooldown: float
var type: Card.CARDTYPE
var canAttack: bool = true
var player: Player
var scene: PackedScene

func setup(data: CardData, p: Player):
	if data == null or p == null:
		return
	card_name = data.card_name
	description = data.description
	icon = data.icon
	cooldown = data.cooldown
	type = data.type
	player = p
	scene = data.scene

func _on_attack_done():
	player.attackEnded()

func reset_cooldown():
	canAttack = true
