extends Card

@export var projectileScene : PackedScene
@export var projectileSpeed : float 
@export var projectileDamage : float 
@export var projectileAppearance : PackedScene

var lastDirection : Vector2


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO:
		lastDirection = direction
	var mousePosition = get_global_mouse_position()
	$Sprite.global_position = mousePosition

func createProjectile(projectilesQuantity):
	var base_direction = (get_global_mouse_position() - self.global_position).normalized()
	var total_spread = deg_to_rad(30)
	var angle_interval = 0.0
	if projectilesQuantity > 1:
		angle_interval = total_spread / (projectilesQuantity - 1)
		
	for i in range(projectilesQuantity):
		var offset_angle = -total_spread/2 + angle_interval * i
		var shoot_direction = base_direction.rotated(offset_angle)
		
		var projectile : Projectile = projectileScene.instantiate()
		projectile.global_position = self.global_position
		get_parent().add_child(projectile)
		projectile.top_level = true
		
		
		projectile.setTargetDirection(self.global_position + shoot_direction * 1000)
		projectile.speed = projectileSpeed 
		projectile.damage = projectileDamage
		projectile.changeAppearance(projectileAppearance)
		projectile.shooterEntityType = LivingEntity.TARGET_TYPE.PLAYER
	


func doAttack():
	createProjectile(3)
	
	player.updateAnimationsDirection(lastDirection)
