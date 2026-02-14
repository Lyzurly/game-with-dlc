class_name ManageMinigames extends Node
static var ref: ManageMinigames
func _init() -> void:
	ref = self
	
const _MINIGAME_DIRECTORY: String = "res://Minigames/"
const _PCK_STRING: String = ".pck"
const _CALLBACK_GET_MINIGAME_DATA: String = \
	"get_minigame_data"
const _CALLBACK_GET_MINIGAME_SCENE_PATH: String = \
	"get_minigame_scene_path"
	
var current_minigame_node: Node

func _ready() -> void:
	_ready_minigames()
	
func _ready_minigames() -> void:
	var minigame_directory = DirAccess.open(_MINIGAME_DIRECTORY)
	for minigame_path: String in minigame_directory.get_files():
		if minigame_path.ends_with(_PCK_STRING):
			_load_minigame(minigame_path)

func _load_minigame(minigame_path: String) -> void:
	var full_minigame_path: String = _MINIGAME_DIRECTORY + minigame_path
	var minigame_loaded: bool = \
	ProjectSettings.load_resource_pack(
		full_minigame_path)
	if minigame_loaded:
		print("Successfully loaded minigame from ",minigame_path)
	else:
		push_error("Could not load file at ",full_minigame_path)
	
	## E.g. "minigame_thinking"
	var minigame_name: String = \
		minigame_path.trim_suffix(_PCK_STRING)
	
	## E.g. "res://minigame_thinking/minigame_thinking.gd"
	var minigame_script_path: String = \
		"res://" + minigame_name + "/" + minigame_name + ".gd"
	var minigame_data_script: GDScript = \
		load(minigame_script_path)
	var minigame_data_node: Node = minigame_data_script.new()
	add_child(minigame_data_node)
	
	_instantiate_minigame(
		minigame_data_node)
		
func _instantiate_minigame(
minigame_data_node: Node
) -> void:
	var minigame_scene_path: String = \
		minigame_data_node.call(_CALLBACK_GET_MINIGAME_SCENE_PATH)
	var minigame_scene: PackedScene = \
		load(minigame_scene_path)
	current_minigame_node = minigame_scene.instantiate()
	add_child(current_minigame_node)
	
	var minigame_data: Dictionary = \
		minigame_data_node.call(_CALLBACK_GET_MINIGAME_DATA)
		
	_handle_minigame_callbacks_on_creation(
		minigame_data["callback_data_on_creation"])

func _handle_minigame_callbacks_on_creation(
callback_dictionary: Dictionary
) -> void:
	for callback_data_string: String in callback_dictionary:
		callv(callback_data_string,
		callback_dictionary[callback_data_string])

func _assign_3D_minigame_pos(
minigame_dir_name: String,
) -> void:
	var minigame_marker: MinigameMarker = \
		ManageMinigameMarkers.ref.get_minigame_marker(
			minigame_dir_name)
	if not minigame_marker:
		return
		
	var marker_pos: Vector3 = Vector3(
		minigame_marker.global_position)
	current_minigame_node.global_position = marker_pos
