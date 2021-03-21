extends Control

func _ready() -> void:
	Autoload.game_active = false
	get_tree().paused = false

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Test.tscn")


func _on_InstructionsButton_pressed() -> void:
	get_tree().change_scene("res://Tutorial.tscn")


func _on_SettingsButton_pressed() -> void:
	get_tree().change_scene("res://Settings.tscn")


func _on_InfoButton_pressed() -> void:
	get_tree().change_scene("res://Info.tscn")
