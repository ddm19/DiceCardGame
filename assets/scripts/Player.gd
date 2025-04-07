 # Player.gd
extends CharacterBody2D

var livingData: LivingEntity
var animationController : PlayerAnimationController
@onready var playerSprite : Sprite2D = $Sprite2D
@export var _speed : float = 300
@export var dashMultiplier : float = 50
@export var dashDuration : float = 0.2
@export var dashCooldown : float = 5
@export var isDashing : bool = false
var dashCooldownTimer : Timer
var canDash : bool = true

var dashTimer : Timer 

func _ready():
	if livingData == null:
		livingData = LivingEntity.new("Player", 100)
	animationController = playerSprite
	
	dashTimer = $DashTimer
	dashTimer.wait_time = dashDuration
	dashTimer.timeout.connect(self._onDashTimeout)
	print("Mi nombre es: ", livingData.name)
	print("Salud actual: ", livingData.currentHealth)

func take_damage(amount):
	livingData.take_damage(amount)
	if(livingData.currentHealth <= 0):
		die()


func _physics_process(delta: float) -> void:
	move()
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")

	if(Input.is_action_just_released("dash") && canDash && direction != Vector2.ZERO):
		isDashing = true
		dashTimer.start()
	if(isDashing):
		dash()
		
	if(!canDash && dashCooldownTimer != null):
		print(dashCooldownTimer.time_left)
	
		
	

func move():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * _speed
	if(direction != Vector2.ZERO):
		animationController.updateAnimationState(animationController.ANIMATIONS.MOVE)
	else:
		animationController.updateAnimationState(animationController.ANIMATIONS.IDLE)
	move_and_slide()
	
func dash():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	print("Dashing for ",dashTimer.time_left)
	if(direction != Vector2.ZERO):
		velocity = direction * (dashMultiplier * _speed)
		move_and_slide()
		canDash = false

		
		isDashing = false
		dashTimer.wait_time = dashDuration

func _onDashTimeout():
	isDashing = false
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.one_shot = true
	dashCooldownTimer.wait_time = dashCooldown
	dashCooldownTimer.timeout.connect(self._ondashCooldownTimeout)
	add_child(dashCooldownTimer)
	dashCooldownTimer.start()
	
func _ondashCooldownTimeout():
	canDash = true
	print("Puedes Dashear!")


func die():
	queue_free()
