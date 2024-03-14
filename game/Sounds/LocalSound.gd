extends Node2D


@onready var ambientSound:AudioStreamPlayer2D = $LocalPlayer
## Fonction qui lance un son lorsque le joueur entre dans sa zone et que
## le son n'est pas encore joué
func _on_sound_zone_body_entered(body):
	if !ambientSound.playing :
		if body is CharacterBody2D :
			ambientSound.play()
	

## Fonction qui arrête le son lorsque le joueur entre dans sa zone
func _on_sound_zone_body_exited(body):
	if body is CharacterBody2D :
		ambientSound.stop()
