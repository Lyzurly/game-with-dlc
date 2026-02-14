class_name ManageMinigameMarkers extends Node
static var ref: ManageMinigameMarkers
func _init() -> void:
	ref = self

var all_markers: Array[Marker3D] = [
	]
	
func add_minigame_marker(marker: MinigameMarker) -> void:
	all_markers.append(marker)
	
func get_minigame_marker(marker_name: String) -> MinigameMarker:
	var marker_to_return: MinigameMarker = null
	print("All markers: ",all_markers)
	for marker: MinigameMarker in all_markers:
		if marker.name == marker_name:
			marker_to_return = marker
			
	if not marker_to_return:
		push_error("Minigame marker name ",marker_name," is invalid!")
		
	return marker_to_return
