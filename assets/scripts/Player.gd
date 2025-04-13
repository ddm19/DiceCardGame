extends CharacterBody2D
class_name Player

var livingData: LivingEntity

@onready var playerSprite: Sprite2D = $Sprite2D
@export var _speed: float = 300
@export var dashMultiplier: float = 3
@export var dashDuration: float = 0.2
@export var dashCooldown: float = 5
@export var isDashing: bool = false
@export var isAttacking: bool = false
@export var cardsList: Array[CardInstance] = []
@export var audioPlayer: AudioStreamPlayer2D
@export var type : LivingEntity.TARGET_TYPE = LivingEntity.TARGET_TYPE.PLAYER
@onready var dice: Sprite2D = get_tree().get_root().get_node("InGameUi/LowerHUD/Dices")


var sceneInstance
var dashCooldownTimer: Timer
var canDash: bool = true
var dashTimer: Timer
var inputDirection := Vector2.ZERO
var facingDirection := Vector2.DOWN
var attackCooldownTimer: Timer 

enum ANIMATIONSTATES {
	IDLE,
	WALKING,
	DASH,
	MELEE_ATTACK,
	RANGED_ATTACK,
	MAGIC_ATTACK
}
var currentState: ANIMATIONSTATES
var attackAnimationDuration := 0.5 

func _ready():
	if livingData == null:
		livingData = LivingEntity.new("Player", 100)
	
	dashTimer = $DashTimer
	dashTimer.wait_time = dashDuration
	dashTimer.timeout.connect(self._onDashTimeout)
	updateAnimationsDirection(Vector2.DOWN)
	add_starting_cards()
	await get_tree().create_timer(0).timeout 
	var cards_player_node = get_tree().get_root().get_node("InGameUi/Inventory_Menu/Inventory_Container/Cards_Player")
	if cards_player_node:
		cards_player_node.updateCardTextures()
	
	dice.connect("spin_finished", _on_dice_finished)

func takeDamage(amount):
	print("Taking ",amount," damage.")
	livingData.takeDamage(amount)
	if(livingData.currentHealth <= 0):
		die()

func _physics_process(delta: float) -> void:
	move()
	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if inputDirection != Vector2.ZERO:
		facingDirection = inputDirection.normalized()
	updateAnimationsDirection(facingDirection)

	if Input.is_action_just_released("dash") and canDash:
		isDashing = true
		canDash = false
		updateState(ANIMATIONSTATES.DASH)
		dashTimer.start()
		if not audioPlayer.playing:
			audioPlayer.play()
	if isDashing:
		velocity = facingDirection * (dashMultiplier * _speed)
		move_and_slide()
		return
	
	if inputDirection == Vector2.ZERO:
		updateState(ANIMATIONSTATES.IDLE)
	elif (!isAttacking):
		updateState(ANIMATIONSTATES.WALKING)

func move():
	velocity = inputDirection * _speed
	move_and_slide()

func dash():
	pass

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

func attackEnded():
	isAttacking = false

func updateAnimationsDirection(direction: Vector2):
	$AnimationTree.set("parameters/WALKING/blend_position", direction)
	$AnimationTree.set("parameters/IDLE/blend_position", direction)
	$AnimationTree.set("parameters/DASH/blend_position", direction)
	$AnimationTree.set("parameters/MELEE_ATTACK/blend_position", direction)

func updateState(state: ANIMATIONSTATES):
	if state == currentState:
		return
	match state:
		ANIMATIONSTATES.IDLE:
			$AnimationTree.get("parameters/playback").travel("IDLE")
		ANIMATIONSTATES.WALKING:
			$AnimationTree.get("parameters/playback").travel("WALKING")
		ANIMATIONSTATES.DASH:
			$AnimationTree.get("parameters/playback").travel("DASH")
		ANIMATIONSTATES.MELEE_ATTACK:
			$AnimationTree.get("parameters/playback").travel("MELEE_ATTACK")
		ANIMATIONSTATES.RANGED_ATTACK:
			$AnimationTree.get("parameters/playback").travel("RANGED_ATTACK")
		ANIMATIONSTATES.MAGIC_ATTACK:
			$AnimationTree.get("parameters/playback").travel("MAGIC_ATTACK")
	currentState = state

func add_card_from_data(data: CardData):
	var card_scene = preload("res://assets/scenes/AllCards.tscn")
	var card = card_scene.instantiate()
	if card is CardInstance:
		card.setup(data, self)
		cardsList.append(card)

func add_starting_cards():
	var melee_card = preload("res://assets/cards/basic_sword.tres")
	var ranged_card = preload("res://assets/cards/basic_ranged.tres")
	var magic_card = preload("res://assets/cards/basic_magic.tres")
	var testCard = preload("res://assets/cards/mouthBeam/mouthBeam.tres")
	add_card_from_data(melee_card)
	add_card_from_data(melee_card)
	add_card_from_data(ranged_card)
	add_card_from_data(ranged_card)
	add_card_from_data(magic_card)
	add_card_from_data(testCard)

func _on_dice_finished():
	if cardsList.size() > 0:
		var card_index = dice.FinalDice - 1
		if card_index >= 0 and card_index < cardsList.size():
			if(sceneInstance != null):
				sceneInstance.queue_free()
			#TODO: cambiar por el card_index
			sceneInstance = cardsList[5].scene.instantiate()
			add_child(sceneInstance)
			$AttackTimer.wait_time = cardsList[card_index].cooldown
			$AttackTimer.start()
		else:
			print("Número de dado fuera de rango de cartas disponibles")

func attack():
	sceneInstance.attack()
	get_tree().create_timer(0.2).connect("timeout", attackEnded)

func die():
	queue_free()
