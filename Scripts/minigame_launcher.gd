class_name MinigameLauncher extends CanvasLayer
static var ref: MinigameLauncher
func _init() -> void:
	ref = self

@onready var minigame_buttons_container: HFlowContainer = %MinigameButtons_HFlowContainer

const _MINIGAME_BUTTON: PackedScene = preload("res://Scenes/minigame_launcher_button.tscn")

func _ready() -> void:
	_ready_launcher()
	print(self.name," is ready")
	
func _ready_launcher() -> void:
	_ready_buttons()

func _ready_buttons() -> void:
	var minigame_data: Dictionary[String,Dictionary] = \
		ManageMinigames.ref.get_minigame_data()
	for minigame_name: String in minigame_data:
		var new_button: Button = _MINIGAME_BUTTON.instantiate()
		minigame_buttons_container.add_child(new_button)
		new_button.text = minigame_name.to_pascal_case()
		new_button.toggled.connect(
			_on_minigame_toggled.bind(
				minigame_name,new_button))
		_name_button(false,minigame_name,new_button)

func _name_button(
indeed: bool,minigame_name:String,minigame_button: Button) -> void:
	if indeed:
		minigame_button.text = "Remove " + minigame_name
	else:
		minigame_button.text = "Load " + minigame_name

func _on_minigame_toggled(
toggled: bool,minigame_name:String,minigame_button:Button) -> void:
	ManageMinigames.ref.activate_minigame(toggled,minigame_name)
	_name_button(toggled,minigame_name,minigame_button)
