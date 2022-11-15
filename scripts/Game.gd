extends Control


var archivo_preguntas = "res://data/preguntas.json"
var preguntas = []
var preguntas_hechas = []
var total_preguntas = 5
var pregunta_actual = -1
var puntaje = 0

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
	while true:
		pregunta_actual = randi() % len(preguntas)
		if not (pregunta_actual in preguntas_hechas):
			break
	
	$VBoxContainer/Pregunta.text = preguntas[pregunta_actual]["pregunta"]
	
	# Aleatorizar las opciones de respuesta
	var orden_opciones = []
	var aux = -1

	for i in range(4):
		var b = true
		while b:
			if not(aux in orden_opciones) and (aux > -1):
				orden_opciones.append(aux)
				b = false
			aux = randi() % 4
	
	print("Opciones")
	print(orden_opciones)
	
	$VBoxContainer/Opciones/Op1.text = preguntas[pregunta_actual]["opciones"][orden_opciones[0]]
	$VBoxContainer/Opciones/Op2.text = preguntas[pregunta_actual]["opciones"][orden_opciones[1]]
	$VBoxContainer/Opciones/Op3.text = preguntas[pregunta_actual]["opciones"][orden_opciones[2]]
	$VBoxContainer/Opciones/Op4.text = preguntas[pregunta_actual]["opciones"][orden_opciones[3]]
	
	preguntas_hechas.append(pregunta_actual)
	
	print(preguntas_hechas)
	$VBoxContainer/NumPregunta.text = "Pregunta " + str(len(preguntas_hechas)) + " de " + str(total_preguntas)


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
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
	
	print(respuesta)
	
	# la respuesta correcta siempre es la primera de la lista
	if preguntas[pregunta_actual]["opciones"][0] == respuesta:
		actualizar_puntaje(10)
		print("Correcto")
	else:
		print("Incorrecto")
	
	if len(preguntas_hechas) == total_preguntas:
		print("Fin del juego")
		_on_BVolver_pressed()
		return
	
	mostrar_pregunta()


func actualizar_puntaje(puntos):
	puntaje += puntos
	$VBoxContainer/TopContainer/Puntaje.text = "Puntaje: " + str(puntaje)
