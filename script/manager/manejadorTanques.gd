extends Node

# este script no sera asignado a ningun nodo es solamente
# para poder establecer a los tanques, aca
# va a haber un script por cada tanque en la escena

class_name TAnkManager

var color: Color
var posInicial: Position3D
var numeroDeJugador: int
var textoJugador: String
var tanque
var ganados: int
var movimiento: KinematicBody
var disparando: Viewport

func setUp():
	tanque.get_node("Nombre").colocarNombre(Guardar.nombres[numeroDeJugador-1], color)
	movimiento = tanque
	disparando = tanque.get_node("disparo")

	movimiento.m_NumeroJugador = numeroDeJugador
	disparando.numeroJugador = numeroDeJugador
	textoJugador = "JUGADOR: " + str(numeroDeJugador)

	var colores =  tanque.get_node("Tanque").get_surface_material_count()
	while colores >= 0:
		var mat = SpatialMaterial.new()
		mat.albedo_color = color
		tanque.get_node("Tanque").set_surface_material(colores, mat)
		colores -= 1

	tanque.transform = posInicial.transform

func desabilitar():
	movimiento.set_process(false)
	movimiento.set_physics_process(false)
	disparando.set_process(false)

func habilitar():
	movimiento.set_process(true)
	movimiento.set_physics_process(true)
	disparando.set_process(true)

func resetear():
	tanque.transform = posInicial.transform

	var nodos = tanque.get_children()
	for n in nodos:
		if n.has_method("iniciar"):
			n.iniciar()
		if n.has_method("terminar"):
			n.terminar()

	tanque.visible = true

func obtenerColorTexto():
	return color.to_html()



