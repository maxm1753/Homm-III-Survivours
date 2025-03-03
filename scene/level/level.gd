extends Node

@export var end_screen_scene: PackedScene

@onready var player: CharacterBody2D = %Player
@onready var pause_menu: CanvasLayer = $PauseMenu



func _ready():
	player.health_component.died.connect(on_died)

func on_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
