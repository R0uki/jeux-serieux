extends Node
#class abstraite State
#cette class est a donné à touts les noeud des states machines
class_name State


#fonction qui permet de donner un "comportement"(execute un certain code) quand on entre dans un etat
func enter_state() -> void:
	pass


#fonction qui permet de donner un "comportement"(execute un certain code) quand on sort d'un etat
func exit_state() -> void:
	pass


#fonction qui permet de mettre de la phisique à l'etat
#elle est  donc appeler dans _phisic_process de StateMachine
func update(_delta: float) -> void:
	pass
