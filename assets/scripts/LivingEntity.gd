# LivingEntity.gd
class_name LivingEntity

extends Entity 

var maxHealth: int
var currentHealth: int

func _init(name: String = "",  maxHealth: int = 100):
	super(name)
	self.maxHealth = maxHealth
	self.currentHealth = maxHealth

func takeDamage(amount: int):
	currentHealth = max(currentHealth - amount, 0)
	if currentHealth <= 0:
		print("%s ha muerto" % name)
		

func heal(amount: int):
	currentHealth = min(currentHealth + amount, maxHealth)
