extends Card

@onready var attackSprite = $"AttackSprite"
@export var damage = 10
var lastDirection : Vector2


func _physics_process(delta: float) -> void:
	attackSprite.global_position = player.global_position + lastDirection*15
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO:
		lastDirection = direction



func doAttack():
	var mousePosition = get_viewport().get_mouse_position()
	$Sprite.position = mousePosition
	attackSprite.rotation = lastDirection.angle()+90
	player.updateAnimationsDirection(lastDirection)
	if(attackSprite != null):
		print("attacked")
