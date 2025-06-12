extends Area2D

@onready var destination: Area2D = $"."
func _ready() -> void:
	destination.connect("body_entered", Callable(self, "_on_area_entered"))
	destination.connect("body_exited", Callable(self, "_on_area_exited"))
var player_count := 0
func _on_area_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_count += 1
		if player_count == 2:
			get_tree().change_scene_to_file("res://UI/win.tscn")

func _on_area_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_count -= 1
