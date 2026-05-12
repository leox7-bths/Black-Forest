extends TileMapLayer

@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")

func _ready():
	var background_layer = tilemap.get_parent().get_node("Background")
	background_layer.z_index = -100
	for x in range(-tilemap.radius - 25, tilemap.radius + 26):
		for y in range(-tilemap.radius - 25, tilemap.radius + 26):
			var pos := Vector2i(x, y)
			background_layer.set_cell(pos, 1, Vector2i(0, 7))

func _process(delta: float) -> void:
	pass
