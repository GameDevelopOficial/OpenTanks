extends Node

var nunmeorJugadores: int = 0
var numeroRonda: int = 3
var colores: PoolColorArray
var nombres: PoolStringArray


func cambiarDeEscena (nuevaEscena: String):
	get_tree().change_scene(nuevaEscena)
