extends Viewport

export (int) var numeroJugador = 1
export (AudioStream) var ChargingClip
export (AudioStream) var FireClip
export (float) var FuerzaMinimaLanzar = 15
export (float) var FuerzaMaximaLanzar = 30
export (float) var TiempoMaxCarga = 0.75

onready var posSalida = get_parent().get_node("posSalida")
onready var slider = $grafica/fuerza
onready var audiodisparo = get_parent().get_node("sonido_disparo")

var bala = preload("res://prefabs/bala.tscn")
var botonFuego: String
var fuerzaActualLanzar: float
var velocidadCargar: float
var fuego: bool

func iniciar() -> void:
	fuerzaActualLanzar = FuerzaMinimaLanzar
	slider.max_value = FuerzaMaximaLanzar
	slider.min_value = FuerzaMinimaLanzar
	slider.value = FuerzaMinimaLanzar

func _ready() -> void:
#	numeroJugador = get_parent().m_NumeroJugador
	botonFuego = "Fuego" + str(numeroJugador)
	velocidadCargar = (FuerzaMaximaLanzar - FuerzaMinimaLanzar) / TiempoMaxCarga
	iniciar()

func _process(delta: float) -> void:
	slider.value = FuerzaMinimaLanzar
	if fuerzaActualLanzar >= FuerzaMaximaLanzar && !fuego:
		fuerzaActualLanzar = FuerzaMaximaLanzar
		Fuego()

	elif Input.is_action_just_pressed(botonFuego):
		fuego = false
		fuerzaActualLanzar = FuerzaMinimaLanzar
		audiodisparo.stream = ChargingClip
		audiodisparo.play()

	elif Input.is_action_pressed(botonFuego) && !fuego:
		fuerzaActualLanzar += velocidadCargar * delta
		slider.value = fuerzaActualLanzar

	elif Input.is_action_just_released(botonFuego) && !fuego:
		Fuego()

func Fuego():
	fuego = true
	var projectil = bala.instance()
	var escenaRaiz = get_tree().root.get_children()[1]

	projectil.mascara = get_parent().collision_mask
 
	escenaRaiz.add_child(projectil)
	projectil.global_transform = posSalida.global_transform
	projectil.apply_impulse(Vector3.ZERO, projectil.global_transform.basis.z * fuerzaActualLanzar)
