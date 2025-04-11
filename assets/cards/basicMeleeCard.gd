extends Card

@onready var attackSprite = $"AttackSprite"
@export var animationName = "Slash"
@export var damage = 10
@onready var collisionShape = $Area2D
var lastDirection : Vector2


func _physics_process(delta: float) -> void:
	attackSprite.global_position = player.global_position + lastDirection*15
	collisionShape.global_position = player.global_position + lastDirection * 15
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO:
		lastDirection = direction



func doAttack():
	attackSprite.rotation = lastDirection.angle()+90
	collisionShape.rotation = lastDirection.angle()*90
	player.updateAnimationsDirection(lastDirection)
	if(attackSprite != null):
		animationPlayer.play(animationName)
		print("attacked")
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name != "Player"):
		body.takeDamage(damage)
		
