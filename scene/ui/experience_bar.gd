extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0
	experience_manager.experience_update.connect(on_experience_updated)
	
func on_experience_updated(current_experience:float, target_experience:float):
	var current_value = current_experience / target_experience
	progress_bar.max_value = target_experience
	progress_bar.value = current_experience
	
