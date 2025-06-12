extends Control
@onready var start: Button = $V/Start
@onready var v: VBoxContainer = $V

func _ready() -> void:
	start.grab_focus()
	
	for button: Button in v.get_children():
		button.mouse_entered.connect(button.grab_focus)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/choose_level.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()
