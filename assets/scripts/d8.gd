extends Enemy

@export var attackDistance : float
var isAttacking : bool
@onready var animationPlayer : AnimationPlayer = $Sprite2D/AnimationPlayer
@export var maxCloseUpDistance : int
@export var fleeDistance : int
@export var projectileScene : PackedScene
@export var projectileSpeed : float
@export var projectileSprite : Resource
@export var projectileDamage : int
@export var cooldownAttackTime : float 
var canAttack : bool

func _physics_process(delta): 
	if(getDistanceToPlayer() < maxFollowDistance || getDistanceToPlayer() <= maxCloseUpDistance):
		move_and_slide()
	if(getDistanceToPlayer() <= attackDistance && !isAttacking && getDistanceToPlayer() > fleeDistance):
		attack()
	elif(!isAttacking):
		if(getDistanceToPlayer() <= fleeDistance):
			super._physics_process(-delta*1.5)
		else:
			super._physics_process(delta)

func attack():
	if(!isAttacking):
		isAttacking = true
		var playerDirection = player.global_position
		velocity = 0.3 * velocity
		await get_tree().create_timer(1).timeout
		
		
		
		var projectile : Projectile = projectileScene.instantiate() 
		projectile.position = self.position + getDirectionToPlayer() * 30
		get_parent().add_child(projectile)
		projectile.setTargetDirection(player.global_position)
		projectile.speed = projectileSpeed
		projectile.damage = projectileDamage
		projectile.shooterEntityType = self.type
		
		var backDirection = -getDirectionToPlayer()
		velocity = backDirection * (speed * 3.5)
		await get_tree().create_timer(0.2).timeout
		velocity = Vector2.ZERO
		await get_tree().create_timer(cooldownAttackTime).timeout
		isAttacking = false


func takeDamage(damage):
	super.takeDamage(damage)
	
