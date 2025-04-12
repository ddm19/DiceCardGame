#EnemyBasic.gd
extends Node

var livingData : LivingEntity
@export var initialHealth : int

func _ready() -> void:
	if(livingData == null):
		livingData = LivingEntity.new(self.name,initialHealth)

func takeDamage(amount):
	livingData.takeDamage(amount)
	if(livingData.currentHealth <= 0):
		die()

func die():
	queue_free()
