extends Sprite2D

class_name PlayerAnimationController

@onready var animationPlayer = $"../AnimationPlayer"

enum ANIMATIONS {  
	IDLE,
	MOVE
 
}  

func updateAnimationState(state: ANIMATIONS):
	match state:
		ANIMATIONS.IDLE:
			animationPlayer.play(ANIMATIONS.IDLE)
