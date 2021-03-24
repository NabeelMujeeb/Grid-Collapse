extends Control

func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_head_bg_less_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			OS.shell_open("https://itch.io/jam/godot-wild-jam-31")


func _on_ProgrammerIdiot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			OS.shell_open("https://twitter.com/ProgrammerIdiot")


func _on_2021_Twitter_logo__blue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			OS.shell_open("https://twitter.com/ProgrammerIdiot")


func _on_GitHubMark120pxplus_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			OS.shell_open("https://github.com/NabeelMujeeb/Grid-Collapse")
