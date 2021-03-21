extends Control

var step_size
var speed


func _ready() -> void:
	pass # Replace with function body.


func _on_OptionButton_item_selected(ID: int) -> void:
	if ID == 0:
		step_size = 90
		speed = 27
	if ID == 1:
		step_size = 35
		speed = 17
	if ID == 2:
		step_size = 120
		speed = 39

func _on_BackButton_pressed() -> void:
	if Autoload.game_active:
		self.hide()
	else:
		get_tree().change_scene("res://MainMenu.tscn")
