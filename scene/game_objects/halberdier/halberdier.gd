extends CharacterBody2D

var max_speed = 50

@onready var health_component = $HealthComponent

func _ready():
	health_component.died.connect(on_died)

func _process(delta):
	var direction = get_direction_to_player()
	velocity = max_speed * direction
	move_and_slide()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2(0,0)

func on_died():
	queue_free()
