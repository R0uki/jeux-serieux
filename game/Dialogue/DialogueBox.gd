extends TextureRect

@onready var label = $Label
@onready var box_answer_scene = preload("res://Dialogue/BoxAnswer.tscn")

var box_answer
var nb_answer

var answer_array : Array[Button] = []

signal finished_displayed



func display_text(text : String) :
	label.text = text
	emit_signal("finished_displayed")

func display_answer(answer) :
	nb_answer = answer.size()
	
	#mise en place de la box de reponse
	box_answer = box_answer_scene.instantiate()
	self.add_child(box_answer)
	box_answer.global_position.x += 130
	box_answer.global_position.y += 134
	
	#on replie les bouton de la box par rapport au nbr de reponse possible
	for i in range(0, nb_answer) :
		answer_array.insert(i,(box_answer.get_node("Answer" + str(i+1))))
		answer_array[i].visible = true
		answer_array[i].text = answer[i]
	
	
	answer = []
