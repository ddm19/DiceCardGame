extends Node2D
class_name Card

enum CARDTYPE {
	MELEE,
	RANGED,
	MAGIC
}

@export var player : Player
@export var cooldown : float
@export var type : CARDTYPE
@export var sprite : Sprite2D
@export var animationPlayer : AnimationPlayer

var canAttack : bool = true

func attack():
	if canAttack:
		get_tree().create_timer(cooldown).connect("timeout", onCardCooldownFinished)
		canAttack = false
		doAttack()

func doAttack():
	pass

func _ready() -> void:
	sprite = $"Sprite"
	player = get_tree().get_root().get_node("Game/Player")
	animationPlayer = $AnimationPlayer

func onCardCooldownFinished():
	canAttack = true
