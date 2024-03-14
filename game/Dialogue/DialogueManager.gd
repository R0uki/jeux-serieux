extends Node

#il y a 3 version differente : 
#  -pnj : on doit donner une liste de string pour les dialogue et les réponse
#  -RoadSign : on donne une liste de string, afficher 4 par 4
#  -Sign: on lui donne une list de string, qui sont afficher 1 par 1


@onready var dialogue_box_scene = preload("res://Dialogue/DialogueBox.tscn")

var player
var dialogue_box
var dialogue_quest_id

var dialogue_lines 
var answer_lines 
var text : String = " "
var type_interaction 

var is_dialogue_active = false
var can_advance_in_dailogue = false

var line_index = 0
var line_max_index = 4



func _ready():
	pass

func getPlayer() -> void:
	player = get_node("../World/Niveaux/Player")


#################### 
#   dialogue pnj   #
####################


func start_dialogue_pnj(texte, answer , quest) :
	if is_dialogue_active :
		return
	dialogue_quest_id = quest
	
	type_interaction = "PNJ"
	
	answer_lines = answer
	dialogue_lines = texte
	
	_show_dialogue_box()
	
	is_dialogue_active = true


func _show_dialogue_pnj() :
	
	#mise en place du label suivant ce que l'ont veut
	dialogue_box.label.size.y = 82
	
	if dialogue_lines[line_index].length() >= 215 :
		dialogue_lines[line_index] = "Le texte est trop grand"
	
	dialogue_box.display_text(dialogue_lines[line_index])
	line_index += 1
	
	if line_index == dialogue_lines.size() :
		if answer_lines != null :
			var label_keys = dialogue_box.get_node("LabelKeys")
			label_keys.text = "a"
			
			dialogue_box.display_answer(answer_lines)
			EVENTS.emit_signal("get_quest_id" , dialogue_quest_id)



#################### 
#   dialogue sign  #
####################

#lancement d'un dialogue pour panneau
func start_dialogue(lines, type) :
	if is_dialogue_active :
		return
	if type == "Sign" :
		line_max_index = 1
	
	type_interaction = type
	dialogue_lines = lines
	
	_show_dialogue_box()
	is_dialogue_active = true


func _show_dialogue_sign() :
	#mise en place du label suivant ce que l'ont veut
	dialogue_box.label.size.y = 165
	if type_interaction == "RoadSign" :
		dialogue_box.label.horizontal_alignment = SIDE_LEFT
	
	if line_max_index > dialogue_lines.size() :
		line_max_index = dialogue_lines.size()
	
	self.recupere_dialogue_sign()
	dialogue_box.display_text(text)
	
	if type_interaction == "Sign":
		line_max_index += 1
	else :
		line_max_index += 4
	
	#on remet le text a zero pour etre sur de ne pas avoir de probleme
	text = ""


#recupere les ligne des Sign est les met dans text
#facont different entre sign et roadSign
func recupere_dialogue_sign() :
	for i in range(line_index, line_max_index) :
		text += dialogue_lines[line_index] + "\n"
		line_index += 1
	if type_interaction == "Sign" && text.length() >= 270 || type_interaction == "PNJ_R" && text.length() >= 270 :
		text = "Le texte est trop grand"



#################### 
#      Autre       #
####################

#affichege de la boite de dialogue
func _show_dialogue_box() :
	player.state_machine.set_state("Pause")
	dialogue_box = dialogue_box_scene.instantiate()
	get_node("/root/World/UI").add_child(dialogue_box)
	dialogue_box.finished_displayed.connect(_text_dialogue_finished_displayed)
	
	if type_interaction == "PNJ" :
		_show_dialogue_pnj()
	else : 
		_show_dialogue_sign()
	print(player.state_machine.get_state_name())


#nous previent quand le texte a finit d'etre afficher, affin de dire de pouvoir continuer le dialogue
#pas tres utile, masi evite des probleme, et peut etre utiliser si on veut afficher 1 carcatere par 1
func _text_dialogue_finished_displayed() :
	can_advance_in_dailogue = true


#gere les input pour les dialogue
func _input(event):
	#ui_dailogue = h
	if event.is_action_pressed("ui_dailogue") && is_dialogue_active :
		#gere le input si c'est dialogue de pnj
		if type_interaction == "PNJ" :
			if answer_lines == null :
				end_dialogue()
				EVENTS.emit_signal("quest_advance", dialogue_quest_id)
				return
		
		#gere le input si c'est dialogue de sign
		else :
			if line_index >= dialogue_lines.size() :
				end_dialogue()
				player.state_machine.set_state("Idle")
				return
			_show_dialogue_sign()


func end_dialogue() :
	line_index = 0
	line_max_index = 4
	is_dialogue_active = false
	dialogue_box.queue_free()

