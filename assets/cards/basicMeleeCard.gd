extends Card

@onready var attackSprite = $"AttackSprite"
@export var animationName = "Slash"
@export var damage = 10
@onready var collisionShape = $AttackSprite/Area2D
var direction: Vector2

func _ready():
	player = get_node("/root/Game/Player")  
	direction = player.facingDirection
	attackSprite.global_position = player.global_position + direction * 15

func _physics_process(delta: float) -> void:
	if player != null:
		direction = player.facingDirection
		attackSprite.global_position = player.global_position + direction * 15

func doAttack():
	if player != null:
		player.isAttacking = true
		player.updateState(Player.ANIMATIONSTATES.MELEE_ATTACK)
		player.updateAnimationsDirection(direction)
		attackSprite.rotation = direction.angle() + 90
		if attackSprite != null:
			animationPlayer.play(animationName)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		body.takeDamage(damage)
