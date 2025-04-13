extends Enemy

@export var attackDistance : float
@export var damage : float
var attackSpeedMultiplier : int = 300
var isAttacking : bool
@onready var animationPlayer : AnimationPlayer = $Sprite2D/AnimationPlayer
@export var maxRotationSpeed : float
var rotationSpeed : float = 0

func _physics_process(delta): 
	if(getDistanceToPlayer() < maxFollowDistance):
		move_and_slide()
		$Sprite2D/Sword.rotate(rotationSpeed*delta)
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
		
		velocity = getDirectionToPlayer() * (speed * 0.3)
		await get_tree().create_timer(0.25).timeout
		
		var chargeDirection = (playerDirection - global_position).normalized()
		rotationSpeed = maxRotationSpeed
		velocity = chargeDirection * attackSpeedMultiplier
		await get_tree().create_timer(1.5).timeout
		isAttacking = false
		rotationSpeed = 0

func takeDamage(damage):
	super.takeDamage(damage)
	
func onCollisionEntered(body: Node2D) -> void:
	if(typeof(body == LivingEntity) && body.type == LivingEntity.TARGET_TYPE.PLAYER):
		body.takeDamage(damage)
