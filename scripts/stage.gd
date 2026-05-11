extends TileMapLayer

var radius := 10
var local_player: Node2D

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

	for c in get_used_cells():

		var d: Vector2i = c - player_cell

		if abs(d.x) <= 1 and abs(d.y) <= 1:
			set_cell(c, 1, Vector2i(6, 0))
		else:
			set_cell(c, 1, Vector2i(0, 7))

func generate_board():

	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):

			var pos := Vector2i(x, y)

			if Vector2(x, y).length() <= radius:
				set_cell(pos, 1, Vector2i(6, 0))
