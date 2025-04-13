extends Card

@onready var attackSprite = $Rotator

@export var animationName = "Slash"
@export var damage = 10

@onready var collisionShape = $Rotator/AttackSprite/Area2D
var direction: Vector2

func _ready():
	player = get_node("/root/Game/Player")  
	direction = player.facingDirection
	
func _physics_process(delta: float) -> void:
	if player != null:
		direction = player.facingDirection
	var mousePosition = get_global_mouse_position()
	$Crosshair.global_position = mousePosition
	var laserDirection = (get_global_mouse_position() - player.global_position).normalized()
	attackSprite.rotation = laserDirection.angle()

func doAttack():
	if player != null:
		attackSprite.global_position = player.global_position
		player.isAttacking = true
		player.updateState(Player.ANIMATIONSTATES.MELEE_ATTACK)
		
		if attackSprite != null:
			animationPlayer.play(animationName)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		body.takeDamage(damage)
