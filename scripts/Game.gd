extends Control


var rng = RandomNumberGenerator.new()


func mostrar_pregunta():
	# Deshabilitar botones de opciones
	$VBoxContainer/Opciones/Op1.disabled = true
	$VBoxContainer/Opciones/Op2.disabled = true
	$VBoxContainer/Opciones/Op3.disabled = true
	$VBoxContainer/Opciones/Op4.disabled = true
	
	# Sortear pregunta
	while true:
#		print("Sorteo pregunta")
		Manejador.pregunta_actual = rng.randi() % len(Manejador.preguntas)
		
		# Solo elegir preguntas no realizadas anteriormente
		if not (Manejador.pregunta_actual in Manejador.preguntas_hechas):
			break
	
	# Mostrar la pregunta en el label correspondiente
	$VBoxContainer/Pregunta.text = Manejador.preguntas[Manejador.pregunta_actual]["pregunta"]
	
	# Mostrar las opciones de respuesta en orden aleatorio
	var orden_opciones = []
	var aux = -1

	for _i in range(4):
		var b = true
		while b:
#			print("Sorteo opciones")
			if not(aux in orden_opciones) and (aux > -1):
				orden_opciones.append(aux)
				b = false
			aux = rng.randi() % 4
	
	# Cambiar el texto de botones por las opciones de respuesta
	$VBoxContainer/Opciones/Op1.text = Manejador.preguntas[Manejador.pregunta_actual]["opciones"][orden_opciones[0]]
	$VBoxContainer/Opciones/Op2.text = Manejador.preguntas[Manejador.pregunta_actual]["opciones"][orden_opciones[1]]
	$VBoxContainer/Opciones/Op3.text = Manejador.preguntas[Manejador.pregunta_actual]["opciones"][orden_opciones[2]]
	$VBoxContainer/Opciones/Op4.text = Manejador.preguntas[Manejador.pregunta_actual]["opciones"][orden_opciones[3]]
	
	# Agregar pregunta actual a la lista de preguntas hechas
	Manejador.preguntas_hechas.append(Manejador.pregunta_actual)
	
	# Actualizar el contador de preguntas realizadas
	$VBoxContainer/NumPregunta.text = "Pregunta " + str(len(Manejador.preguntas_hechas)) + " de " + str(Manejador.total_preguntas)
	
	# Iniciar el temporizador para habilitar los botones de opciones
	$Sleeper.start()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	Manejador.last_score = 0
	actualizar_puntaje()
	
	Manejador.pregunta_actual = 0
	Manejador.preguntas_hechas = []

	Manejador.cargar_preguntas(Manejador.categoria)
	
	if Manejador.preguntas == []:
		print("No hay preguntas!")
		return
	
	mostrar_pregunta()


func _on_BVolver_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Option_pressed(option):
	# Manejar las respuestas ingresadas
	
	var respuesta = ""
	if option == 0:
		respuesta = $VBoxContainer/Opciones/Op1.text
	elif option == 1:
		respuesta = $VBoxContainer/Opciones/Op2.text
	elif option == 2:
		respuesta = $VBoxContainer/Opciones/Op3.text
	elif option == 3:
		respuesta = $VBoxContainer/Opciones/Op4.text
	
	# la respuesta correcta siempre es la primera de la lista en el archivo
	var sumapuntos = 0
	if Manejador.preguntas[Manejador.pregunta_actual]["opciones"][0] == respuesta:
		print("Correcto")
		sumapuntos = 100 / Manejador.total_preguntas
	else:
		print("Incorrecto")
	
	actualizar_puntaje(sumapuntos)
	
	if len(Manejador.preguntas_hechas) >= Manejador.total_preguntas:
		print("Fin del juego")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/FinJuego.tscn")
	
	mostrar_pregunta()


func actualizar_puntaje(puntos=0):
	Manejador.last_score += puntos
	if Manejador.high_score < Manejador.high_score:
		Manejador.high_score = Manejador.high_score
		
	$VBoxContainer/TopContainer/Puntaje.text = "Puntaje: " + str(Manejador.last_score)


func _on_Sleeper_timeout():
	$VBoxContainer/Opciones/Op1.disabled = false
	$VBoxContainer/Opciones/Op2.disabled = false
	$VBoxContainer/Opciones/Op3.disabled = false
	$VBoxContainer/Opciones/Op4.disabled = false
