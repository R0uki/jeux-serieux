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
	await get_tree().create_timer(2.0).timeout
	for n in range(50,0,-1):
		scale *= 0.9
		await get_tree().create_timer(0.01).timeout
	self.queue_free()

## Fonction permettant de définir le rang du joueur dans le label
func set_label(value: String) -> void:
	GAME.set_action(100)
	if value == "Marchand" :
		GAME.set_resource_1(40)
		GAME.set_resource_2(30)
		GAME.set_resource_3(20)
		GAME.set_coins(50)
	if value == "Bourgeois" :
		GAME.set_resource_1(70)
		GAME.set_resource_2(45)
		GAME.set_resource_3(25)
		GAME.set_coins(150)
	label.set_text("Vous avez atteint le rang de :" + value)
