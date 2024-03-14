extends CharacterBody2D
class_name Character

#definition d'une var qui recupere un node AnimatedSprite
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var state_machine = get_node("StateMachine")


#dictionnaire qui a pour param les different direction possible
var dir_dict : Dictionary = {
	"Left" : Vector2.LEFT,
	"Right" : Vector2.RIGHT,
	"Down" : Vector2.DOWN,
	"Up" : Vector2.UP
}


var speed = 170
var moving_direction := Vector2.ZERO : set = set_moving_direction, get = get_moving_direction#direction de deplacement
var facing_direction := Vector2.DOWN : set = set_facing_direction, get = get_facing_direction #direction dans laquel le perso regarde


signal facing_direction_change
signal moving_direction_change


################################
#    Fonction godot de base    #
################################ 




#################### 
#   Nos fonctions  #
####################

#met a jour l'animation en se basant sur son etat et facing_direction
func _update_animation() -> void :
	var dir_name = _find_dir_name(facing_direction)
	var state_name = state_machine.get_state_name()
	
	if state_name == "Pause" || state_name == "Interaction" : 
		return
	
	if state_name != "":
		animated_sprite.play(state_name+dir_name)


#cherche la direction dans laquelle le joueur est tourné
#	-on commence par cherche l'indec de notre direction
#	-puis on cherche notre valeur par rapport a l'index 
#	-finalement on retourne la valeur trouve
func _find_dir_name(dir : Vector2) -> String :
	var dir_value_array = dir_dict.values() #return les valeur du dico dans un array
	var dir_index = dir_value_array.find(dir) 
	if dir_index == -1 :
		return ""
	
	var dir_key_array = dir_dict.keys()
	var dir_key = dir_key_array[dir_index]
	return dir_key



################
#  Accessors   #
################

#accesseur pour mettre à jour la facing direction du charactere et pour la recuperer
func set_facing_direction(value: Vector2) -> void:
	if facing_direction != value && state_machine.get_state_name() != "Interaction":
		facing_direction = value
		emit_signal("facing_direction_change")
func get_facing_direction() -> Vector2:
	return facing_direction

#accesseur pour mettre à jour la moving direction du charactere et pour la recuperer
func set_moving_direction(value: Vector2) -> void:
	if moving_direction != value:
		moving_direction = value
		emit_signal("moving_direction_change")
func get_moving_direction() -> Vector2:
	return moving_direction




##############
#   Signal   #
##############

func _on_state_change(_new_state : Object) -> void:
	_update_animation()

func _on_facing_direction_change() -> void:
	_update_animation()

func _on_moving_direction_change() -> void:
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return 
	
	var sign_direction = Vector2(sign(moving_direction.x), sign(moving_direction.y))
	
	#si c'est vrai ce n'est pas une diagonale
	if sign_direction == moving_direction: 
		set_facing_direction(moving_direction)
	#sinon le mouvement et une diagonal
	else :
		if sign_direction.x == facing_direction.x :
			set_facing_direction(Vector2(0,sign_direction.y))
		else :
			set_facing_direction(Vector2(sign_direction.x,0))
	
