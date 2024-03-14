extends Node

@onready var label = $Label


const base_interaction_texte = "[E] pour "


var interactive_area = []
var can_interact = false
var player


func getPlayer() -> void:
	player = get_node("../World/Niveaux/Player")


#quand le joueur rentre dans une zone d'intercation,
#cette zone et enregistrer dans un tableau d'interaction possible
func register_area(area: InteractionArea) :
	interactive_area.push_back(area)
	can_interact = true


#quand le joueur sort d'une zone d'interaction,
#cette zone est retirer du tableau d'interaction possible
func unregister_area(area : InteractionArea) : 
	var index = interactive_area.find(area)
	if index != -1 :
		interactive_area.remove_at(index)
	if interactive_area.size() < 1:
		can_interact = false


#permet de renvoyé la zone d'interaction enregistrer la plus proche
func get_closest_area() -> int:
	var distance = player.global_position.distance_to(interactive_area[0].global_position)
	var index = 0
	for i in range(1,interactive_area.size()) :
		if player.global_position.distance_to(interactive_area[i].global_position) < distance:
			distance = player.global_position.distance_to(interactive_area[i].global_position)
			index = i
	return index


#si le joueur est dans une zone d'interaction, affiche le label d'interaction
func _physics_process(_delta):
	if interactive_area.size() > 0 && can_interact:
		var index = 0
		
		#si il y a plus de 2 zone interactible, on recupere la zone la plus proche
		#sinon on prend la premiere dans la liste (index = 0)
		if InteractionManager.interactive_area.size() > 1 :
			index = get_closest_area()
		
		#donne toute les information au label d'interaction
		label.text = base_interaction_texte + interactive_area[index].interaction_name
		label.global_position = player.global_position
		label.global_position.x -= 136
		label.global_position.y -= 53
		label.show()
	else : 
		label.hide()
