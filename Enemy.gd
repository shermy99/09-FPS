extends KinematicBody

# stats
var health : int = 5
var moveSpeed : float = 2.0

# attacking
var damage : int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0

var scoreToGive : int = 10

# components
onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = get_node("Timer")

func _ready():
	
	# setup the timer
	timer.set_wait_time(attackRate)
	timer.start()

func _physics_process(delta):
	
	# calculate the direction to the player
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	
	# move the enemy towards the player
	if translation.distance_to(player.translation) > attackDist:
		move_and_slide(dir * moveSpeed, Vector3.UP)

# called when we get damaged by the player
func take_damage (damage):
	
	health -= damage
	
	if health <= 0:
		die()

# called when our health reaches 0
func die ():
	
	player.add_score(scoreToGive)
	queue_free()

# deals damage to the player
func attack ():
	
	player.take_damage(damage)

# called every 'attackRate' seconds
func _on_Timer_timeout():
	
	# if we're at the right distance, attack the player
	if translation.distance_to(player.translation) <= attackDist:
		attack()
