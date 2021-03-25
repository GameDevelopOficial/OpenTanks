extends Area

export (AudioStream) var explosion_sonido

var max_danio: int = 75
var min_danio: int = 25

var radioExplosion = 5

var encender: bool

onready var luz = $luz
onready var particula = preload('res://particulas/Explosion.tscn')

func iniciar (mascara, color: Color):
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	$imagen.set_surface_material(4, mat)

	collision_mask = mascara
	$radio.collision_mask = mascara

func _process(delta):
	if encender:
		luz.light_energy += 5 * delta

	else:
		luz.light_energy -= 5 * delta

	if luz.light_energy >= 5:
		encender = false
	elif luz.light_energy <= 1:
		encender = true


func _on_mina_body_entered(body):
	var colision = SphereShape.new()
	var par = particula.instance()

	colision.radius = radioExplosion
	$radio/col.shape = colision

	par.global_transform = self.global_transform
	get_tree().current_scene.add_child(par)
	par.get_node('anim').play('explosion')


func _on_radio_body_entered(body):
	if body.has_node("area_slider"):
		var danio = calcular_danio(body.translation)
		body.get_node("area_slider").RecibirDanio(danio)

	queue_free()

func calcular_danio(posicionObjetivo: Vector3) -> float:
	var exposionAObjetivo: Vector3 = posicionObjetivo - translation
	var distancia: float = exposionAObjetivo.length()
	var distanciaRealtiva = (radioExplosion - distancia) / radioExplosion
	var danio: float = distanciaRealtiva * max_danio

	danio = max(min_danio, danio)
	return danio







