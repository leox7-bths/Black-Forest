extends Control
#
#@onready var hearts = $Hearts.get_children()
#@onready var stamina = $Stamina.get_children()
#
#@export var heart_full : Texture2D
#@export var heart_empty : Texture2D
#
#@export var stamina_full : Texture2D
#@export var stamina_empty : Texture2D
#
#func _ready():
	#player.stats_changed.connect(update_ui)
	#update_ui()
#
#func update_ui():
	#update_hearts()
	#update_stamina()
#
#func update_hearts():
#
	#for i in range(hearts.size()):
		#hearts[i].texture = heart_full if i < player.hp else heart_empty
#
#func update_stamina():
#
	#for i in range(stamina.size()):
		#stamina[i].texture = stamina_full if i < player.stamina else stamina_empty
