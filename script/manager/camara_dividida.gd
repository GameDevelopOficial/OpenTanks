extends Node

var numero_jugadores: int = 2

func iniciar() -> void:
	print(numero_jugadores)
	var t = get_viewport().size
	match numero_jugadores:
		2:
			$jugadores/J1y2/jugador_1.rect_min_size = Vector2(t.x, t.y / 2)
			$jugadores/J1y2/jugador_2.rect_min_size = Vector2(t.x, t.y / 2)
			$jugadores/J1y2/jugador_1/V0.size = Vector2(t.x, t.y/2)
			$jugadores/J1y2/jugador_2/V1.size = Vector2(t.x, t.y/2)

		3:
			$jugadores/J1y2/jugador_1.rect_min_size = Vector2(t.x/2, t.y / 2)
			$jugadores/J1y2/jugador_2.rect_min_size = Vector2(t.x/2, t.y / 2)
			$jugadores/J1y2/jugador_1/V0.size = Vector2(t.x/2, t.y/2)
			$jugadores/J1y2/jugador_2/V1.size = Vector2(t.x/2, t.y/2)

			$jugadores/J3y4/jugador_3.rect_min_size = Vector2(t.x / 2, t.y / 2)
			$jugadores/J3y4/jugador_4.rect_min_size = Vector2(t.x / 2, t.y / 2)
			$jugadores/J3y4/jugador_3/V2.size = Vector2(t.x / 2, t.y/2)
			$jugadores/J3y4/jugador_4/V3.size = Vector2(t.x / 2, t.y/2)

		4:
			$jugadores/J1y2/jugador_1.rect_min_size = Vector2(t.x/2, t.y / 2)
			$jugadores/J1y2/jugador_2.rect_min_size = Vector2(t.x/2, t.y / 2)
			$jugadores/J1y2/jugador_1/V0.size = Vector2(t.x/2, t.y/2)
			$jugadores/J1y2/jugador_2/V1.size = Vector2(t.x/2, t.y/2)

			$jugadores/J3y4/jugador_3.rect_min_size = Vector2(t.x / 2, t.y / 2)
			$jugadores/J3y4/jugador_4.rect_min_size = Vector2(t.x / 2, t.y / 2)
			$jugadores/J3y4/jugador_3/V2.size = Vector2(t.x / 2, t.y/2)
			$jugadores/J3y4/jugador_4/V3.size = Vector2(t.x / 2, t.y/2)
