extends Node
class_name StateMachine


var current_state : Node = null : set = set_state, get = get_state
var previous_state : Node = null : get = get_previous_state

signal state_change(state)


################################
#    Fonction godot de base    #
################################ 

#sert a mettre a jour les animation par rapport a leur etat 
#si la function si la fonction update d'un etat est overwrite
func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)



################
#  Accessors   #
################
func set_state(state) -> void:
	if state is String: #sert a dans tous les cas recupere le noeud de l'etat en question
		state = get_node_or_null(state)
	
	if state == current_state:
		return
	if current_state != null :
		current_state.exit_state()
	
	previous_state = current_state
	current_state = state
	
	current_state.enter_state()
	
	emit_signal("state_change", current_state)
func get_state() -> Node :
	return current_state

func get_state_name() -> String :
	if current_state == null :
		return ""
	return current_state.name

func get_previous_state() -> Node :
	return previous_state

