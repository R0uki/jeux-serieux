## AUTOLOAD du jeu
extends Node
###### AUTOLOAD du jeu (aka Controller/MasterController)
## IMPORTATION
const rankEnum = preload("res://scene/UserUi/rankEnum.gd")

### Variables du jeu
## Pièce du joueur
var coins : int = 0 : set = set_coins, get = get_coins
var resource_1 : int = 0 : set = set_resource_1, get = get_resource_1
var resource_2 : int = 0 : set = set_resource_2, get = get_resource_2
var resource_3 : int = 0 : set = set_resource_3, get = get_resource_3
var quest_item : String = "empty" : set = set_quest_item, get = get_quest_item
var action : int : set = set_action, get = get_action
var rank : String : set = set_rank, get = get_rank
## Connections des événements au fonctions du script
func _ready() -> void:
	
	rank = "Paysan" # Pour éviter que l'écran de mort crash
	# SET
	EVENTS.connect("set_coin",_on_EVENTS_set_coin)
	EVENTS.connect("set_res_1",_on_EVENTS_set_resource_1)
	EVENTS.connect("set_res_2",_on_EVENTS_set_resource_2)
	EVENTS.connect("set_res_3",_on_EVENTS_set_resource_3)
	EVENTS.connect("set_q_item",_on_EVENTS_set_quest_item)
	EVENTS.connect("set_action",_on_EVENTS_set_action)
	EVENTS.connect("set_rank",_on_EVENTS_set_rank)
	# GIVE
	EVENTS.connect("coin_trans",_on_EVENTS_coin_transaction)
	EVENTS.connect("res_1_trans",_on_EVENTS_resource_1_transaction)
	EVENTS.connect("res_2_trans",_on_EVENTS_resource_2_transaction)
	EVENTS.connect("res_3_trans",_on_EVENTS_resource_3_transaction)
	EVENTS.connect("action_trans",_on_EVENTS_set_quest_item)
	# GET
	EVENTS.connect("get_coin",_on_EVENTS_get_coin)
	EVENTS.connect("get_res_1",_on_EVENTS_get_resource_1)
	EVENTS.connect("get_res_2",_on_EVENTS_get_resource_2)
	EVENTS.connect("get_res_3",_on_EVENTS_get_resource_3)
	EVENTS.connect("get_q_item",_on_EVENTS_get_quest_item)
	EVENTS.connect("get_action",_on_EVENTS_set_quest_item)
	EVENTS.connect("get_rank",_on_EVENTS_get_rank)
	#QUEST
	
	
	
	# Initialisation à 0

	pass


### SETTERS
##  Définit la valeur des pièces
func set_coins(value: int) -> void:
	coins = value
	EVENTS.emit_signal("coins_changed",value)
	pass
##  Définit la valeur de la ressource 1
func set_resource_1(value: int) -> void:
	resource_1 = value
	EVENTS.emit_signal("resource_1_changed",value)
	pass
##  Définit la valeur de la ressource 2
func set_resource_2(value: int) -> void:
	resource_2 = value
	EVENTS.emit_signal("resource_2_changed",value)
	pass
##  Définit la valeur de la ressource 3
func set_resource_3(value: int) -> void:
	resource_3 = value
	EVENTS.emit_signal("resource_3_changed",value)
	pass
##  Définit l'objet de quête
func set_quest_item(value: String) -> void:
	quest_item = value
	EVENTS.emit_signal("quest_item_changed",value)
	pass
##  Définit le nombre de point d'action
func set_action(value: int) -> void:
	action = value
	EVENTS.emit_signal("action_changed",value)
	pass
##  Définit le rang
func set_rank(value: String) -> void:
	rank = value
	EVENTS.emit_signal("rank_changed",value)
	pass
### GIVERS
# Ajoute/soustraits au attributs
##  Ajoute/soustraits des pièces au joueur
func give_coins(value: int) -> void:
	coins += value
	EVENTS.emit_signal("coins_changed",coins)
	pass
##  Ajoute/soustraits des ressources 1 au joueur
func give_resource_1(value: int) -> void:
	resource_1 += value
	EVENTS.emit_signal("resource_1_changed",resource_1)
	pass
##  Ajoute/soustraits des ressources 2 au joueur
func give_resource_2(value: int) -> void:
	resource_2 += value
	EVENTS.emit_signal("resource_2_changed",resource_2)
	pass
##  Ajoute/soustraits des ressources 3 au joueur
func give_resource_3(value: int) -> void:
	resource_3 += value
	EVENTS.emit_signal("resource_3_changed",resource_3)
	pass
##  Ajoute/soustraits des points d'actions au joueur
func give_action(value: int) -> void:
	action += value
	EVENTS.emit_signal("action_changed",action)
	pass 
	
### GETTERS
# Obtient la valeur des attributs
func get_coins() -> int:return coins
func get_resource_1() -> int:return resource_1 
func get_resource_2() -> int:return resource_2
func get_resource_3() -> int:return resource_3
func get_quest_item() -> String:return quest_item
func get_action() -> int:return action
func get_rank() -> String:return rank


### Fonctions de traitement des événements

# SET EVENTS
func _on_EVENTS_set_coin(value: int) -> void:
	set_coins(value)
	pass
func _on_EVENTS_set_resource_1(value: int) -> void:
	set_resource_1(value)
	pass
func _on_EVENTS_set_resource_2(value: int) -> void:
	set_resource_2(value)
	pass
func _on_EVENTS_set_resource_3(value: int) -> void:
	set_resource_3(value)
	pass
func _on_EVENTS_set_quest_item(value: String) -> void:
	set_quest_item(value)
	pass
func _on_EVENTS_set_action(value) -> void:
	set_action(value)
	pass
func _on_EVENTS_set_rank(value: String) -> void:
	set_rank(value)
	pass
	
	
# GIVE EVENTS
func _on_EVENTS_coin_transaction(value: int) -> void:
	give_coins(value)
	pass
func _on_EVENTS_resource_1_transaction(value: int) -> void:
	give_resource_1(value)
	pass
func _on_EVENTS_resource_2_transaction(value: int) -> void:
	give_resource_2(value)
	pass
func _on_EVENTS_resource_3_transaction(value: int) -> void:
	give_resource_3(value)
	pass
	
# GET EVENTS

func _on_EVENTS_get_coin() -> int:return get_coins()
func _on_EVENTS_get_resource_1() -> int:return get_resource_1()
func _on_EVENTS_get_resource_2() -> int:return get_resource_2()
func _on_EVENTS_get_resource_3() -> int:return get_resource_3()
func _on_EVENTS_get_quest_item() -> String:return get_quest_item()
func _on_EVENTS_get_rank() -> String:return get_rank()












