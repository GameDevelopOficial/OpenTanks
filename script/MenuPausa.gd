extends Control

var tanques : Array
var rondas : int
var rondasGanar: int


func cargarDatos():
	$margen/ColorRect/cont/Hbox/progre/rondas.text = str(rondas) + " / " + str(rondasGanar)
	var i = 0
	while i < tanques.size():
		get_node("margen/ColorRect/cont/Hbox/nombre/j" + str(i+1)).modulate = tanques[i].obtenerColorTexto() 

		get_node('margen/ColorRect/cont/Hbox/progre/j' + str(i+1)).text = str(tanques[i].ganados)
		i += 1


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Escenas/Interfaz.tscn")


func _on_seguir_pressed() -> void:
	get_tree().paused = false
	visible = false
