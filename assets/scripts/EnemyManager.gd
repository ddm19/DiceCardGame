extends Node

@export var cards_pool_scene: PackedScene
@export var enemy_scenes: Array[PackedScene]
var enemies_alive : int = 0
var wave_count : int = 1
var countdown_time : float = 10.0 
var countdown_timer : Timer
var is_counting_down : bool = false
@export var new_map_texture: Texture2D
@export var card_sprites : Array[PackedScene]

@onready var player: Player = get_node("/root/Game/Player")
@onready var wave_label: Label = get_node("/root/InGameUi/Panel/Label")

func _ready():
	
	countdown_timer = Timer.new()
	add_child(countdown_timer)
	countdown_timer.wait_time = 1.0  
	countdown_timer.one_shot = false
	countdown_timer.timeout.connect(_on_countdown_tick)
	countdown_timer.start() 
	update_wave_label()

func register_enemy():
	enemies_alive += 1

func enemy_died(position: Vector2):
	enemies_alive -= 1
	if enemies_alive == 0:
		drop_card(position)
		if wave_count < 6:
			start_countdown()

func drop_card(position: Vector2):
	pass

	
	print("Carta droppeada en: ", position)

func start_countdown():
	countdown_timer.stop()  
	countdown_time = 10.0  
	is_counting_down = true
	countdown_timer.start()

	update_wave_label()

func _on_countdown_tick():
	if is_counting_down:
		countdown_time -= 1
		if countdown_time <= 0:
			is_counting_down = false
			countdown_time = 10.0 
			wave_count += 1
			var map_sprite = get_tree().get_root().get_node("Game/Map1")
			var texture_path = "res://assets/sprites/maps/Map" + str(wave_count + 1) + ".png"
			map_sprite.texture = load(texture_path)
			spawn_new_enemies()

		update_wave_label()

func update_wave_label():
	if is_counting_down:
		wave_label.text = str(countdown_time)
	else:
		wave_label.text = "Wave: " + str(wave_count)

func spawn_new_enemies():
	var num_enemies = 10
	var enemies_to_spawn: Array[PackedScene] = []

	match wave_count:
		1:
			enemies_to_spawn = enemy_scenes.filter(func(e): return e.resource_path.contains("d4"))
		2:
			enemies_to_spawn = enemy_scenes.filter(func(e): return e.resource_path.contains("d8"))
		3:
			enemies_to_spawn = enemy_scenes.filter(func(e): return e.resource_path.contains("d4") or e.resource_path.contains("d8"))
		4:
			enemies_to_spawn = enemy_scenes.filter(func(e): return e.resource_path.contains("d10"))
		5:
			enemies_to_spawn = enemy_scenes.filter(func(e): return e.resource_path.contains("d12"))
		6:
			enemies_to_spawn = enemy_scenes 

	if enemies_to_spawn.is_empty():
		print("No hay enemigos configurados para esta oleada")
		return

	for i in range(num_enemies):
		var random_scene = enemies_to_spawn[randi() % enemies_to_spawn.size()]
		var enemy_instance = random_scene.instantiate()
		add_child(enemy_instance)
		var margin = 100
		enemy_instance.global_position = Vector2(randi() % (2400 - 2 * margin) + margin, randi() % (2400 - 2 * margin) + margin)
