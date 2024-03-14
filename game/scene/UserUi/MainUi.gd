## Noeud gérant l'affichage de l'interface utilisateur
extends CanvasLayer

## Importation de l'enum pour le rang du joueur
const rankEnum = preload("res://scene/UserUi/rankEnum.gd")

### LABEL RESSOURCES
## Label des pièces
@onready var coin = get_node("MainWindow/Coin/ItemIcon/CoinLabel")
## Label de la bar d'action
@onready var action_bar = get_node("MainWindow/ActionBarControl/ActionBar")
## Label ressource 1
@onready var res_1 = get_node("MainWindow/Inventory/Resource1/ResourceLabel")
## Label ressource 2
@onready var res_2 = get_node("MainWindow/Inventory/Resource2/ResourceLabel")
## Label ressource 3
@onready var res_3 = get_node("MainWindow/Inventory/Resource3/ResourceLabel")

### TEXTURES RESSOURCES
## Icone objet de quête
@onready var q_item = get_node("MainWindow/Inventory/QuestItem/ItemIcon/ItemTexture")
## Icone pièce
@onready var coin_icon = get_node("MainWindow/Coin/ItemIcon/CoinIcon")
## Icone ressource 1
@onready var res_1_icon = get_node("MainWindow/Inventory/Resource1/ItemIcon/Icon")
## Icone ressource 2
@onready var res_2_icon = get_node("MainWindow/Inventory/Resource2/ItemIcon/Icon")
## Icone ressource 3
@onready var res_3_icon = get_node("MainWindow/Inventory/Resource3/ItemIcon/Icon")
### VALEURS DU JOUEUR
## Icone du rang du joueur
@onready var rank_icon = get_node("MainWindow/CharacterSheet/CharacterRank/Rank")
## Label du rang du joueur
@onready var rank_label = get_node("MainWindow/CharacterSheet/CharacterLabels/RankName/RankLabel")
## Label du nom du joueur
@onready var chara_label = get_node("MainWindow/CharacterSheet/CharacterLabels/Name/NameLabel")
## Icone du joueur
@onready var chara_icon = get_node("MainWindow/CharacterSheet/CharacterIcon/Icon")

## Initialisation des signaux pour mettre à jour l'interface utilisateur
func _ready():
	EVENTS.connect("coins_changed",_on_EVENTS_coins_changed)
	EVENTS.connect("resource_1_changed",_on_EVENTS_resource_1_changed)
	EVENTS.connect("resource_2_changed",_on_EVENTS_resource_2_changed)
	EVENTS.connect("resource_3_changed",_on_EVENTS_resource_3_changed)
	EVENTS.connect("quest_item_changed",_on_EVENTS_quest_item_changed)
	EVENTS.connect("action_changed",_on_EVENTS_action_changed)
	EVENTS.connect("rank_changed",_on_EVENTS_rank_changed)
	EVENTS.connect("death",_pop_up_death)
	EVENTS.connect("win",_pop_up_win)
	EVENTS.connect("intro",_pop_up_intro)
	
	GAME.set_resource_1(10)
	GAME.set_resource_2(5)
	GAME.set_resource_3(0)
	GAME.set_quest_item("default_quest")
	GAME.set_coins(0)


## Fonction réagissant au signal changement de pièce
func _on_EVENTS_coins_changed(value: int) -> void:
	coin.set_text(str(value))
func _on_EVENTS_resource_1_changed(value: int) -> void:
	res_1.set_text(str(value))
func _on_EVENTS_resource_2_changed(value: int) -> void:
	res_2.set_text(str(value))
func _on_EVENTS_resource_3_changed(value: int) -> void:
	res_3.set_text(str(value))
func _on_EVENTS_quest_item_changed(value: String) -> void:
	q_item.set_texture(load("res://ImportFile/Items/"+value+".png"))
func _on_EVENTS_action_changed(value: int) -> void:
	action_bar.value +=value
	_is_action_filled(action_bar.value) # test si la bar d'action est positive
						# si elle est vide, le joueur meurt
func _on_EVENTS_rank_changed(value: String) -> void:
	rank_icon.set_texture(load("res://ImportFile/Ui/Characters/Rank/"+value+".png"))
	rank_label.set_text(value)
	chara_icon.set_texture(load("res://ImportFile/Ui/Characters/"+value+".png"))
	_change_coin(value)
	_change_resources(value)
	_pop_up(value);
## Fonction changeant l'icone de la pièce
func _change_coin(value: String) -> void:
	match(value):
		rankEnum.BOURGEOIS:
			coin_icon.set_texture(load("res://ImportFile/Items/coins/gold.png"))
		rankEnum.CRAFTSMAN:
			coin_icon.set_texture(load("res://ImportFile/Items/coins/silver.png"))
	pass
## Fonction changeant l'icone des ressources en fonction du rang du joueur
func _change_resources(value: String) -> void:
	match(value):
		rankEnum.BOURGEOIS:
			res_1_icon.set_texture(load("res://ImportFile/Items/resources/silk.png"))
			res_2_icon.set_texture(load("res://ImportFile/Items/resources/spices.png"))
			res_3_icon.set_texture(load("res://ImportFile/Items/resources/glass.png"))
		rankEnum.CRAFTSMAN:
			res_1_icon.set_texture(load("res://ImportFile/Items/resources/meat.png"))
			res_2_icon.set_texture(load("res://ImportFile/Items/resources/ropes.png"))
			res_3_icon.set_texture(load("res://ImportFile/Items/resources/linen.png"))
## Fonction qui instantie la popup
func _pop_up(value: String) -> void:
	var popup_path = preload("res://scene/UserUi/popup.tscn")
	var instance = popup_path.instantiate()
	add_child(instance)
	instance.set_label(value)
func _pop_up_death(rank: String,cause: String) -> void:
	var popup_path = preload("res://scene/UserUi/DeathPopup.tscn")
	var instance = popup_path.instantiate()
	add_child(instance)
	instance.set_label(rank,cause)
func _pop_up_win()  -> void:
	var popup_path = preload("res://scene/UserUi/EndScreen.tscn")
	var instance = popup_path.instantiate()
	add_child(instance)
func _pop_up_intro()  -> void:
	var popup_path = preload("res://scene/UserUi/Intro.tscn")
	var instance = popup_path.instantiate()
	add_child(instance)
	
func _is_action_filled(value: int) -> void:
	if value ==0 :
		EVENTS.emit_signal("death",str(EVENTS.emit_signal("get_rank")),"d'épuisement")
