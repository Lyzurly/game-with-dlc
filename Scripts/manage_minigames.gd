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
	
enum _MINIGAME_DATA {PATH,CONFIG_NODE,MINIGAME_NODE}
var _minigame_data_contents: Dictionary[_MINIGAME_DATA,Variant] = {
	_MINIGAME_DATA.PATH: "",
	_MINIGAME_DATA.CONFIG_NODE: null,
	_MINIGAME_DATA.MINIGAME_NODE: null
	}

## "minigame_name": "minigame_path"
var _loadable_minigames: Dictionary[String,Dictionary] = {}
	
var current_minigame_node: Node

func _ready() -> void:
	_ready_minigames()
	
func _ready_minigames() -> void:
	var minigame_directory: DirAccess = \
		DirAccess.open(_MINIGAME_DIRECTORY)
	#push_error(_MINIGAME_DIRECTORY," load error: ",DirAccess.get_open_error())
	for minigame_file_name: String in minigame_directory.get_files():
		if minigame_file_name.ends_with(_PCK_STRING):
			_ready_minigame(minigame_file_name)

func _ready_minigame(minigame_file_name: String) -> void:
	var full_minigame_path: String = \
		_MINIGAME_DIRECTORY + minigame_file_name
	var minigame_name: String = \
		minigame_file_name.trim_suffix(_PCK_STRING)
		
	var minigame_data_dictionary: Dictionary[_MINIGAME_DATA,Variant] = \
		_minigame_data_contents.duplicate()
		
	minigame_data_dictionary[_MINIGAME_DATA.PATH] = full_minigame_path
	
	_loadable_minigames.get_or_add(
		minigame_name,minigame_data_dictionary)
		
	_load_minigame(minigame_name,full_minigame_path)
	
func get_minigame_data() -> Dictionary[String,Dictionary]:
	return _loadable_minigames
		
func activate_minigame(indeed: bool,minigame_name: String) -> void:
	var minigame_data_config_node: Node = \
		_loadable_minigames[minigame_name][_MINIGAME_DATA.CONFIG_NODE]
	if indeed:
		var instantiated_minigame: Node = \
			_instantiate_minigame(
				minigame_data_config_node)

		_loadable_minigames[minigame_name][_MINIGAME_DATA.MINIGAME_NODE] = \
			instantiated_minigame
	else:
		var minigame_node: Node = \
			_loadable_minigames[minigame_name][_MINIGAME_DATA.MINIGAME_NODE]
		minigame_node.queue_free()
		_loadable_minigames[minigame_name][_MINIGAME_DATA.MINIGAME_NODE] = null
		
func _load_minigame(minigame_name:String,full_minigame_path: String) -> void:
	var minigame_loaded: bool = \
	ProjectSettings.load_resource_pack(
		full_minigame_path)
	if minigame_loaded:
		print("Successfully loaded minigame from ",full_minigame_path)
	else:
		push_error("Could not load file at ",full_minigame_path)
	
	_create_and_add_minigame_data_script(minigame_name)

func _create_and_add_minigame_data_script(minigame_name: String) -> void:
	## E.g. "res://minigame_thinking/minigame_thinking.gd"
	var minigame_script_path: String = \
		"res://" + minigame_name + "/" + minigame_name + ".gd"
	var minigame_data_script: GDScript = \
		load(minigame_script_path)
	var minigame_data_node: Node = minigame_data_script.new()
	add_child(minigame_data_node)

	_loadable_minigames[minigame_name][_MINIGAME_DATA.CONFIG_NODE] = \
		minigame_data_node
		
func _instantiate_minigame(
minigame_data_node: Node
) -> Node:
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
		
	return current_minigame_node

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
