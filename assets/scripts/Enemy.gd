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


func _ready() -> void:
	if(livingData == null):
		livingData = LivingEntity.new(self.name,initialHealth)
	player = get_tree().get_root().get_node("Game/Player")



func _physics_process(delta: float) -> void:
	aiMove(delta)

func takeDamage(amount):
	livingData.takeDamage(amount)
	if(livingData.currentHealth <= 0):
		die()

func die():
	queue_free()

func aiMove(delta):
	navigation.target_position = player.position
	var direction = navigation.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction*speed,acceleration * delta)
	if(getDistanceToPlayer() < maxFollowDistance):
		move_and_slide()
		animationTree.set("parameters/blend_position",direction)

func getDistanceToPlayer():
	return global_position.distance_to(player.global_position)
