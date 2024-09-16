extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	$Message2.show()
	$HighScoreLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_highscore(highscore):
	$HighScoreLabel.text = str(highscore)

func _on_start_button_pressed():
	$StartButton.hide()
	$Message2.hide()
	$HighScoreLabel.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()

