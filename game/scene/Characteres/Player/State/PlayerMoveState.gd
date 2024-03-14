extends State
#Class qui gere l'etat mouvement du Player
class_name CharacterMove

#function qui execute le mouvement actel du joueur
#	-calcul la velocité (vitesse)
#	-puis on execute se mouvement
func update(_delta: float) -> void:
	owner.velocity = owner.moving_direction * owner.speed
	owner.move_and_slide()
