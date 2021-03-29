extends KinematicBody

signal muerte

export (int) var m_NumeroJugador = 1
export (float) var m_velocidad = 2
export (float) var m_VelocidadRotacion = 180
export (AudioStream) var  m_EngineIdling
export (AudioStream) var m_EngineDriving
export (float) var m_PitchRange = 0.2
 
var m_NombreEjeMovimiento : String
var m_NombreEjeRotacion : String
var nombrePausa : String

var m_ValorEntradaMovimiento : float
var m_ValorEntradaRotacion : float
var m_PitchOriginal : float

onready var m_AudioMovimiento = $sonido
onready var Camara = $cam

var potenciado: bool = false

func _enter_tree() -> void:
	m_ValorEntradaMovimiento = 0
	m_ValorEntradaRotacion = 0

func _ready() -> void:
# --------------------
	match m_NumeroJugador:
		1:
			collision_layer = 0b00010
			collision_mask = 0b11101
		2:
			collision_layer = 0b00100
			collision_mask = 0b11011
		3:
			collision_layer = 0b01000
			collision_mask = 0b10111
		4:
			collision_layer = 0b10000
			collision_mask = 0b01111
# --------------------
	randomize()

	m_NombreEjeMovimiento = "vertical" + str(m_NumeroJugador)
	m_NombreEjeRotacion = "horizontal" + str(m_NumeroJugador)
	nombrePausa = "Pausa" + str(m_NumeroJugador)
	m_PitchOriginal = m_AudioMovimiento.pitch_scale

func _process(_delta: float) -> void:
	m_ValorEntradaMovimiento = (Input.get_action_strength(m_NombreEjeMovimiento + "_arriba") - Input.get_action_strength(m_NombreEjeMovimiento + "_abajo"))
	m_ValorEntradaRotacion = (Input.get_action_strength(m_NombreEjeRotacion + "_izq") - Input.get_action_strength(m_NombreEjeRotacion + "_der"))

	if (Input.is_action_just_pressed(nombrePausa)):
		get_tree().current_scene.get_node("ControladorJuego").pausarJuego()

	manejadorAudio()

func manejadorAudio():
	if abs(m_ValorEntradaMovimiento) < 0.1 && abs(m_ValorEntradaRotacion) < 0.1:
		reproducirAudio(m_EngineIdling)

	else:
		reproducirAudio(m_EngineDriving)

func reproducirAudio (audio : AudioStream):
	if m_AudioMovimiento.stream !=  audio:
			m_AudioMovimiento.stream = audio
			m_AudioMovimiento.pitch_scale = rand_range(m_PitchOriginal - m_PitchRange, m_PitchOriginal + m_PitchRange)
			m_AudioMovimiento.play()

func _physics_process(delta: float) -> void:
	mover(delta)
	girar(delta)

func mover(delta: float):
	var movimiento = (m_ValorEntradaMovimiento * m_velocidad * delta) * global_transform.basis.z.normalized()

	if movimiento.length() > 0.1 && !$polvoDer.emitting && !$polvoIzq.emitting:
		$polvoDer.emitting = true
		$polvoIzq.emitting = true

# esto funciona bien solo que no toma en cuenta la colision
#	self.translate(movimiento)
# esto funciona pero no me convence
#	move_and_slide(movimiento, Vector3.UP)
	move_and_collide(movimiento)

func sacarVida(cant):
	$area_slider.RecibirDanio(cant)

func girar(delta: float):
	var rotar : float = m_ValorEntradaRotacion * m_VelocidadRotacion * delta
	rotate(Vector3.UP, rotar)

func equiparArma(arma):
	$disparo.set_process(false)
	arma.numJugador = m_NumeroJugador
	arma.mask = collision_mask
	arma.nodoJugador = self
	arma._inicio()
	arma.set_process(true)
	potenciado = true

func eliminarArma(arma = null):
	if arma != null:
		arma.queue_free()
	$disparo.set_process(true)
	potenciado = false

func poner_camara_como_current():
	Camara.current = true
