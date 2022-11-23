extends Node


var last_score = 0
var high_score = 0
var preguntas = []
var total_preguntas = 10
var preguntas_hechas = []
var pregunta_actual = -1
var archivo_preguntas = "res://data/preguntas.json"


func _ready():
	pass


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
	preguntas = data
