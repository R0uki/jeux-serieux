extends Node2D

@onready var rank = preload("res://scene/UserUi/rankEnum.gd")
@onready var interaction_area : InteractionArea = $InteractionArea


func _ready(): 
	interaction_area.interaction = Callable(self, "_on_interaction")

func _on_interaction() -> void :
	if GAME.get_coins() >= 15 :
		await EVENTS.emit_signal("rank_changed", rank.CRAFTSMAN)
		var node = get_node("/root/World/Niveaux/Amboise/PlayerLimitation/PaysantLimitation")
		node.queue_free()
		node = get_node("/root/World/Niveaux/Amboise/PNJ/Guard/GuardPaysant")
		node.queue_free()
	interaction_area.player.state_machine.set_state("Idle")
