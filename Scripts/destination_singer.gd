extends Area2D
@onready var destination: Area2D = $"."
func _ready() -> void:
	destination.connect("body_entered", Callable(self, "_on_area_entered"))
	destination.connect("body_exited", Callable(self, "_on_area_exited"))
func _on_area_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://UI/win.tscn")
