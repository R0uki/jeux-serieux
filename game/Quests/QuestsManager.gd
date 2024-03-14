extends Node2D
class_name QuestManager


var quest_file_path = "res://JSON/AllQuest.json"

var quest_in_progress: Dictionary = {} #les quetes active
var available_quest : Array = [] #toute les quetes possible
var completed_quest : Array = [] #les quetes completer
var enought_ressource : bool = true

var player
var parent_node

var quest_text
var quest_answer 


signal engouth_end_ressource(value)


#met tous lse ID de quete dans une list au demarrage du jeux
func _ready():
	EVENTS.connect("quest_advance", on_quest_advance)
	self.connect("engouth_end_ressource", set_enougth_ressource)
	load_all_quest()


func load_all_quest() : 
	if FileAccess.file_exists(quest_file_path) :
		var quest_file = FileAccess.open(quest_file_path, FileAccess.READ)
		var parse_result = JSON.parse_string(quest_file.get_as_text())
		available_quest = parse_result.keys()


func getPlayer() -> void:
	player = get_node("../World/Niveaux/Player")


func load_quest(quest_id) :
	if FileAccess.file_exists(quest_file_path) :
		var quest_file = FileAccess.open(quest_file_path, FileAccess.READ)
		var parse_result = JSON.parse_string(quest_file.get_as_text())
		quest_in_progress[quest_id] = parse_result[quest_id]
	else :
		print("Le json n'existe pas")



func set_enougth_ressource(value) :
	enought_ressource = value
	

#cherche si la quete est dans la liste des quete disponible
func is_quest_available(quest_id) -> bool:
	return available_quest.has(quest_id)

func is_quest_in_progress(quest_id) -> bool:
	return quest_in_progress.has(quest_id)

func is_quest_completed(quest_id) -> bool:
	return completed_quest.has(quest_id)


#permet de commencer une quete en la mettant dans quest in progress
func start_quest(quest_id : String) :
	var quest_node = self.get_node("Quest").find_child(quest_id+"*")
	
	if quest_node.quest_items != "null" :
		if GAME.get_quest_item() != "default_quest" && GAME.get_quest_item() == quest_node.quest_items :
			if quest_node.amount_give == -1 :
				load_quest(quest_id)
				available_quest.erase(quest_id)
				
				quest_node.quest_available = "false"
				
				on_quest_advance(quest_id)
			else :
				player.state_machine.set_state("Idle")
				return
		else :
			if quest_node.amount_give == 0 :
				load_quest(quest_id)
				available_quest.erase(quest_id)
				
				quest_node.quest_available = "false"
				
				on_quest_advance(quest_id)
			else :
				player.state_machine.set_state("Idle")
				return
	
	elif is_quest_available(quest_id) && quest_node.quest_available == "true":
		load_quest(quest_id)
		available_quest.erase(quest_id)
		
		quest_node.quest_available = "false"
		
		on_quest_advance(quest_id)



#permet d'avancer dans les objectif des quete ou de lance end quest si on est au dernier objectif
func advance_quest(quest_id : String) :
	if quest_in_progress.size() > 0 :
		quest_in_progress[quest_id]["current_stage"] += 1
		var actual_stage : String = str(quest_in_progress[quest_id]["current_stage"])
		
		#print le stage actuelle de la quete
		if actual_stage not in quest_in_progress[quest_id]["stage_quest_description"].keys() :
			if end_quest_possible(quest_id) :
				end_quest(quest_id)
			else :
				emit_signal("engouth_end_ressource", false)
				quest_in_progress[quest_id]["current_stage"] -= 1
				DialogueManager.end_dialogue()



func on_quest_advance(quest_id) :
	advance_quest(quest_id)
	
	if !is_quest_completed(quest_id) :
		show_diologue(quest_id)


func show_diologue(quest_id) :
	quest_answer = []
	quest_text = []
	
	if enought_ressource :
		quest_text = get_text(quest_id)
		quest_answer = get_answer(quest_id)
	else :
		quest_text.append("C'est dommage tu n'a pas les ressources que j'ai besoin.")
		quest_answer.append("Au-revoir")
	
	await DialogueManager.start_dialogue_pnj(quest_text, quest_answer, quest_id)
	enought_ressource = true


func end_quest_possible(quest_id) -> bool:
	var quest_node = self.get_node("Quest").find_child(quest_id+"*")
	return quest_node.enough_ressource()


#permet de dire que une quete est finit en mettant sont id dans completed quest
func end_quest(quest_id : String) : 
	var quest_node = self.get_node("Quest").find_child(quest_id+"*")
	
	if quest_node.quest_items == "null" :
		quest_node.reward()
	else :
		if GAME.get_quest_item() == "default_quest" :
			GAME._on_EVENTS_set_quest_item(quest_node.quest_items)
		else :
			if quest_node.amount_obtained > 0 && quest_node.ressource_obtained == "coins":
				GAME._on_EVENTS_coin_transaction(quest_node.amount_obtained)
			GAME._on_EVENTS_set_quest_item("default_quest")
	
	GAME._on_EVENTS_set_action(quest_in_progress[quest_id]["time"])
	DialogueManager.end_dialogue()
	
	EVENTS.emit_signal("end_quest_indication")
	
	completed_quest.append(quest_id)
	quest_in_progress.erase(quest_id)
	
	quest_answer = []
	quest_text = []


func get_text(quest_id) :
	var index = str(quest_in_progress[quest_id]["current_stage"])
	for i in range(0,quest_in_progress[quest_id]["dialogue"][index]["text"].size()) :
		quest_text.append(quest_in_progress[quest_id]["dialogue"][index]["text"][str(i+1)])
	return quest_text

func get_answer(quest_id) :
	var index = str(quest_in_progress[quest_id]["current_stage"])
	
	if quest_in_progress[quest_id]["dialogue"][index]["answer"].size() == 0 :
		return null
	
	for i in range(0,quest_in_progress[quest_id]["dialogue"][index]["answer"].size()) :
		quest_answer.append(quest_in_progress[quest_id]["dialogue"][index]["answer"][str(i+1)])
	return quest_answer
