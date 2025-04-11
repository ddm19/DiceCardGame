extends Camera2D

@export var player : CharacterBody2D;
@export var speedMultiplier : float; 

func _physics_process(delta: float) -> void:
	var direction : Vector2 = player.transform.get_origin()
	
	self.position = self.position.lerp(player.position,delta*speedMultiplier)
	
