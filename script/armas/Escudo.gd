extends "Armas.gd"

var vida : int = 100
var tiempo : float = 60

func _inicio() -> void:
	set_process(false)
	$anim.play("activar")
	$anim.connect("animation_finished", self, "on_termino_animacion")
	$radio.collision_layer = obtener_layer()

func _process(delta: float) -> void:
	tiempo -= 1 * delta
	if tiempo <= 0:
		_fin()

func sacarVida (cant):
	vida -= cant
	if vida <= 0:
		_fin()

func _fin():
	$anim.play("desactivar")

func on_termino_animacion (animacion):
	if animacion == "desactivar":
		queue_free()

	else:
		nodoJugador.eliminarArma()
