extends Control
@onready var v_2: VBoxContainer = $V2
@onready var v: VBoxContainer = $V
@onready var l_3: Button = $V/L3


func _ready() -> void:
	l_3.grab_focus()
	
	for button: Button in v.get_children():
		button.mouse_entered.connect(button.grab_focus)
		
		


func _on_l_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_l_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_2.tscn")


func _on_l_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_3.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/title_screen.tscn")


func _on_l_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_4.tscn")


func _on_l_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_5.tscn")


func _on_l_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_6.tscn")
