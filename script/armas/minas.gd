extends "Armas.gd"

var mina = preload("res://prefabs/mina.tscn")
var color

func _inicio ():
	set_process(false)
	municionesEnArma = 3
	botonDisparo = "Fuego" + str(numJugador)
	color = get_parent().get_node("Nombre").colore

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(botonDisparo) && municionesEnArma > 0:
		Fuego()

func Fuego():
	municionesEnArma -= 1
	var m = mina.instance()
	m.global_transform = self.global_transform
	m.iniciar(mask, color)
	
	get_tree().current_scene.add_child(m)

	if municionesEnArma <= 0:
		nodoJugador.eliminarArma(self)
