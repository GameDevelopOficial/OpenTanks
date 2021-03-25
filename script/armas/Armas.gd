extends Node
var Danio
var nodoJugador = null
var municionesEnArma: int = 1
var botonDisparo: String
var numJugador: int
var mask

class cuerpo:
	extends KinematicBody
	
	var Danio: int = 0
	var nodoJugador = null
	var botonDisparo: String
	var numJugador: int
	var mask
	var municionesEnArma: int = 1

	onready var gravedad = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")
	
	func _inicio():
		pass

func Fuego():
	pass

func _inicio():
	pass

func obtener_layer():
	return nodoJugador.collision_layer
