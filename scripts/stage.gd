extends TileMapLayer

var radius := 10
var local_player: Node2D
var fog_targets: Array[Vector2i] = []

func _ready():
	generate_board()
	set_process(true)

func _process(_delta):
	if local_player == null:
		local_player = find_local_player()
		return
	if !is_instance_valid(local_player):
		local_player = null
		return
	update_fog()

func find_local_player():
	for p in get_tree().get_nodes_in_group("player"):
		if p.is_multiplayer_authority():
			return p
	return null

func update_fog():
	var player_cell: Vector2i = local_to_map(
		to_local(local_player.global_position)
	)
	for c in fog_targets:
		if c == player_cell:
			continue
		var d = c - player_cell
		if abs(d.x) <= 1 and abs(d.y) <= 1:
			set_cell(c, 1, Vector2i(6, 0))
		else:
			set_cell(c, 1, Vector2i(0, 14))

func generate_board():
	var glow_manager = get_parent().get_node("GlowManager")
	var outside_tiles = [
		Vector2i(13, 1), Vector2i(13, 2), Vector2i(13, 3), Vector2i(13, 4), Vector2i(13, 5),
		Vector2i(14, 1), Vector2i(14, 2), Vector2i(14, 3), Vector2i(14, 4), Vector2i(14, 5),

		Vector2i(16, 3), Vector2i(16, 4), Vector2i(16, 5), Vector2i(16, 6),
		Vector2i(17, 3), Vector2i(17, 4), Vector2i(17, 5), Vector2i(17, 6),

		Vector2i(18, 3), Vector2i(18, 4), Vector2i(18, 5), Vector2i(18, 6),
		Vector2i(18, 7), Vector2i(18, 8),

		Vector2i(19, 3), Vector2i(19, 4), Vector2i(19, 5),
		Vector2i(19, 6), Vector2i(19, 7), Vector2i(19, 8),

		Vector2i(20, 1), Vector2i(20, 2), Vector2i(20, 3), Vector2i(20, 4),
		Vector2i(20, 5), Vector2i(20, 6), Vector2i(20, 7),

		Vector2i(10, 8), Vector2i(11, 8), Vector2i(12, 8),
		Vector2i(11, 9), Vector2i(12, 9), Vector2i(13, 9), Vector2i(13, 10)
	]
	fog_targets.clear()
	for x in range(-radius - 20, radius + 21):
		for y in range(-radius - 20, radius + 21):
			var pos := Vector2i(x, y)
			if Vector2(x, y).length() <= radius:
				set_cell(pos, 1, Vector2i(6, 0))
				fog_targets.append(pos)
			else:
				if randi() % 100 < 8:
					var random_tile = outside_tiles.pick_random()
					set_cell(pos, 0, random_tile)
					if random_tile in glow_manager.glow_tiles:
						glow_manager.glow_cells[pos] = random_tile
