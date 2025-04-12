#EnemyBasic.gd
extends CharacterBody2D

class_name Enemy

var livingData : LivingEntity
@export var initialHealth : int
@export var player : Player
@export var speed : float
@export var maxFollowDistance : int
@export var acceleration : float
@export var animationTree : AnimationTree
@onready var navigation : NavigationAgent2D = $NavigationAgent2D
var isRecievingDamage : bool

func _ready() -> void:
	if(livingData == null):
		livingData = LivingEntity.new(self.name,initialHealth)
	player = get_tree().get_root().get_node("Game/Player")



func _physics_process(delta: float) -> void:
	aiMove(delta)

func takeDamage(amount):
	isRecievingDamage = true
	animationTree.get("parameters/playback").travel("DAMAGE")
	await get_tree().create_timer(0.3).timeout 
	livingData.takeDamage(amount)
	isRecievingDamage = false
	if(livingData.currentHealth <= 0):
		die()
	

func die():
	queue_free()

func aiMove(delta):
	if(!isRecievingDamage):
		animationTree.get("parameters/playback").travel("MOVE")
	navigation.target_position = player.position
	velocity = velocity.lerp(getDirectionToPlayer()*speed,acceleration * delta)
	if(getDistanceToPlayer() < maxFollowDistance):
		move_and_slide()
		animationTree.set("parameters/MOVE/blend_position",getDirectionToPlayer())
		animationTree.set("parameters/DAMAGE/blend_position",getDirectionToPlayer())


func getDirectionToPlayer():
	var direction = navigation.get_next_path_position() - global_position
	direction = direction.normalized()
	return direction
	
func getDistanceToPlayer():
	return global_position.distance_to(player.global_position)
