extends Control


var archivo_preguntas = "res://data/preguntas.json"
var preguntas = []
var preguntas_hechas = []
var total_preguntas = 10
var pregunta_actual = -1

var rng = RandomNumberGenerator.new()


func cargar_preguntas():
	# Carga el archivo de preguntas JSON
	var archivo = File.new()
	
	# Si el archivo no existe mostrar un mensaje y return
	if not archivo.file_exists(archivo_preguntas):
		print("El archivo de preguntas no existe")
		return []
	
	# Cargar las preguntas en el JSON
	archivo.open(archivo_preguntas, File.READ)
	var data = parse_json(archivo.get_as_text())
	archivo.close()
	
	# Devuelve la lista de preguntas
	return data


func mostrar_pregunta():
	# Deshabilitar botones de opciones
	$VBoxContainer/Opciones/Op1.disabled = true
	$VBoxContainer/Opciones/Op2.disabled = true
	$VBoxContainer/Opciones/Op3.disabled = true
	$VBoxContainer/Opciones/Op4.disabled = true
	
	# Sortear pregunta
	while true:
		pregunta_actual = rng.randi() % len(preguntas)
		
		# Solo elegir preguntas no realizadas anteriormente
		if not (pregunta_actual in preguntas_hechas):
			break
	
	# Mostrar la pregunta en el label correspondiente
	$VBoxContainer/Pregunta.text = preguntas[pregunta_actual]["pregunta"]
	
	# Mostrar las opciones de respuesta en orden aleatorio
	var orden_opciones = []
	var aux = -1

	for _i in range(4):
		var b = true
		while b:
			if not(aux in orden_opciones) and (aux > -1):
				orden_opciones.append(aux)
				b = false
			aux = rng.randi() % 4
	
	# Cambiar el texto de botones por las opciones de respuesta
	$VBoxContainer/Opciones/Op1.text = preguntas[pregunta_actual]["opciones"][orden_opciones[0]]
	$VBoxContainer/Opciones/Op2.text = preguntas[pregunta_actual]["opciones"][orden_opciones[1]]
	$VBoxContainer/Opciones/Op3.text = preguntas[pregunta_actual]["opciones"][orden_opciones[2]]
	$VBoxContainer/Opciones/Op4.text = preguntas[pregunta_actual]["opciones"][orden_opciones[3]]
	
	# Agregar pregunta actual a la lista de preguntas hechas
	preguntas_hechas.append(pregunta_actual)
	
	# Actualizar el contador de preguntas realizadas
	$VBoxContainer/NumPregunta.text = "Pregunta " + str(len(preguntas_hechas)) + " de " + str(total_preguntas)
	
	# Iniciar el temporizador para habilitar los botones de opciones
	$Sleeper.start()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	Manejador.last_score = 0
	actualizar_puntaje()
	preguntas = cargar_preguntas()
	
	if preguntas == []:
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
	if preguntas[pregunta_actual]["opciones"][0] == respuesta:
		print("Correcto")
		sumapuntos = 100 / total_preguntas
	else:
		print("Incorrecto")
	
	actualizar_puntaje(sumapuntos)
	
	if len(preguntas_hechas) == total_preguntas:
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
