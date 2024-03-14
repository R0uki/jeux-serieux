extends Area2D
class_name InteractionArea

@onready var player = get_node("/root/World/Niveaux/Player")

@export var interaction_name : String = "interargir"


#fonction a overwrite dans le code de l'objet interactible
var interaction : Callable = func() :
	pass

func _ready():
	pass
	
func _on_body_entered(body):
	if body == player:
		InteractionManager.register_area(self)

func _on_body_exited(body):
	if body == player :
		InteractionManager.unregister_area(self)
