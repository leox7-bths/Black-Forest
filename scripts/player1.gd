extends Area2D

var stamina := 100
var hp := 5
var move_cost := 2
var can_act := true

var animation_speed := 5.0
var moving := false

var current_cell: Vector2i

@onready var ray = $RayCast2D
@onready var tilemap = get_parent().get_node("TileMapLayer")

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	add_to_group("player")
	set_process(true)
	random_spawn()

func _unhandled_input(event):

	if !is_multiplayer_authority():
		return

	if moving:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		var mouse_pos = get_global_mouse_position()
		var target_cell = tilemap.local_to_map(tilemap.to_local(mouse_pos))

		var diff = target_cell - current_cell

		if abs(diff.x) + abs(diff.y) != 1:
			return

		move_to_cell(target_cell)

func move_to_cell(target_cell: Vector2i):

	if stamina < move_cost:
		return

	var dir = target_cell - current_cell

	ray.target_position = Vector2(dir) * tilemap.tile_set.tile_size.x
	ray.force_raycast_update()

	if ray.is_colliding():
		return

	current_cell = target_cell
	stamina -= move_cost

	tilemap.set_cell(target_cell, 0, Vector2i(20, 1))


	var target_position = cell_to_world(current_cell)

	moving = true

	var tween = create_tween()
	tween.tween_property(
		self,
		"global_position",
		target_position,
		1.0 / animation_speed
	).set_trans(Tween.TRANS_SINE)

	send_position.rpc(current_cell)

	await tween.finished
	moving = false

func random_spawn():
	var used_cells = tilemap.get_used_cells()

	if used_cells.is_empty():
		return

	current_cell = used_cells.pick_random()
	global_position = cell_to_world(current_cell)

func cell_to_world(cell: Vector2i) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(cell))

@rpc("any_peer", "call_remote", "reliable")
func send_position(cell: Vector2i):

	if is_multiplayer_authority():
		return

	current_cell = cell
	global_position = cell_to_world(current_cell)
