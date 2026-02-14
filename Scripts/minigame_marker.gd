class_name MinigameMarker extends Marker3D

func _ready() -> void:
	print(self.name," marker is ready")
	ManageMinigameMarkers.ref.add_minigame_marker(
		self)
		
