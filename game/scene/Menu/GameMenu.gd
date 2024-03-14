extends Control

@onready var menu = $Menu
@onready var credit = $Credit
@onready var quest = get_node("/root/QuestsManager/Quest")

func _ready():
	$Menu/CenterContainer/VBoxContainer/Start.grab_focus()
	QuestsManager.load_all_quest()
	QuestsManager.completed_quest.clear()
	QuestsManager.quest_in_progress.clear()
	for i in range(quest.get_child_count()-1) :
		quest.get_child(i).quest_available = "true"
		quest.get_child(i).quest_finished = "false"

func _on_start_pressed():
	
	get_tree().change_scene_to_file("res://World/World.tscn")

func _on_quit_pressed():
	get_tree().quit()


func _on_credit_pressed():
	credit.visible = true
	menu.visible = false


func _on_button_pressed():
	credit.visible = false
	menu.visible = true
