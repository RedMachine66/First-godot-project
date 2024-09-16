extends Node

@export var mob_scene: PackedScene
var score
var highscore = 0
var velocity_multiplier = 1
var velocity_increase_rate = 0.05
var max_velocity_multiplier = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	highscore = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	if score > highscore:
		print(score)
		highscore = score
		print(highscore)
		$HUD.update_highscore(highscore)
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	velocity_multiplier = 1
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var base_velocity = randf_range(150.0, 250.0)
	var velocity = Vector2(base_velocity * velocity_multiplier, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	print(base_velocity)
	print(velocity)
	print(velocity_multiplier)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	velocity_multiplier = min(velocity_multiplier + velocity_increase_rate, max_velocity_multiplier)
