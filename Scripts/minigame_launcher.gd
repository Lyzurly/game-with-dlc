extends CanvasLayer

@onready var button_toggle_menu: Button = %"Button_Toggle-Menu"
@onready var launcher: MarginContainer = %Launcher_MarginContainer

@onready var button_minigame1: Button = %Button_Minigame1
@onready var button_minigame2: Button = %Button_Minigame2
@onready var button_minigame3: Button = %Button_Minigame3

func _ready() -> void:
	_ready_launcher()
	_ready_connections()
	print(self.name," is ready")
	
func _ready_launcher() -> void:
	_on_menu_toggled(false)

func _ready_connections() -> void:
	button_toggle_menu.toggled.connect(_on_menu_toggled)
	
	button_minigame1.pressed.connect(_on_minigame1_pressed)
	button_minigame2.pressed.connect(_on_minigame2_pressed)
	button_minigame3.pressed.connect(_on_minigame3_pressed)
	
func _on_menu_toggled(toggled: bool) -> void:
	launcher.visible = toggled
	if toggled:
		Camera.ref.change_camera_state(
			Camera.CAMERA_STATES.DOWN)
	else:
		Camera.ref.change_camera_state(
			Camera.CAMERA_STATES.DEFAULT)

func _on_minigame1_pressed() -> void:
	pass
func _on_minigame2_pressed() -> void:
	pass
func _on_minigame3_pressed() -> void:
	pass
