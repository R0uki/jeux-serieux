extends VBoxContainer

var quest_id
var quest

var answer_1 : Callable = func() :
	pass

var answer_2 : Callable = func() :
	pass

var answer_3 : Callable = func() :
	pass

func _ready():
	EVENTS.connect("get_quest_id", _on_get_quest_id)
	$Answer1.grab_focus()


func _on_get_quest_id(dialogue_quest_id) :
	quest_id = dialogue_quest_id
	EVENTS.emit_signal("get_quest", self)
	EVENTS.emit_signal("get_box_answer", self)



func _on_answer_1_pressed():
	quest._on_answer_1.call()
	get_parent().queue_free()
	

func _on_answer_2_pressed():
	quest._on_answer_2.call()
	get_parent().queue_free()


func _on_answer_3_pressed():
	quest._on_answer_3.call()
	get_parent().queue_free()
