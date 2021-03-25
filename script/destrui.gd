extends Node

func _ready() -> void:
	yield (get_node("anim"), "animation_finished")
	queue_free()
