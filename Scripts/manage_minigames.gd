class_name ManageMinigames extends Node
static var ref: ManageMinigames
func _init() -> void:
	ref = self
	
const MINIGAME_DIRECTORY: String = 	"res://Minigames/"
const pck_string: String = ".pck"

const MINIGAME_PATH_THINKING: String = "res://Minigames/DLC For Game.pck"

func _ready() -> void:
	_ready_minigames()
	
func _ready_minigames() -> void:
	var minigame_directory = DirAccess.open(MINIGAME_DIRECTORY)
	for minigame_path: String in minigame_directory.get_files():
		if minigame_path.ends_with(".pck"):
			_load_minigame(minigame_path)

func _load_minigame(minigame_path: String) -> void:
	var full_minigame_path: String = MINIGAME_DIRECTORY + minigame_path
	var minigame_loaded: bool = \
	ProjectSettings.load_resource_pack(
		full_minigame_path)
	if minigame_loaded:
		print("Successfully loaded minigame from ",minigame_path)
	else:
		push_error("Could not load file at ",full_minigame_path)
		
	#var minigame_scene: PackedScene = \
		#load("res://thinking_minigame/Scenes/main.tscn")

func _temporary_thinking_loader() -> void:
	var thinking_minigame_loaded: bool = \
		ProjectSettings.load_resource_pack(
			MINIGAME_PATH_THINKING)
	if not thinking_minigame_loaded:
		push_error("Could not load file at ",MINIGAME_PATH_THINKING)
	var thinking_minigame: PackedScene = \
		load("res://thinking_minigame/Scenes/main.tscn")
	var thinking_minigame_node: Node3D = \
		thinking_minigame.instantiate()
	
	add_child(thinking_minigame_node)
	
