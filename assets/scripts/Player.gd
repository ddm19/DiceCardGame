# Player.gd
extends CharacterBody2D

var livingData: LivingEntity
var _speed : float = 700

func _ready():
	if livingData == null:
		livingData = LivingEntity.new("Player", 100)
	print("Mi nombre es: ", livingData.name)
	print("Salud actual: ", livingData.currentHealth)

func take_damage(amount):
	livingData.take_damage(amount)
	if(livingData.currentHealth <= 0):
		die()


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * _speed
	move_and_slide()

func die():
	queue_free()
