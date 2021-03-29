extends Spatial

export (float) var DampTime = 0.2
export (float) var screenEdgeBuffer = 4
export (float) var MinSize = 13


var Target = []

onready var Camara = $Camera

var ZoomSpeed: float = 50
var MovementVel: Vector3
var DesiredPosition = Vector3.ZERO

onready var Tanques = get_parent().get_node("tanques")

var camaraActiva: bool = true

func iniciar():
	if !camaraActiva: return

	set_physics_process(Tanques.get_child_count() > 0)
	for i in Tanques.get_children():
		Target.append(i)
#	set_physics_process(true)

func _physics_process(delta: float) -> void:
	Move()
	Zoom()

func Move():
	FindAveragePosition()
	translation = (Vector3(lerp(translation.x, DesiredPosition.x, DampTime), 0, lerp(translation.z, DesiredPosition.z, DampTime)))

func Zoom():
	var requiredSize = FindRequiredSize()
	Camara.size = lerp(Camara.size, requiredSize, 0.5)

func FindAveragePosition():
	var averagePos : Vector3
	var numTarget: int

	for i in Target:
		if !i.visible:
			continue

		averagePos += i.translation

		numTarget += 1

	if numTarget > 0:
		averagePos /= numTarget

	averagePos.y = translation.y
	DesiredPosition = averagePos

func FindRequiredSize() -> float:
	var desiredLocalPos = to_local(DesiredPosition)
	var size = 0
	
	for i in Target:
		if !i.visible:
			continue

		var TargetLocalPos: Vector3 = to_local(i.translation)
		var desiredPosTarget: Vector3 = desiredLocalPos - TargetLocalPos
		size = max(size, abs(desiredPosTarget.y))
		size = max(size, abs(desiredPosTarget.x) / Camara.KEEP_HEIGHT)

	size += screenEdgeBuffer
	size = max(size, MinSize)

	return size

func PonerPosicionTamanioInicial():
	if !camaraActiva: return

	FindAveragePosition()
	translation = DesiredPosition
	Camara.set_orthogonal(FindRequiredSize(), 0.05, 100)

func desactivarCamara():
	$Camera.current = false
	camaraActiva = false
	set_physics_process(false)

