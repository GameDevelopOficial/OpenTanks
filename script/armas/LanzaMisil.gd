extends "res://script/armas/Armas.gd"

var misiles : Array
var num_misiles: int = 0

func _ready() -> void:
	misiles = $misiles.get_children()

func _inicio():
	botonDisparo = "Fuego" + str(numJugador)
	Danio = 5
	num_misiles = misiles.size()
	for i in misiles:
		i.colocar_mask(mask)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(botonDisparo):
		if num_misiles <= 0:
			nodoJugador.eliminarArma(self)
			return

		misiles[num_misiles-1].nuevoPadre = get_tree().current_scene
		misiles[num_misiles-1].Fuego()
		misiles[num_misiles-1].set_process(true)
		misiles[num_misiles-1].Danio = Danio
		num_misiles -= 1
