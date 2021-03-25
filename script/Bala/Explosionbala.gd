extends RigidBody

export (AudioStream) var sonidoExplosion
export (float) var maxDanio = 10
export (float) var FuerzaExplosion = 1000
export (float) var TiempoVida = 2
export (float) var RadioExplosion = 5

onready var explosionParticulas = preload('res://particulas/explosionBala.tscn')
var mascara

func _ready() -> void:
	collision_mask = mascara
	$radio.collision_mask = mascara
	$radio.connect("body_entered", self, "obtener_cuerpos")

func _process(delta: float) -> void:
	TiempoVida -= delta
	if TiempoVida <= 0:
		eliminar()

func _on_bala_body_entered(body: Node) -> void:
	var shape = SphereShape.new()
	shape.radius = RadioExplosion
	$radio/col.shape = shape
	

func obtener_cuerpos (cuerpo: Node):
	var par = explosionParticulas.instance()

	if cuerpo.has_node("area_slider"):
		var danio: float = calcular_danio(cuerpo.translation)

		cuerpo.get_node("area_slider").RecibirDanio(danio)
	get_tree().current_scene.add_child(par)
	par.global_transform = global_transform
	par.get_node("anim").play("unico")
	eliminar()

func calcular_danio(posicionObjetivo: Vector3) -> float:
	var exposionAObjetivo: Vector3 = posicionObjetivo - translation
	var distancia: float = exposionAObjetivo.length()
	var distanciaRealtiva = (RadioExplosion - distancia) / RadioExplosion
	var danio: float = distanciaRealtiva * maxDanio

	danio = max(0, danio)
	return danio

func eliminar():
	queue_free()
