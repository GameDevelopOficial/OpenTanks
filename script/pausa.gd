extends CanvasLayer

var tanques : Array
var rondas : int
var rondasGanar: int


func _ready():
	$pausa/ColorRect/margen/bo/rondas.text = "Rondas: " + str(rondas) + " / " + str(rondasGanar)
	var i = 0
	while i < tanques.size():
		get_node("pausa/ColorRect/margen/bo/jugadro_" + str(i+1)).modulate = tanques[i].obtenerColorTexto()
		get_node("pausa/ColorRect/margen/bo/jugadro_" + str(i+1)).text = "Jugador " + str(i+1) + " : " + str(tanques[i].ganados) + " Ganados"

		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_seguir_pressed():
	get_tree().paused = false
	queue_free()


func _on_menu_pressed():
	get_tree().change_scene("res://Escenas/Interfaz.tscn")
