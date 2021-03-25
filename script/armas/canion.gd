extends "Armas.gd"

var tiempo = 0.2
var conteo = 0

onready var rayo = $RayCast

func _inicio() -> void:
	set_process(false)
	municionesEnArma = 100
	botonDisparo = "Fuego" + str(numJugador)
	Danio = 1
	$RayCast.collision_mask = mask

func _process(delta: float) -> void:
	conteo += 1 * delta
	if Input.is_action_pressed(botonDisparo) && conteo >= tiempo:
		conteo = 0
		Fuego()

func Fuego():
	$sonido.play()
	$chispas.emitting = true
	municionesEnArma -= 1
	rayo.force_raycast_update()
	if rayo.is_colliding():
		var obj = rayo.get_collider()
		if obj.has_method("sacarVida"):
			obj.sacarVida(Danio)

	if municionesEnArma <= 0:
		nodoJugador.eliminarArma(self)
