extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var grace_period: Timer = $GracePeriod
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ability_manager: Node = $AbilityManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST
}

var max_speed = 125
var acceleration = 0.15
var enemies_colliding = 0
var current_direction: Direction = Direction.SOUTH

func _ready():
	health_component.died.connect(on_died)
	health_component.health_changed.connect(on_health_changed)
	Global.ability_upgrade_added.connect(on_ability_upgrade_added)
	health_update()

func _process(delta):
	var direction = movement_vector().normalized()
	handle_movement(direction, delta)
	update_animation(direction)
	check_if_damaged()

func handle_movement(direction: Vector2, delta: float):
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, acceleration)
	move_and_slide()

func movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		current_direction = get_direction(direction)
		play_walk_animation()
		update_sprite_flip()
	else:
		play_idle_animation()

func get_direction(input_vector: Vector2) -> Direction:
	var abs_x = abs(input_vector.x)
	var abs_y = abs(input_vector.y)
	
	# Определяем основное направление
	if abs_x > abs_y:
		return Direction.EAST if input_vector.x > 0 else Direction.WEST
	else:
		return Direction.SOUTH if input_vector.y > 0 else Direction.NORTH

func play_walk_animation():
	match current_direction:
		Direction.NORTH:
			animated_sprite_2d.play("walk_north")
		Direction.SOUTH:
			animated_sprite_2d.play("walk_south")
		Direction.EAST:
			animated_sprite_2d.play("walk_east")
		Direction.WEST:
			animated_sprite_2d.play("walk_east")  # Используем восточную анимацию с отражением
		Direction.NORTHEAST:
			animated_sprite_2d.play("walk_northeast")
		Direction.NORTHWEST:
			animated_sprite_2d.play("walk_northeast")  # Отражение для northwest
		Direction.SOUTHEAST:
			animated_sprite_2d.play("walk_southeast")
		Direction.SOUTHWEST:
			animated_sprite_2d.play("walk_southeast")  # Отражение для southwest

func play_idle_animation():
	match current_direction:
		Direction.NORTH:
			animated_sprite_2d.play("idle_north")
		Direction.SOUTH:
			animated_sprite_2d.play("idle_south")
		Direction.EAST:
			animated_sprite_2d.play("idle_east")
		Direction.WEST:
			animated_sprite_2d.play("idle_east")  # Используем восточную анимацию с отражением
		Direction.NORTHEAST:
			animated_sprite_2d.play("idle_northeast")
		Direction.NORTHWEST:
			animated_sprite_2d.play("idle_northeast")  # Отражение для northwest
		Direction.SOUTHEAST:
			animated_sprite_2d.play("idle_southeast")
		Direction.SOUTHWEST:
			animated_sprite_2d.play("idle_southeast")  # Отражение для southwest

func update_sprite_flip():
	match current_direction:
		Direction.WEST, Direction.NORTHWEST, Direction.SOUTHWEST:
			animated_sprite_2d.flip_h = true
		_:
			animated_sprite_2d.flip_h = false

func check_if_damaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(1)
	grace_period.start()
	
func health_update():
	progress_bar.value = health_component.get_health_value()

func _on_player_hurt_box_area_entered(area: Area2D):
	enemies_colliding += 1
	check_if_damaged()

func _on_player_hurt_box_area_exited(area: Area2D):
	enemies_colliding -= 1
	
func on_died():
	queue_free()
	
func on_health_changed():
	health_update()

func _on_grace_period_timeout():
	check_if_damaged()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not upgrade is NewAbility:
		return
		
	var new_ability = upgrade as NewAbility
	ability_manager.add_child(new_ability.new_ability_scene.instantiate())
