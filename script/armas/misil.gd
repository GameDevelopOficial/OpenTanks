extends 'res://script/armas/Armas.gd'.cuerpo

export (float, 0, 50, 0.1) var velocidad = 0
export var rotar_eje : Vector3
export var eliminar: bool = true
export var fuerzaEXPL = 100

onready var efecto = preload('res://particulas/Explosion.tscn')

var accel : float = 0
var disparar: bool = false
var nuevoPadre
var tiempoVida = 10

func _inicio() -> void:
	set_process(false)
	nuevoPadre = get_tree().current_scene
	if eliminar:
		self.translation = Vector3(0.8, 1.2, 0)
		self.rotation_degrees = Vector3(0, 0, 90)
	Danio = fuerzaEXPL
	botonDisparo = "Fuego" + str(numJugador)
	colocar_mask(mask)

func _process(delta: float) -> void:
	if Input.is_action_just_released(botonDisparo) && !disparar:
		Fuego()

	if disparar:
		rotation_degrees += rotar_eje
		tiempoVida -= 1 * delta
		if tiempoVida <= 0:
			queue_free()
		var mov = (1 * accel * delta) * self.global_transform.basis.z.normalized()
		move_and_collide(mov)
		accel += 1 * velocidad * delta

func Fuego():
	$sonido.play()
	$fuegoCohete.emitting = true
	$luz.visible = true
	var posicion = self.global_transform
	
	get_parent().remove_child(self)
	nuevoPadre.add_child(self)
	global_transform = posicion
	if eliminar:
		nodoJugador.eliminarArma()
	disparar = true

func colocar_mask(mascara):
	collision_mask = mascara
	$punto.collision_mask = mascara

func _on_punto_body_entered(body: Node) -> void:
	if !disparar: return

	if body.has_method("sacarVida"):# && !body is nodoJugador:
		body.sacarVida(Danio)

	var ef = efecto.instance()
	get_tree().current_scene.add_child(ef)
	ef.global_transform = self.global_transform
	ef.get_node('anim').play('explosion')
	queue_free()


