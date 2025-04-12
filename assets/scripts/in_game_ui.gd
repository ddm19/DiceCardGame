extends CanvasLayer

@onready var inventory_menu = $Inventory_Menu
@onready var inventory_button = $LowerHUD/Inventory_Slot
@onready var inventory_exit_button = $Inventory_Menu/Inventory_Container/Inventory_Exit_Button
@onready var settings_menu = $Settings_Menu
@onready var settings_button = $LowerHUD/Settings_Slot
@onready var settings_exit_button = $Settings_Menu/Settings_Container/Settings_Exit_Button
@onready var dice_sprite = $LowerHUD/Dices
@onready var progress_bar = $LowerHUD/Left_Load
@onready var progress_bar2 = $LowerHUD/Right_Load
@onready var music_slider = $Settings_Menu/Settings_Container/Music_Slider
@onready var sfx_slider = $Settings_Menu/Settings_Container/Sound_Slider
@onready var quit_button = $Settings_Menu/Settings_Container/QuitGame_Button

enum Estado { CARGANDO, GIRANDO, PAUSADO }
var estado_actual = Estado.CARGANDO
var estado_anterior = Estado.CARGANDO
var tiempo_maximo = 6.0
var tiempo_actual = 0.0

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	inventory_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	settings_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	inventory_exit_button.pressed.connect(_on_exit_button_pressed)
	settings_exit_button.pressed.connect(_on_exit_button_pressed)
	progress_bar.max_value = 100
	progress_bar2.max_value = 100
	progress_bar.value = 0
	progress_bar2.value = 0
	dice_sprite.spin_started.connect(_on_spin_started)
	dice_sprite.spin_finished.connect(_on_spin_finished)
	music_slider.value = 0.5
	sfx_slider.value = 0.5
	music_slider.focus_mode = Control.FOCUS_NONE
	sfx_slider.focus_mode = Control.FOCUS_NONE
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	_on_music_slider_value_changed(music_slider.value)
	_on_sfx_slider_value_changed(sfx_slider.value)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _process(delta):
	if estado_actual == Estado.PAUSADO:
		return

	if estado_actual == Estado.CARGANDO:
		tiempo_actual += delta
		var porcentaje = clamp((tiempo_actual / tiempo_maximo) * 100.0, 0.0, 100.0)
		progress_bar.value = porcentaje
		progress_bar2.value = porcentaje
		progress_bar.queue_redraw()
		progress_bar2.queue_redraw()

		if tiempo_actual >= tiempo_maximo:
			tiempo_actual = 0.0
			estado_actual = Estado.GIRANDO
			dice_sprite.start_spin()

	elif estado_actual == Estado.GIRANDO:
		progress_bar.value = 0
		progress_bar2.value = 0
		progress_bar.queue_redraw()
		progress_bar2.queue_redraw()

func _on_spin_started():
	estado_actual = Estado.GIRANDO

func _on_spin_finished():
	tiempo_actual = 0.0
	estado_actual = Estado.CARGANDO

func _on_inventory_button_pressed():
	if inventory_menu.visible:
		_on_exit_button_pressed()
	else:
		inventory_menu.visible = true
		settings_menu.visible = false
		_set_menu_buttons_enabled(false)
		_update_pause_state()

func _on_settings_button_pressed():
	if settings_menu.visible:
		_on_exit_button_pressed()
	else:
		settings_menu.visible = true
		inventory_menu.visible = false
		_set_menu_buttons_enabled(false)
		_update_pause_state()

func _on_exit_button_pressed():
	inventory_menu.visible = false
	settings_menu.visible = false
	_set_menu_buttons_enabled(true)
	_update_pause_state()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if inventory_menu.visible or settings_menu.visible:
			_on_exit_button_pressed()
		else:
			settings_menu.visible = true
			_set_menu_buttons_enabled(false)
			_update_pause_state()

func _update_pause_state():
	var is_paused = inventory_menu.visible or settings_menu.visible

	if is_paused:
		estado_anterior = estado_actual
		estado_actual = Estado.PAUSADO
	else:
		estado_actual = estado_anterior
	get_tree().paused = is_paused
	dice_sprite.set_paused(is_paused)

func _on_music_slider_value_changed(value: float):
	var db_value = linear2db(value)
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, db_value)

func _on_sfx_slider_value_changed(value: float):
	var db_value = linear2db(value)
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus_index, db_value)

func linear2db(value: float) -> float:
	if value <= 0.0:
		return -80.0
	return 20.0 * log(value) / log(10.0)

func _on_quit_button_pressed():
	get_tree().quit()

func _set_menu_buttons_enabled(enabled: bool):
	inventory_button.disabled = not enabled
	settings_button.disabled = not enabled
