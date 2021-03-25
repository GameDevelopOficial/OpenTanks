extends Control

var numJugadores: int = 1
var colores: PoolColorArray
var nombres: PoolStringArray
var rondas: int

func _ready() -> void:
	$seleccionJugadores/botones/separador/agregar.connect("pressed", self, "agregarJugador")
	$seleccionJugadores/botones/separador/quitar.connect("pressed", self, "quitarJugador")
	$seleccionJugadores/botones/separador/salir.connect("pressed", self, "salir_a_menu")

	$margen/separador/jugar.connect("pressed", self, "jugar")
	$margen/separador/agregar.connect("pressed", self, "agregar")
	$margen/separador/opciones.connect("pressed", self, "opciones")
	$margen/separador/salir.connect("pressed", self, "salir")
	$opciones/boton_salir/boton.connect("pressed", self, "menu")

func agregarJugador():
	if numJugadores > 3:
		mostrarMensaje("Ha llegado al limite de jugadores")
		return

	var otro = jugadores()
	$seleccionJugadores/margen/contenedor/jugadores/jugador.add_child(otro)

func quitarJugador():
	if numJugadores <= 1: return

	get_node("seleccionJugadores/margen/contenedor/jugadores/jugador/separador_" + str(numJugadores)).queue_free()

	numJugadores -= 1

func jugadores():
	numJugadores += 1
	var otro = get_node("seleccionJugadores/margen/contenedor/jugadores/jugador/separador_1").duplicate()
	otro.name = "separador_" + str(numJugadores)
	otro.get_node("color").color = Color.black
	otro.get_node("nombre").text = "GameDevelop"

	return otro

func salir_a_menu() -> void:
	colores.resize(numJugadores)
	nombres.resize(numJugadores)
	Guardar.nunmeorJugadores = numJugadores
	var rondasPganar = int( $seleccionJugadores/margen/contenedor/rondas/r.text)
	if rondasPganar < 1:
		rondasPganar = 1
	Guardar.numeroRonda = rondasPganar
	var i = 0
	while i < numJugadores:
		var color = get_node("seleccionJugadores/margen/contenedor/jugadores/jugador/separador_" + str(i+1) + "/color").color
		var nombre = get_node("seleccionJugadores/margen/contenedor/jugadores/jugador/separador_" + str(i+1) + "/nombre").text

		colores[i] = color
		nombres[i] = nombre
		i += 1

	Guardar.colores = colores
	Guardar.nombres = nombres

	$seleccionJugadores.visible = false
	$titulo.visible = true
	$margen.visible = true
	$informacion.visible = true

func jugar():
	if numJugadores <= 1:
		mostrarMensaje("Agregue mas jugadores con el boton \"jugadores\" para poder jugar")
		return
	get_tree().change_scene("res://Escenas/campo.tscn")

func agregar():
	$titulo.visible = false
	$margen.visible = false
	$informacion.visible = false
	$seleccionJugadores.visible = true

func opciones():
	$opciones.visible = true

func menu():
	var rondas = int($opciones/op/numRonda/ronda.text)
	$opciones.visible = false

func salir():
	get_tree().quit()

func mostrarMensaje (mensaje: String):
	$error.text = mensaje
	$tiempo.start()

func _on_tiempo_timeout() -> void:
	$error.text = ""


