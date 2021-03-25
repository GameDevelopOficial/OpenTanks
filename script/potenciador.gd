extends Spatial

signal tomado

#onready var nodoJugador = preload('res://script/Tanque/MovimientoTanque.gd')

var potenciadores = {
	"metralleta" : preload("res://prefabs/canion.tscn"),
	"misil" : preload('res://prefabs/misil.tscn'),
	"lanza_cohete" : preload("res://prefabs/LanzaMisil.tscn"),
	"escudo" : preload("res://prefabs/Escudo.tscn"),
	"mina" : preload('res://prefabs/instancia_minas.tscn')
}

var potenciadorNumero = {
	1 : "metralleta",
	2 : "misil",
	3 : "lanza_cohete",
	4 : "escudo",
	5 : "mina"
}

func _ready() -> void:
	$Area.connect('body_entered', self, "on_entro_tanque")

func _process(delta: float) -> void:
	$cubo.rotation_degrees += Vector3.ONE * 15 * delta

func on_entro_tanque (tanque: Node):
	if tanque.has_method("equiparArma") && !tanque.potenciado:
		var num = potenciadorNumero[randi() % potenciadorNumero.size() + 1]
		var a = potenciadores[num].instance()
		tanque.add_child(a)
		a.translation = Vector3.ZERO
		tanque.equiparArma(a)

		emit_signal('tomado', get_parent())
		queue_free()
