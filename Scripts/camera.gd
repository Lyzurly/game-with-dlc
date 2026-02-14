class_name Camera extends Camera3D
static var ref: Camera
func _init() -> void:
	ref = self
	
const POS_DEFAULT: float = 0.
const POS_DOWN: float = -.076
const TWEEN_SPEED: float = .4
	
enum CAMERA_STATES {DEFAULT,DOWN}
var camera_state: CAMERA_STATES = CAMERA_STATES.DEFAULT

var tween: Tween

func change_camera_state(state:CAMERA_STATES) -> void:
	camera_state = state
	match camera_state:
		CAMERA_STATES.DEFAULT:
			_tween_camera_vertically(POS_DEFAULT)
		CAMERA_STATES.DOWN:
			_tween_camera_vertically(POS_DOWN)
	
func _tween_camera_vertically(to_pos: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,"v_offset",to_pos,TWEEN_SPEED)

	
