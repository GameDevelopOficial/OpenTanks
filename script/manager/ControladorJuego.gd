extends Spatial

export (PackedScene) var terreno : PackedScene

export (int) var numeroRondaParaGanar = 5
export (float) var StartDelay = 3
export (float) var finDelay = 3
export (Array, Script) var tanques: Array
export var colores : PoolColorArray
export (Array, NodePath) var posiciones

onready var musica = get_parent().get_node("musica")
onready var controlCamara = get_parent().get_node("ControlCamara")
onready var textoMensaje = get_parent().get_node("Interfaz/margen/Label")
onready var menuPausa = get_parent().get_node('Interfaz/MenuPausa')
onready var padre = get_parent()

var prefabTank = preload("res://prefabs/Tanque.tscn")
var potenciador = preload('res://prefabs/potenciador.tscn')

var numeroRonda: int 
var i = 0

var RondaGanadas
var JuegoGanado
var manejadoresTanque: Array
var dos: bool = false

func _ready() -> void:
# ----------------------------------------------
	dos = Guardar.dividida
	colores = Guardar.colores
	numeroRondaParaGanar = Guardar.numeroRonda
# ----------------------------------------------
	var cant = padre.get_node('TiempoPotenciado').get_children()
	for e in cant:
		e.connect('timeout', self, "on_termino_tiempo", [e])

	revisar_potenciadores()
	musica.play()
	crear_tiempo("comenzar", StartDelay)
	crear_tiempo("finalizar", finDelay)
	manejadoresTanque.resize(colores.size())
	InstanciarTodosLosTanques()

	if dos:
		controlCamara.desactivarCamara()
		padre.get_node('camara_dividida/jugadores/J1y2/jugador_1/V0').add_child(terreno.instance())
		padre.get_node('camara_dividida').numero_jugadores = colores.size()
		padre.get_node('camara_dividida').iniciar()

	else:
# le damos los objetivos a la camara
		PonerObjetivosCamara()
		padre.get_node('mundo').add_child(terreno.instance())

	menuPausa.tanques = manejadoresTanque
	menuPausa.rondas = numeroRonda
	menuPausa.rondasGanar = numeroRondaParaGanar
	loop()

func crear_tiempo(nombre: String, segundos: float):
	var t = Timer.new()
	t.wait_time = segundos
	t.one_shot = true
	t.name = nombre
	add_child(t)

func InstanciarTodosLosTanques():
	i = 0

	while i < colores.size():
		var nodo = Node2D.new()
		nodo.set_script(tanques[i])
		nodo.color = colores[i]
		nodo.posInicial = get_node(posiciones[i])
		nodo.tanque = prefabTank.instance()
		nodo.numeroDeJugador = i + 1
		nodo.setUp()

		if !dos:
			padre.get_node("tanques").add_child(nodo.tanque)
		else:

			if i < 2:
				padre.get_node('camara_dividida/jugadores/J1y2/jugador_' + str(i+1)).get_node("V" + str(i)).add_child(nodo.tanque)

			else:
				padre.get_node('camara_dividida/jugadores/J3y4/jugador_' + str(i+1)).get_node('V' + str(i)).add_child(nodo.tanque)

		padre.get_node("tanques").add_child(nodo.tanque)
		nodo.tanque.connect("muerte", self, "murio_un_tanque")
		manejadoresTanque[i] = nodo

		if dos:
			nodo.tanque.poner_camara_como_current()

		i += 1

func PonerObjetivosCamara(): 
	controlCamara.iniciar()

func loop() -> void:
	comenzarRonda()
	yield (get_node("comenzar"), "timeout")
	RondasJugadas()

func comenzarRonda():
	get_node("comenzar").start()
	ReiniciarTodosLosTanques()
	DeshabilitarControlTanque()
	if !dos:
		controlCamara.PonerPosicionTamanioInicial()

	numeroRonda += 1
	textoMensaje.text = "RONDA: " + str(numeroRonda)

func terminarRonda():
	DeshabilitarControlTanque()
	RondaGanadas = null
	RondaGanadas = obtenerGanadorRonda()
	if RondaGanadas != null:
		RondaGanadas.ganados += 1
	JuegoGanado = obtenerGAnadorJuego()
	var mensaje = MensajeFin()
	textoMensaje.text = mensaje
	get_node("finalizar").start()

func RondasJugadas():
	HabilitarControlTanque()
	textoMensaje.text = ""

func QuedaUnTanque() -> bool:
	var numeroDeTAnques: int = 0
	for t in manejadoresTanque:
		if t.tanque.visible:
			numeroDeTAnques += 1

	return numeroDeTAnques <= 1

func murio_un_tanque():
	if QuedaUnTanque():
		terminarRonda()
		yield(get_node("finalizar"), "timeout")
		if JuegoGanado != null:
			musica.stop()
			get_tree().change_scene("res://Escenas/Interfaz.tscn")
		else:
			loop()

func ReiniciarTodosLosTanques():
	for tanque in manejadoresTanque:
		tanque.resetear()

func HabilitarControlTanque():
	for tanque in manejadoresTanque:
		tanque.habilitar()

func DeshabilitarControlTanque():
	for tanque in manejadoresTanque:
		tanque.desabilitar()

func obtenerGanadorRonda():
	for T in manejadoresTanque:
		if T.tanque.visible:
			return T
	return null

func obtenerGAnadorJuego():
	for T in manejadoresTanque:
		if T.ganados == numeroRondaParaGanar:
			return T
	return null

func revisar_potenciadores():
	var phijos = padre.get_node('potenciadores').get_children()
	for e in phijos:
		if e.get_child_count() <= 0:
			colocar_potenciador(e)

func colocar_potenciador(lugar: Position3D):
	var p = potenciador.instance()
	lugar.add_child(p)
	p.connect('tomado', self, "objetoTomado")
	p.translation = Vector3.ZERO

func MensajeFin() -> String:
	var mensaje: String = "EMPATE!"
	if RondaGanadas != null:
		textoMensaje.modulate = RondaGanadas.obtenerColorTexto()
		mensaje = RondaGanadas.textoJugador + " GANO LA RONDA!"

	mensaje += "\n\n\n\n"
	for T in manejadoresTanque:
		mensaje += T.textoJugador + ": " + str(T.ganados) + " GANADOS\n"
	if JuegoGanado != null:
		textoMensaje.modulate = JuegoGanado.obtenerColorTexto()
		mensaje = JuegoGanado.textoJugador + " AH GANADO EL JUEGO!"

	return mensaje

func pausarJuego():
	get_tree().paused = true
	menuPausa.visible = true
	menuPausa.cargarDatos()

func objetoTomado(cual):
	padre.get_node('TiempoPotenciado').get_child(int(cual.name)).start()

func on_termino_tiempo (tiempo):
	var potenc = padre.get_node('potenciadores').get_child(int(tiempo.name))
	colocar_potenciador(potenc)
