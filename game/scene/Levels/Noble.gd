extends Node2D

@onready var rank = preload("res://scene/UserUi/rankEnum.gd")
@onready var interaction_area : InteractionArea = $InteractionArea


func _ready(): 
	interaction_area.interaction = Callable(self, "_on_interaction")

func _on_interaction() -> void :
	if GAME.get_coins() >= 400 :
		EVENTS.emit_signal("win")
	interaction_area.player.state_machine.set_state("Idle")
