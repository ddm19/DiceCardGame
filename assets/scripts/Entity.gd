extends CharacterBody2D

# Entity.gd
class_name Entity

var entity_id: int

func _init(name: String = "", entity_id: int = 0):
	if(!name.is_empty()):
		self.name = name
		self.entity_id = entity_id

func getInfo() -> String:
	return "Nombre: %s, ID: %d" % [name, entity_id]
