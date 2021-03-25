extends Camera

export var center_offset: Vector2 = Vector2(0, 5.0)
export (float, 0.1, 1.0) var move_speed = 0.5
export (float, 0.1, 0.4) var smooting = 0.3

var initialDistance := 13.0
var initial_proportion := 0.0
var viewport_rect: Rect2

func _ready() -> void:
	viewport_rect = get_viewport().get_visible_rect()
	set_process(get_child_count() > 0)

	for i in get_children():
# se asegura que los hijos ignoren el transform del padre
		i.set_as_toplevel(true)

func _process(delta: float) -> void:
	translation = calculate_position(calculate_target_rect(), calculate_project_rect())

func calculate_project_rect() -> Rect2:
	var rect := Rect2(unproject_position(get_child(0).translation), Vector2())
	
	for index in get_child_count():
		if index == 0:
			continue
		
		rect = rect.expand(unproject_position(get_child(index).translation))

	return rect

func calculate_target_rect() -> Rect2:
	var rect = Rect2(vec3_to_vec2(get_child(0).translation), Vector2())

	for index in get_child_count():
		if index == 0:
			continue

		rect = rect.expand(vec3_to_vec2(get_child(index).translation))

	return rect

func vec3_to_vec2 (v: Vector3) -> Vector2:
	return Vector2(v.x, v.y)

func calculate_center (r: Rect2) -> Vector2:
	return Vector2 (r.position.x + r.size.x / 2, r.position.y + r.size.y / 2)

func calculate_position (r: Rect2, unproject_rec: Rect2) -> Vector3:
	
	var center = calculate_center(r)
	
	if initial_proportion == 0 || initialDistance == 0:
		initial_proportion = unproject_rec.size.x / viewport_rect.size.x
		initialDistance = translation.distance_to(get_child(0).translation)

	var z_position = translation.z
	
	if unproject_rec.size.x / viewport_rect.size.x > initial_proportion:
		z_position = translation.z * move_speed

	elif unproject_rec.size.x / viewport_rect.size.x < initial_proportion && z_position > initialDistance:
		z_position = translation.z - move_speed

	return Vector3(center.x + center_offset.x, center.y + center_offset.y, lerp(translation.z, z_position, smooting))
