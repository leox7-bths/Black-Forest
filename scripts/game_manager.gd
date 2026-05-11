class_name GameManager
extends Node2D

enum Phase { DAY, NIGHT }

var phase = Phase.DAY
var player_actions := {}

@onready var tilemap = $"../TileMapLayer"
@onready var planet = $Time

signal day_started
signal night_started

func _ready():

	add_to_group("game_manager")

	start_day()

func register_action(id: int, target: Vector2i):

	player_actions[id] = target

	var total_players = multiplayer.get_peers().size() + 1

	# wait until everybody acted
	if player_actions.size() < total_players:
		return

	resolve_turn()

func resolve_turn():

	# move everyone at once
	for p in get_tree().get_nodes_in_group("player"):

		if player_actions.has(p.name.to_int()):

			p.queued_cell = player_actions[p.name.to_int()]

	# clear preview tiles
	clear_preview_tiles()

	# execute all moves
	for p in get_tree().get_nodes_in_group("player"):

		p.execute_move()

	player_actions.clear()

	change_time()

func clear_preview_tiles():

	for c in tilemap.get_used_cells():

		if tilemap.get_cell_atlas_coords(c) == Vector2i(20, 1):
			tilemap.set_cell(c, 1, Vector2i(6, 0))

func change_time():

	if phase == Phase.DAY:
		start_night()
	else:
		start_day()

func start_day():

	phase = Phase.DAY

	planet.frame = 1

	day_started.emit()

func start_night():

	phase = Phase.NIGHT

	planet.frame = 0

	night_started.emit()
