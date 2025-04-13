extends Card

@export var projectileScene : PackedScene
@export var projectileSpeed : float 
@export var projectileDamage : float 
@export var projectileSprite : Sprite2D
var lastDirection : Vector2


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO:
		lastDirection = direction
	var mousePosition = get_global_mouse_position()
	$Sprite.global_position = mousePosition


func doAttack():
	var projectile : Projectile = projectileScene.instantiate() 
	projectile.global_position = self.global_position
	get_parent().add_child(projectile)
	projectile.top_level = true
	projectile.setTargetDirection(get_global_mouse_position())

	projectile.speed = projectileSpeed 
	projectile.damage = projectileDamage
	projectile.changeSprite(projectileSprite)
	projectile.shooterEntityType = LivingEntity.TARGET_TYPE.PLAYER
	player.updateAnimationsDirection(lastDirection)
