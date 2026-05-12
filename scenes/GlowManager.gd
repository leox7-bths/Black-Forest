extends Node

@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")

var glow_tiles = [
	Vector2i(16, 3), Vector2i(16, 4), Vector2i(16, 5), Vector2i(16, 6),

	Vector2i(17, 3), Vector2i(17, 4), Vector2i(17, 5), Vector2i(17, 6),

	Vector2i(18, 3), Vector2i(18, 4), Vector2i(18, 5), Vector2i(18, 6),
	Vector2i(18, 7), Vector2i(18, 8),

	Vector2i(19, 3), Vector2i(19, 4), Vector2i(19, 5),
	Vector2i(19, 6), Vector2i(19, 7), Vector2i(19, 8),

	Vector2i(20, 1), Vector2i(20, 2), Vector2i(20, 3), Vector2i(20, 4),
	Vector2i(20, 5), Vector2i(20, 6), Vector2i(20, 7)
]
var glow_cells := {}
var time := 0.0

func _process(delta):
	time += delta
	update_glow()

func update_glow():
	var wave = (sin(time * 2.0) + 1.0) * 0.5
	for i in glow_cells.keys():
		var tile = glow_cells[i]
		var offset = (i.x + i.y) % 10 / 10.0
		var visibility = wave - offset
		if visibility > 0.35:
			tilemap.set_cell(i, 0, tile)
		else:
			tilemap.set_cell(i, 0, Vector2i(-1, -1))
