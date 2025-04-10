 # Player.gd
extends CharacterBody2D

class_name Player

var livingData: LivingEntity
@onready var playerSprite : Sprite2D = $Sprite2D
@export var _speed : float = 300
@export var dashMultiplier : float = 3
@export var dashDuration : float = 0.2
@export var dashCooldown : float = 5
@export var isDashing : bool = false
@export var isAttacking : bool = false
@export var cardsList : Array[Card] = []
var dashCooldownTimer : Timer
var canDash : bool = true

var dashTimer : Timer 

enum ANIMATIONSTATES {
	IDLE,
	WALKING,
	DASH,
	MELEE_ATTACK,
	RANGED_ATTACK,
	MAGIC_ATTACK
}
var currentState : ANIMATIONSTATES

func _ready():
	if livingData == null:
		livingData = LivingEntity.new("Player", 100)
	
	dashTimer = $DashTimer
	dashTimer.wait_time = dashDuration
	dashTimer.timeout.connect(self._onDashTimeout)
	print("Mi nombre es: ", livingData.name)
	print("Salud actual: ", livingData.currentHealth)
	updateAnimationsDirection(Vector2.ZERO)

	

func take_damage(amount):
	livingData.take_damage(amount)
	if(livingData.currentHealth <= 0):
		die()


func _physics_process(delta: float) -> void:
	move()
	
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	#DASH & WALKING ANIMS
	if(Input.is_action_just_released("dash") && canDash && direction != Vector2.ZERO):
		updateState(ANIMATIONSTATES.DASH)
		await get_tree().create_timer(0.05).timeout
		isDashing = true
		dashTimer.start()
	if(!isDashing && currentState != ANIMATIONSTATES.DASH && !isAttacking):
		if(direction == Vector2.ZERO):
			updateState(ANIMATIONSTATES.IDLE)
		else:
			updateState(ANIMATIONSTATES.WALKING)
			updateAnimationsDirection(direction)
	#ATTACK
	if(Input.is_action_just_pressed("attack")):
		updateAnimationsDirection(direction)
		cardsList[0].attack()
		isAttacking = true
		get_tree().create_timer(0.5).connect("timeout",attackEnded)
	
	
	if(isDashing):
		dash()
	if(!canDash && dashCooldownTimer != null):
		print(dashCooldownTimer.time_left)

func attackEnded():
	isAttacking = false

func updateAnimationsDirection(direction: Vector2):
	$AnimationTree.set("parameters/WALKING/blend_position",direction)
	$AnimationTree.set("parameters/IDLE/blend_position",direction)
	$AnimationTree.set("parameters/DASH/blend_position",direction)
	$AnimationTree.set("parameters/MELEE_ATTACK/blend_position",direction)


func move():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * _speed
	move_and_slide()

func dash():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	print("Dashing for ",dashTimer.time_left)
	if(direction != Vector2.ZERO):
		velocity = direction * (dashMultiplier * _speed)
		move_and_slide()
		canDash = false
		dashTimer.wait_time = dashDuration

func _onDashTimeout():
	isDashing = false
	dashCooldownTimer = Timer.new()
	dashCooldownTimer.one_shot = true
	dashCooldownTimer.wait_time = dashCooldown
	dashCooldownTimer.timeout.connect(self._ondashCooldownTimeout)
	add_child(dashCooldownTimer)
	dashCooldownTimer.start()
	updateState(ANIMATIONSTATES.WALKING)
	
func _ondashCooldownTimeout():
	canDash = true
	

func updateState(state: ANIMATIONSTATES):
	match state:
		ANIMATIONSTATES.IDLE:
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("IDLE")
				currentState = state
		ANIMATIONSTATES.WALKING:
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("WALKING")
				currentState = state
		ANIMATIONSTATES.DASH:
			print("DASH")
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("DASH")
				currentState = state
		ANIMATIONSTATES.MELEE_ATTACK:
			print("MELEE_ATTACK")
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("MELEE_ATTACK")
				currentState = state
		ANIMATIONSTATES.DASH:
			print("RANGED_ATTACK")
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("IDLE")
				currentState = state
		ANIMATIONSTATES.DASH:
			print("MAGIC_ATTACK")
			if(state != currentState):
				$AnimationTree.get("parameters/playback").travel("IDLE")
				currentState = state
func die():
	queue_free()
