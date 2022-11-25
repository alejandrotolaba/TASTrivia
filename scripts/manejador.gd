extends Node


var archivo_preguntas = "res://data/preguntas.json"
var modo_seleccionado = "Facil"
var categorias_juego = []
var categoria = "Facil"
var last_score = 0
var high_score = 0
var preguntas = []
var total_preguntas = 10
var preguntas_hechas = []
var pregunta_actual = -1


func _ready():
	cargar_categorias()


func cargar_preguntas(modo="Facil"):
	print("Cargando preguntas para: ", modo)
	# Carga el archivo de preguntas JSON
	var archivo = File.new()
	
	# Si el archivo no existe mostrar un mensaje y return
	if not archivo.file_exists(archivo_preguntas):
		print("El archivo de preguntas no existe")
		return []
	
	# Cargar las preguntas en el JSON
	archivo.open(archivo_preguntas, File.READ)
	var data = parse_json(archivo.get_as_text())[modo]
	archivo.close()
	
	# Devuelve la lista de preguntas
	preguntas = data


func cargar_categorias():
	# Cargar categorias disponibles en el archivo de preguntas
	# Carga el archivo de preguntas JSON
	var archivo = File.new()
	
	# Si el archivo no existe mostrar un mensaje y return
	if not archivo.file_exists(archivo_preguntas):
		print("El archivo de preguntas no existe")
		return []
	
	# Cargar las preguntas en el JSON
	archivo.open(archivo_preguntas, File.READ)
	var data = parse_json(archivo.get_as_text()).keys()
	archivo.close()
	
	categorias_juego = data
