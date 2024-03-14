extends Control
## Label de la popup
@onready var label = get_node("Main/Label")
## AudioStreamPlayer
@onready var main_player:AudioStreamPlayer = $MainPlayer
## Fonction lançant la popup a son initialisation
func _ready():
	var original_scale = scale
	scale *= 0.1
	main_player.play()
	for n in range(20,0,-1):
		scale *= 1.1
		await get_tree().create_timer(0.01).timeout
	scale = original_scale


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/Menu/GameMenu.tscn")
