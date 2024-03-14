extends  Node2D
class_name Sign



@onready var interaction_area : InteractionArea = $InteractionArea

@export var dialogue_lines : Array[String] = [ ]

var type_dialogue_box = "Sign"


func _ready(): 
	interaction_area.interaction = Callable(self, "_on_interaction")

func _on_interaction() -> void :
	DialogueManager.start_dialogue(dialogue_lines, type_dialogue_box)
