extends Enemy

@export var attackDistance : float
var attackSpeedMultiplier : int = 500.5
@export var damage : float
var isAttacking : bool
@onready var animationPlayer : AnimationPlayer = $Sprite2D/AnimationPlayer

func _physics_process(delta): 
	if(getDistanceToPlayer() < maxFollowDistance):
		move_and_slide()
	if(getDistanceToPlayer() <= attackDistance && !isAttacking):
		attack()
	elif(!isAttacking):
		super._physics_process(delta)

func attack():
	if(!isAttacking):
		isAttacking = true
		var playerDirection = player.global_position
		velocity = Vector2.ZERO
		await get_tree().create_timer(0.1).timeout
		
		var backDirection = -getDirectionToPlayer()
		velocity = backDirection * (speed * 0.9)
		await get_tree().create_timer(0.3).timeout
		
		var chargeDirection = (playerDirection - global_position).normalized()
		velocity = chargeDirection * attackSpeedMultiplier
		await get_tree().create_timer(0.6).timeout
		isAttacking = false

func takeDamage(damage):
	super.takeDamage(damage)
	
func onCollisionEntered(body: Node2D) -> void:
	if(typeof(body == LivingEntity) && body.type == LivingEntity.TARGET_TYPE.PLAYER):
		body.takeDamage(damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass 
