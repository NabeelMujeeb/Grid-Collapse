extends Control



func _on_BackButton_pressed() -> void:
	if Autoload.game_active:
		self.hide()
	else:
		get_tree().change_scene("res://MainMenu.tscn")


func _on_VideoPlayer_finished() -> void:
	$VideoPlayer.play()


func _on_VideoPlayer2_finished() -> void:
	$VideoPlayer2.play()


func _on_VideoPlayer3_finished() -> void:
	$VideoPlayer3.play()


func _on_VideoPlayer4_finished() -> void:
	$VideoPlayer4.play()


func _on_VideoPlayer5_finished() -> void:
	$VideoPlayer5.play()
