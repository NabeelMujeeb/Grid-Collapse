extends Node2D

const STEP_SIZE = 35

var left_boundary_color
var right_boundary_color
var top_boundary_color
var bottom_boundary_color

var ini_pos_left
var ini_pos_right
var ini_pos_top
var ini_pos_bottom

var shape1 = preload("res://Shape1.tscn")
var shape2 = preload("res://Shape2.tscn")
var shape3 = preload("res://Shape3.tscn")
var shape4 = preload("res://Shape4.tscn")

var bonus = preload("res://gfx/oregano.png")

var purple = preload("res://shaders/purple.tres")
var blue = preload("res://shaders/blue.tres")
var red = preload("res://shaders/red.tres")
var yellow = preload("res://shaders/yellow.tres")

var speed = 19

var color
var streak_counter = 0
var rotating = false
var trauma = 0
var playing = true
var shake
var angle
var max_angle = 30
var offsetx
var max_offset = 40
var offsety
var defaultcamera_pos
var score: int = 0
var arrow_type: String
var arrow_exists: bool
var color_combination
var initial_rotation
var rad_rotation
var unit_vector 
var shape_selected
var random = RandomNumberGenerator.new()

func _ready() -> void:
	Autoload.game_active = true
	random.randomize()
	OS.window_position = Vector2(0,0)
	
	defaultcamera_pos = $Camera2D.position
	$ShakeCamera.position = $Camera2D.position
	
	ini_pos_left = $WallsContainer/LeftBoundary.position
	ini_pos_right = $WallsContainer/RightBoundary.position
	ini_pos_top = $WallsContainer/TopBoundary.position
	ini_pos_bottom = $WallsContainer/BottomBoundary.position
	
func _process(delta: float) -> void:
	screen_shake()

func _input(event: InputEvent) -> void:

	if Input.is_action_pressed("move_left") and arrow_exists:
		$TurnSound.play()
		initial_rotation -= 90
		shape_selected.rotation = deg2rad(initial_rotation)
		rad_rotation = deg2rad(initial_rotation - 90)
		unit_vector = Vector2(cos(rad_rotation),sin(rad_rotation))
	if Input.is_action_pressed("move_right") and arrow_exists:
		$TurnSound.play()
		initial_rotation += 90
		shape_selected.rotation = deg2rad(initial_rotation)
		rad_rotation = deg2rad(initial_rotation - 90)
		unit_vector = Vector2(cos(rad_rotation),sin(rad_rotation))


func shape_selection():
	shape_selected = random.randi_range(0,3)
	color = shape_selected
	initial_rotation = random.randi_range(0,359)
	rad_rotation = deg2rad(initial_rotation - 90)
	unit_vector = Vector2(cos(rad_rotation),sin(rad_rotation))
	
	match shape_selected:
		0:
			arrow_type = "white"
		1:
			arrow_type = "blue"
		2:
			arrow_type = "red"
		3:
			arrow_type = "yellow"
	
	match shape_selected:
		0:
			shape_selected = shape1
		1:
			shape_selected = shape2
		2:
			shape_selected = shape3
		3:
			shape_selected = shape4
	
	shape_selected = shape_selected.instance()
	shape_selected.scale *= Vector2(0.8,0.3)
	shape_selected.position = $EmanatePosition.position
	shape_selected.rotation = deg2rad(initial_rotation)
	self.add_child(shape_selected)
	color_draw()
	arrow_exists = true
	$ExpansionTimer.start()
	
func move(unit_vector):
	shape_selected.position += speed * unit_vector

func _on_ExpansionTimer_timeout() -> void:
	move(unit_vector)

func _on_SpawnTimer_timeout() -> void:
	$SpawnSound.play()
	shape_selection()
	tween_shaders()
	
func tween_shaders():
	match color:
		0:
			$TweenColor.interpolate_property($Circle.material,"shader_param/brighter_color",Color("ffffff"),Color("#c98aff"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/middle_color",Color("ffffff"),Color("#9622f6"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/darker_color",Color("ffffff"),Color("#5f0fa1"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
		1:
			$TweenColor.interpolate_property($Circle.material,"shader_param/brighter_color",Color("ffffff"),Color("#4372ff"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/middle_color",Color("ffffff"),Color("#003eff"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/darker_color",Color("ffffff"),Color("#113aa8"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
		2:
			$TweenColor.interpolate_property($Circle.material,"shader_param/brighter_color",Color("ffffff"),Color("#ff595d"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/middle_color",Color("ffffff"),Color("#d81015"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/darker_color",Color("ffffff"),Color("#930103"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
		3:
			$TweenColor.interpolate_property($Circle.material,"shader_param/brighter_color",Color("ffffff"),Color("#fff55d"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/middle_color",Color("ffffff"),Color("#efe000"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$TweenColor.interpolate_property($Circle.material,"shader_param/darker_color",Color("ffffff"),Color("#c7bc15"),0.45,Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	$TweenColor.start()

func _on_LeftBoundary_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		if color_combination[0] == arrow_type:
			score()
		else:
			$WallsContainer/LeftBoundary.position += Vector2(1,0) * STEP_SIZE
			$MistakeSound.play()
			streak_counter = 0
			trauma()
		remove_arrow()
		$ExpansionTimer.stop()
		$SpawnTimer.start()

func _on_RightBoundary_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		if color_combination[1] == arrow_type:
			score()
		else:
			$WallsContainer/RightBoundary.position += Vector2(-1,0) * STEP_SIZE
			$MistakeSound.play()
			streak_counter = 0
			trauma()
		remove_arrow()
		$ExpansionTimer.stop()
		$SpawnTimer.start()
		
func _on_TopBoundary_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		if color_combination[2] == arrow_type:
			score()
		else:
			$WallsContainer/TopBoundary.position += Vector2(0,1) * STEP_SIZE
			$MistakeSound.play()
			streak_counter = 0
			trauma()
		remove_arrow()
		$ExpansionTimer.stop()
		$SpawnTimer.start()
		
func _on_BottomBoundary_area_entered(area: Area2D) -> void:
	if area.is_in_group("arrow"):
		if color_combination[3] == arrow_type:
			score()
		else:
			$WallsContainer/BottomBoundary.position += Vector2(0,-1) * STEP_SIZE
			$MistakeSound.play()
			streak_counter = 0
			trauma()

		remove_arrow()
		$ExpansionTimer.stop()
		$SpawnTimer.start()
		
func remove_arrow():
	shape_selected.queue_free() 
	arrow_exists = false
		
func score():
	
	score += 10
	
	streak_counter += 1
	if (streak_counter % 3) == 0:
		$BigSuccessSound.play()
		$WallsContainer/LeftBoundary.position = ini_pos_left
		$WallsContainer/RightBoundary.position = ini_pos_right
		$WallsContainer/TopBoundary.position = ini_pos_top
		$WallsContainer/BottomBoundary.position = ini_pos_bottom
		score += 10
		$AnimationPlayer.play("streak")
	else:
		$AnimationPlayer.play("score")
		$SuccessSound.play()
	if score > Autoload.highscore:
		Autoload.highscore = score
	if score > 300:
		$TextureRect.texture = bonus
	$Score/HBoxContainer/Score/Label.text = str(score)
	$Score/HBoxContainer/HighScore/Value.text = str(Autoload.highscore)

func pause():
	pass

func color_draw():
	var combination = random.randi_range(1,24)
	match combination:
		1:
			color_combination = ["red","white","yellow","blue"]
		2:
			color_combination = ["red","white","blue","yellow"]
		3:
			color_combination = ["red","blue","yellow","white"]
		4:
			color_combination = ["red","yellow","white","blue"]
		5:
			color_combination = ["red","blue","white","yellow"]
		6:
			color_combination = ["red","yellow","blue","white"]
		7:
			color_combination = ["white","red","yellow","blue"]
		8:
			color_combination = ["white","blue","red","yellow"]
		9:
			color_combination = ["white","blue","yellow","red"]
		10:
			color_combination = ["white","yellow","red","blue"]
		11:
			color_combination = ["white","red","blue","yellow"]
		12:
			color_combination = ["white","yellow","blue","red"]
		13:
			color_combination = ["blue","red","yellow","white"]
		14:
			color_combination = ["blue","white","red","yellow"]
		15:
			color_combination = ["blue","white","yellow","red"]
		16:
			color_combination = ["blue","yellow","red","white"]
		17:
			color_combination = ["blue","red","white","yellow"]
		18:
			color_combination = ["blue","yellow","white","red"]
		19:
			color_combination = ["yellow","white","red","blue"]
		20:
			color_combination = ["yellow","white","blue","red"]
		21:
			color_combination = ["yellow","blue","red","white"]
		22:
			color_combination = ["yellow","red","white","blue"]
		23:
			color_combination = ["yellow","blue","white","red"]
		24:
			color_combination = ["yellow","red","blue","white"]

	match color_combination[0]:
		"white":
			$WallsContainer/LeftBoundary/ColorRect.material = purple
		"blue":
			$WallsContainer/LeftBoundary/ColorRect.material = blue
		"red":
			$WallsContainer/LeftBoundary/ColorRect.material = red
		"yellow":
			$WallsContainer/LeftBoundary/ColorRect.material = yellow
	
	left_boundary_color = color_combination[0]

	match color_combination[1]:
		"white":
			$WallsContainer/RightBoundary/ColorRect.material = purple
		"blue":
			$WallsContainer/RightBoundary/ColorRect.material = blue
		"red":
			$WallsContainer/RightBoundary/ColorRect.material = red
		"yellow":
			$WallsContainer/RightBoundary/ColorRect.material = yellow

	right_boundary_color = color_combination[1]

	match color_combination[2]:
		"white":
			$WallsContainer/TopBoundary/ColorRect.material = purple
		"blue":
			$WallsContainer/TopBoundary/ColorRect.material = blue
		"red":
			$WallsContainer/TopBoundary/ColorRect.material = red
		"yellow":
			$WallsContainer/TopBoundary/ColorRect.material = yellow
	
	top_boundary_color = color_combination[2]

	match color_combination[3]:
		"white":
			$WallsContainer/BottomBoundary/ColorRect.material = purple
		"blue":
			$WallsContainer/BottomBoundary/ColorRect.material = blue
		"red":
			$WallsContainer/BottomBoundary/ColorRect.material = red
		"yellow":
			$WallsContainer/BottomBoundary/ColorRect.material = yellow

	bottom_boundary_color = color_combination[3]


func _on_Area2D_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("game_over")
	#game_over()

func game_over():
	$GameOver.show()


func _on_LeftTouchScreenButton_pressed() -> void:
	if arrow_exists:
		$TurnSound.play()
		initial_rotation -= 90
		shape_selected.rotation = deg2rad(initial_rotation)
		rad_rotation = deg2rad(initial_rotation - 90)
		unit_vector = Vector2(cos(rad_rotation),sin(rad_rotation))
	else:
		pass

func _on_RightTouchScreenButton_pressed() -> void:
	if arrow_exists:
		$TurnSound.play()
		initial_rotation += 90
		shape_selected.rotation = deg2rad(initial_rotation)
		rad_rotation = deg2rad(initial_rotation - 90)
		unit_vector = Vector2(cos(rad_rotation),sin(rad_rotation))
	else:
		pass

func _on_RetryButton_pressed() -> void:
	playing = true
	$GameOver.hide()
	score = 0
	$Score/HBoxContainer/Score/Label.text = str(score)
	$SpawnTimer.start()
	$RotationTimer.start()
	$WallsContainer.rotation_degrees = 0
	$WallsContainer/LeftBoundary.position = ini_pos_left
	$WallsContainer/RightBoundary.position = ini_pos_right
	$WallsContainer/TopBoundary.position = ini_pos_top
	$WallsContainer/BottomBoundary.position = ini_pos_bottom
	trauma = 0
	$Circle.modulate.a = 1.0
	$Circle.scale = Vector2(0.2,0.2)
	$Circle.material.set_shader_param("brighter_color",Color("fdf4ff"))
	$Circle.material.set_shader_param("middle_color", Color("c5c5c5"))
	$Circle.material.set_shader_param("darker_color", Color("858281"))
	
func random_rotation():
	rotating = true
	var time = random.randi_range(1,5)
	var rot_dir = random.randi_range(1,2)
	match rot_dir:
		1:
			rot_dir = 1
		2:
			rot_dir = -1
	$Tween.interpolate_property($WallsContainer,"rotation_degrees",$WallsContainer.rotation_degrees * rot_dir,$WallsContainer.rotation_degrees + 90 * rot_dir,time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	
func screen_shake():
	if trauma > 0.0 and playing:
		$ShakeCamera.current = true
		trauma -= 0.03
		shake = trauma*trauma
		angle = max_angle * shake * rand_range(-1,1)
		offsetx = max_offset * shake * rand_range(-1,1)
		offsety = max_offset * shake * rand_range(-1,1)
		$ShakeCamera.rotation_degrees = angle
		$ShakeCamera.position = $Camera2D.position + Vector2(offsetx, offsety)
	else:
		$Camera2D.current = true
		$Camera2D.position = defaultcamera_pos
	
func _on_RotationTimer_timeout() -> void:
	if !rotating:
		random_rotation()

func _on_Tween_tween_all_completed() -> void:
	rotating = false

func trauma():
	if trauma < 1:
		trauma += 2

func _on_MenuButton_pressed() -> void:
	if $PauseParent/PauseMenu.is_visible():
		$PauseParent/PauseMenu.hide()
		get_tree().paused = false
	else:
		$PauseParent/PauseMenu.show()
		get_tree().paused = true
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "game_over":
		game_over()

func animfunc():
	$RotationTimer.stop()
	$SpawnTimer.stop()
	$GameOverSound.play()

func _on_InstructionsButton_pressed() -> void:
	$Tutorial.show()


func _on_SettingsButton_pressed() -> void:
	$Settings.show()


func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_TweenColor_tween_all_completed() -> void:
	$Circle.material.set_shader_param("brighter_color",Color("fdf4ff"))
	$Circle.material.set_shader_param("middle_color", Color("c5c5c5"))
	$Circle.material.set_shader_param("darker_color", Color("858281"))


func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_ResumeButton_pressed() -> void:
	pass # Replace with function body.
