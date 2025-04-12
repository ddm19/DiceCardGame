# LivingEntity.gd
class_name LivingEntity

extends Entity 

@export var maxHealth: int
var currentHealth: int
var livingData : LivingEntity

func _ready() -> void:
	if(livingData):
		livingData = LivingEntity.new()

func _init(name: String = "",  maxHealth: int = 100):
	super(name)
	self.maxHealth = maxHealth
	self.currentHealth = maxHealth
	print("Mi nombre es: ", name)
	print("Salud actual: ", maxHealth)

func takeDamage(amount: int):
	currentHealth = max(currentHealth - amount, 0)
	print("Getting ",amount," damage. Now at ", currentHealth)
	

func heal(amount: int):
	currentHealth = min(currentHealth + amount, maxHealth)
