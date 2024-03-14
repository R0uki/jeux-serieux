extends Control
## Label de la popup
@onready var label = get_node("Main/Label")
## Fonction lançant la popup a son initialisation
func _ready():
	var original_scale = scale
	scale *= 0.1
	for n in range(20,0,-1):
		scale *= 1.1
		await get_tree().create_timer(0.01).timeout
	scale = original_scale
	await get_tree().create_timer(3.0).timeout
	for n in range(50,0,-1):
		scale *= 0.9
		await get_tree().create_timer(0.01).timeout
	self.queue_free()


