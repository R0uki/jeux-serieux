extends Character
class_name Player

@onready var menu_pause = $%UI/PauseMenu
@onready var quest_manager = QuestsManager

################################
#    Fonction godot de base    #
################################

#permet de recupere le node du plyer qui est seulment charger 
#après appui sur le bouton start
func _ready():
	EVENTS.connect("answer_end_dialogue", _on_answer_end_dialogue)
	InteractionManager.getPlayer()
	DialogueManager.getPlayer()
	QuestsManager.getPlayer()
	EVENTS.emit_signal("intro")

#touche clavier :
#	-avancer : ZQSD / touche directrive
#	-sprint : V
#	-Interargir : E
#	-avancer le dialogue : SPACE
#	-confirmer reponse : A / ENTER
#	-menu : ESCAPE

#touche clavier :
#	-avancer : joystick left
#	-sprint : RB
#	-Interargir : B
#	-avancer le dialogue : Y
#	-confirmer reponse : A 
#	-menu : touche menu


#function qui sert a gere les interaction clavier du joueur 
func _input(_event : InputEvent) -> void:
	#recupere la direction du joueur
	set_moving_direction(Input.get_vector("ui_left","ui_right","ui_up","ui_down"))
	
	if Input.is_action_just_pressed("ui_pause") :
		state_machine.set_state("Pause")
		menu_pause.visible = true 
	
	#input a enlever apres dev du jeux
	if Input.is_action_pressed("ui_speed") :
		state_machine.set_state("Idle")
		if speed == 250 :
			speed = 170
		else :
			speed = 250
	
	if Input.is_action_pressed("ui_idle") :
		#suprimer les limite
		var node = get_node("../Amboise/PlayerLimitation/PaysantLimitation")
		node.queue_free()
		node = get_node("../Amboise/PNJ/Guard/GuardPaysant")
		node.queue_free()
		
	
	
	#recupere l'entrer d'une interaction et regarde si il y en a pas deja une en cour
	if Input.is_action_just_pressed("ui_interact") && InteractionManager.can_interact != false:
		state_machine.set_state("Interaction")
	
	#si on interagie pas, regarde si on bouge ou non
	if state_machine.get_state_name() != "Interaction" && state_machine.get_state_name() != "Pause" :
		if moving_direction == Vector2.ZERO: 
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Move")



#################### 
#   Nos fonctions  #
####################

func _on_answer_end_dialogue() :
	state_machine.set_state("Idle")
################
#  Accessors   #
################


##############
#   Signal   #
##############
