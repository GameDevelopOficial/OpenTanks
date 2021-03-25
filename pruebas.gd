extends Node2D

export var color : Color
export var mensaje : String

func _ready() -> void:
	$Control/Label.modulate = color.to_html()
	$Control/Label.text = mensaje


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Escenas/campo.tscn")
