extends Node2D
class_name Quest


@export var quest_id : String

@export_enum("resource_1", "resource_2", "resource_3", "coins", "quest_item") var ressource_obtained : String = "resource_1"
@export var amount_obtained : int
@export_enum("resource_1", "resource_2", "resource_3", "coins", "quest_item") var ressource_give : String = "resource_1"
@export var amount_give : int

@export_enum("tableau_noble","wheat", "default_quest", "defined_quest","null") var quest_items : String = "null"

@export_enum("true", "false") var quest_available : String = "true"
@export_enum("true", "false") var quest_finished : String = "false"

var box_answer


func _ready():
	EVENTS.connect("get_box_answer", get_box_answer)
	EVENTS.connect("get_quest", get_quest)


func get_quest(node) :
	if node.quest_id == self.quest_id :
		node.quest = self

func get_box_answer(node : VBoxContainer) :
	if node.quest_id == self.quest_id :
		box_answer = node
		
		box_answer.answer_1 = Callable(self, "_on_answer_1")
		box_answer.answer_2 = Callable(self, "_on_answer_2")
		box_answer.answer_2 = Callable(self, "_on_answer_3")


func _on_answer_1() -> void:
	DialogueManager.end_dialogue()
	EVENTS.emit_signal("answer_end_dialogue")

func _on_answer_2() -> void:
	QuestsManager.on_quest_advance(quest_id)
	EVENTS.emit_signal("answer_end_dialogue")

func _on_answer_3() -> void:
	pass

func enough_ressource() -> bool:
	var ressource : int
	match ressource_give :
		"resource_1" : 
			ressource = GAME.get_resource_1()
		"resource_2" : 
			ressource = GAME.get_resource_2()
		"resource_3" : 
			ressource = GAME.get_resource_3()
		"coins" :
			ressource = GAME.get_coins()
		"quest_item" :
			if GAME.get_quest_item() == "default_quest" && amount_obtained == 1:
				return true
			elif GAME.get_quest_item() == quest_items && amount_give == -1: 
				return true
			else : 
				return false
	
	if ressource == 0 :
		return false
	
	if ressource + amount_give < 0 :
		return false
	
	if ressource :
		pass
	return true


func reward() :
	quest_finished = "true"
	
	#ger les gain du joueur
	match ressource_obtained :
		"resource_1" : 
			GAME._on_EVENTS_resource_1_transaction(amount_obtained)
		"resource_2" : 
			GAME._on_EVENTS_resource_2_transaction(amount_obtained)
		"resource_3" : 
			GAME._on_EVENTS_resource_3_transaction(amount_obtained)
		"coins" : 
			GAME._on_EVENTS_coin_transaction(amount_obtained)
	
	#gere ce qeu donne le joueur 
	match ressource_give :
		"resource_1" : 
			GAME._on_EVENTS_resource_1_transaction(amount_give)
		"resource_2" : 
			GAME._on_EVENTS_resource_2_transaction(amount_give)
		"resource_3" : 
			GAME._on_EVENTS_resource_3_transaction(amount_give)
		"coins" : 
			GAME._on_EVENTS_coin_transaction(amount_give)
