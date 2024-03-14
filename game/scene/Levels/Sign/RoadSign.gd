extends Sign
class_name RoadSign

#← | ↑ | → | ↓


func _ready():
	type_dialogue_box = "RoadSign"
	interaction_area.interaction = Callable(self, "_on_interaction")

