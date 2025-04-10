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

func attack(): # Abstract 
	if(canAttack):
		print("attack")
		match type:
			CARDTYPE.MELEE:
				player.updateState(player.ANIMATIONSTATES.MELEE_ATTACK)
			CARDTYPE.RANGED:
				player.updateState(player.ANIMATIONSTATES.RANGED_ATTACK)
			CARDTYPE.MAGIC:
				player.updateState(player.ANIMATIONSTATES.MAGIC_ATTACK)
		get_tree().create_timer(cooldown).connect("timeout",onCardCooldownFinished)
		canAttack = false
		doAttack()
	
func doAttack():
	print("Attack not implemented, this should not be called")

func _ready() -> void:
	sprite = $"Sprite"
	player = get_tree().get_root().get_node("Game/Player")
	animationPlayer = $AnimationPlayer

func onCardCooldownFinished():
	print("Lanzable")
	canAttack = true
