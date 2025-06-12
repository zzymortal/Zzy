extends Node2D

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var area_2d: Area2D = $TileMapLayer/Area2D

# 存储进入区域的玩家数量
var player_count := 0

func _ready() -> void:
	var used := tile_map_layer.get_used_rect().grow(-1)
	var tile_size := tile_map_layer.tile_set.tile_size

	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_right = used.end.x * tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	camera_2d.reset_smoothing()

	area_2d.connect("body_entered", Callable(self, "_on_area_entered"))
	area_2d.connect("body_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_count += 1
		if player_count == 2:
			# 两个玩家都进入时，切换场景
			get_tree().change_scene_to_file("res://UI/win.tscn")

func _on_area_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_count -= 1
