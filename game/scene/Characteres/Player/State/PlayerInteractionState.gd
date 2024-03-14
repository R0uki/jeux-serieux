extends State
class_name InteractionState

#function qui vas gerer l'interaction à lancer
func enter_state() -> void:
	if InteractionManager.interactive_area.size() > 0 :
		
		var index = 0
		
		#can_interact passe a false, pour ne pas pouvoir interargir avec autre chose
		InteractionManager.can_interact = false
		
		#si il y a plus de 2 zone interactible, on recupere la zone la plus proche
		#sinon on prend la premiere dans la liste (index = 0)
		if InteractionManager.interactive_area.size() > 1 :
			index = InteractionManager.get_closest_area.call()
		
		InteractionManager.label.hide()
		#lance la fonction : interaction, de l'interactive_area la plus proche
		#et attend ca fin
		await InteractionManager.interactive_area[index].interaction.call()
		
		InteractionManager.can_interact = true
	owner.animated_sprite.play("Idle"+ owner._find_dir_name(owner.facing_direction))
