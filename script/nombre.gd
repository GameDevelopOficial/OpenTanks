extends Viewport

var nodo: MeshInstance
var colore: Color

func _ready() -> void:
	nodo = get_parent().get_node("nombre")

func colocarNombre (nombre : String, color: Color):
	$nombreControl/centro/nombreTXT.text = nombre
	$nombreControl/centro/nombreTXT.modulate = color
	colore = color

func _process(delta: float) -> void:
	nodo.rotation_degrees.y -= 1

