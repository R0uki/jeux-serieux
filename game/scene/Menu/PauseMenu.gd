extends CanvasLayer

@onready var player = $%Player

func _ready():
	$VBoxContainer/Continu.grab_focus()


func _on_continu_pressed():
	self.visible = false
	player.state_machine.set_state("Idle")


func _on_quit_pressed():
	get_tree().quit()
