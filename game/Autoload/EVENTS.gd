## AUTOLOAD permettant la gestion des signaux utiliser par GAME et le quest manager
extends Node
### AUTOLOAD des événements (gestion des signaux)

# pour supprimer les warnings lié à la non utilisation des signaux
# warnings-disable


### signaux events
# SETTERS
signal set_coin(value)
signal set_res_1(value)
signal set_res_2(value)
signal set_res_3(value)
signal set_q_item(value)
signal set_action(value)
signal set_rank(value)

# GIVERS
signal coin_trans(value)
signal res_1_trans(value)
signal res_2_trans(value)
signal res_3_trans(value)
signal action_trans(value)

# GETTERS
signal get_coin()
signal get_res_1()
signal get_res_2()
signal get_res_3()
signal get_q_item()
signal get_action()
signal get_rank()

# MUTATION
signal coins_changed(value)
signal resource_1_changed(value)
signal resource_2_changed(value)
signal resource_3_changed(value)
signal quest_item_changed(value)
signal action_changed(value)
signal rank_changed(value)
signal death(rank,cause)
signal intro()
signal win()
#QUEST
signal quest_advance(quest)
signal get_quest_id(quest)
signal end_quest_indication()
signal answer_end_dialogue()
signal quit_dialogue()
signal get_quest(value)
signal get_box_answer(value)








