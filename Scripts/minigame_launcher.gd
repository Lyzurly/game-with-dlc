class_name MinigameLauncher extends CanvasLayer
static var ref: MinigameLauncher
func _init() -> void:
	ref = self
	
@onready var _button_toggle_menu: Button = %"Button_Toggle-Menu"
@onready var _launcher: MarginContainer = %Launcher_MarginContainer
@onready var minigame_buttons_container: HFlowContainer = %MinigameButtons_HFlowContainer
@onready var filesystem_tree: Tree = %FileSystem_Tree

const _MINIGAME_BUTTON: PackedScene = preload("res://Scenes/minigame_launcher_button.tscn")

func _ready() -> void:
	_ready_launcher()
	_ready_connections()
	_ready_tree()
	print(self.name," is ready")
	
func _ready_launcher() -> void:
	_on_menu_toggled(false)
	_ready_buttons()

func _ready_buttons() -> void:
	var minigame_data: Dictionary[String,String] = \
		ManageMinigames.ref.get_minigame_data()
	for minigame_name: String in minigame_data:
		var new_button: Button = _MINIGAME_BUTTON.instantiate()
		minigame_buttons_container.add_child(new_button)
		new_button.text = minigame_name.to_pascal_case()
		new_button.toggled.connect(
			_on_minigame_toggled.bind(
				minigame_name))
	if minigame_buttons_container.get_children().size() > 0:
		_button_toggle_menu.visible = true

func _ready_connections() -> void:
	_button_toggle_menu.toggled.connect(_on_menu_toggled)
	
func _ready_tree() -> void:
	filesystem_tree.clear()
	var res_string: String = "res://"
	var res: DirAccess = DirAccess.open(res_string)
	var dir_root: TreeItem = filesystem_tree.create_item()
	dir_root.set_text(0,res_string)
	_unpack_dir_to_tree(res,dir_root,res_string)

func repopulate_tree() -> void:
	_ready_tree()
	
func _unpack_dir_to_tree(
dir_to_scan: DirAccess, parent: TreeItem, parent_string: String) -> void:
	for directory_string: String in dir_to_scan.get_directories():
		if directory_string.begins_with("."):
			continue
		#var partial_path_string: String = parent_string + directory_string + "/"
		#print("Trying to open ",partial_path_string)
		var actual_directory: DirAccess = \
			DirAccess.open(directory_string)
		#push_error(partial_path_string," load error: ",DirAccess.get_open_error())
		var dir_root: TreeItem = filesystem_tree.create_item(parent)
		dir_root.set_text(0,directory_string)
		var child_dirs: PackedStringArray = actual_directory.get_directories()
		var child_files: PackedStringArray = actual_directory.get_files()
		if child_files.size() > 0 \
		or child_dirs.size() > 0:
			for child_dir: String in child_dirs:
				var new_dir: TreeItem = \
					filesystem_tree.create_item(dir_root)
				new_dir.set_text(0,child_dir)
				var path_string: String = parent_string + directory_string + "/" + child_dir
				var actual_new_dir: DirAccess = \
					DirAccess.open(path_string)
				_unpack_dir_to_tree(actual_new_dir,new_dir,path_string)		
			for child_file: String in child_files:
				var new_file: TreeItem = \
					filesystem_tree.create_item(dir_root)
				new_file.set_text(0,child_file)	
	
func _on_menu_toggled(toggled: bool) -> void:
	_launcher.visible = toggled
	if toggled:
		Camera.ref.change_camera_state(
			Camera.CAMERA_STATES.DOWN)
	else:
		Camera.ref.change_camera_state(
			Camera.CAMERA_STATES.DEFAULT)

func _on_minigame_toggled(toggled: bool,minigame_name:String) -> void:
	ManageMinigames.ref.activate_minigame(toggled,minigame_name)
