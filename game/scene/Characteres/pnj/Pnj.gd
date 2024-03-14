extends Character

@onready var interaction_area : InteractionArea = $InteractionArea
@onready var player = get_node("/root/World/Niveaux/Player")

@export var quest_id : String = ""

@export var idle_dialogue : String = "Salut"
@export_enum("fermier","manant","guard","noble", "guard_clos", "guard_paysant", "guard_citadin", "marchant", "guilde") var type_pnj : String
@export var pnj_name : String = "Jean"


#varaible pour stocké les dialogue pour les quete 
var dialogue_quest : Array[String] = []
#variable pour stocké reponse des quete
var answer_quest : Array[String] = []

var dialogue_file_path = "res://JSON/RandomDialogue.json"
var type_dialogue_box = "PNJ_R"

var random = RandomNumberGenerator.new()
var get_random_dialogue : Dictionary = {}
var dialogue_send : Array = []



func _ready(): 
	EVENTS.connect("end_quest_indication", _on_end_quest_indication)
	$IdleLabel.text = idle_dialogue
	self.set_facing_direction(Vector2.DOWN)
	state_machine.set_state("Idle")
	interaction_area.interaction = Callable(self, "_on_interaction")

func _on_end_quest_indication() :
	$QuestIndicator.visible = false

func load_random_dialogue(type) :
	if FileAccess.file_exists(dialogue_file_path) :
		var quest_file = FileAccess.open(dialogue_file_path, FileAccess.READ)
		var parse_result = JSON.parse_string(quest_file.get_as_text())
		get_random_dialogue = parse_result[type]
	else :
		print("Le json n'existe pas")


func _on_interaction() -> void :
	if quest_id != "" && !QuestsManager.is_quest_completed(quest_id):
		if QuestsManager.is_quest_available(quest_id) :
			QuestsManager.start_quest(quest_id)
		elif QuestsManager.is_quest_in_progress(quest_id):
			QuestsManager.show_diologue(quest_id)
	else :
		dialogue_send.clear()
		load_random_dialogue(type_pnj)
		
		var index = random.randi_range(1, get_random_dialogue.size())
		dialogue_send.append(get_random_dialogue[str(index)])
		
		DialogueManager.start_dialogue(dialogue_send, type_dialogue_box)


func _on_detection_area_body_entered(body):
	if body == player :
		$IdleLabel.visible = true
		print(self.quest_id)
		if quest_id == "":
			$QuestIndicator.visible = false
		
		elif !QuestsManager.is_quest_completed(quest_id):
			$QuestIndicator.visible = true


func _on_detection_area_body_exited(body):
	if body == player :
		$IdleLabel.visible = false
		$QuestIndicator.visible = false
