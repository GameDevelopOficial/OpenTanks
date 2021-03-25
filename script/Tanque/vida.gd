extends Node

signal muerto

export (float) var ComienzoVida = 100.0
export (Color) var vidaMaxima = Color.blue
export (Color) var vidaMinima = Color.red

onready var barraVida = $Grafica/slider # get_parent().get_node("area_slider/Grafica/slider")
#onready var tween: Tween = $Tween

var explosion = preload("res://particulas/Explosion.tscn")
var vidaActual : float
var Muerto: bool

func _ready() -> void:
	iniciar()

func iniciar() -> void:
	vidaActual = ComienzoVida
	Muerto = false
	establecerVidaUI()

func RecibirDanio (cantidad : float):
	vidaActual -= cantidad
	establecerVidaUI()
	if vidaActual <= 0 && !Muerto:
		Matarme()

func establecerVidaUI():
	barraVida.value = vidaActual
	barraVida.tint_progress = lerpColor(vidaMinima, vidaMaxima, vidaActual / ComienzoVida)

#	tween.interpolate_property(barraVida, "value", vidaActual, vidaActual, 2, Tween.TRANS_CIRC, Tween.EASE_OUT)

func Matarme():
	Muerto = true
	var e = explosion.instance()
	e.global_transform = get_parent().global_transform
	e.get_node("anim").play("explosion")
	get_parent().visible = false
	get_parent().emit_signal("muerte")

func lerpColor(color1: Color, color2: Color, peso: float):
	return Color(lerp(color1.r, color2.r, peso), lerp(color1.g, color2.g, peso), lerp(color1.b, color2.b, peso))








