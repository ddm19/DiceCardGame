extends CharacterBody2D

class_name Projectile



@export var targetDirection : Vector2
@export var speed : float
@export var damage : int
@export var shooterEntityType : LivingEntity.TARGET_TYPE
@export var audioPlayer : AudioStreamPlayer2D

func _ready() -> void:
	audioPlayer.play()
	

func _physics_process(delta: float) -> void:
	if(targetDirection):
		velocity = targetDirection * speed
		rotation = targetDirection.angle()
	move_and_slide()

func onScreenExit():
	queue_free()

func setTargetDirection(target: Vector2):
	targetDirection = (target - global_position).normalized()



func onCollisionEntered(body: Node2D) -> void:
	if(typeof(body == LivingEntity) && body.type != shooterEntityType):
		body.takeDamage(damage)
		queue_free()
