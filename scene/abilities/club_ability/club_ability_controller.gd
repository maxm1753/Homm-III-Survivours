extends Node

@export var club_ability_scene: PackedScene

var damage = 10

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var front_layer = get_tree().get_first_node_in_group("front_layer") as Node2D
	
	var club_ability_instance = club_ability_scene.instantiate() as ClubAbility
	front_layer.add_child(club_ability_instance)
	
	club_ability_instance.global_position = player.global_position
	club_ability_instance.hit_box_component.damage = damage
