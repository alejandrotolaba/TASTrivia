extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Manejador.categorias_juego == []:
		print("No hay categorias")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		return
	
	# Crea un boton para cada categoría y conecta la señal de presionado
	var buttons = []
	for i in range(len(Manejador.categorias_juego)):
		buttons.append(Button.new())
		buttons[i].text = Manejador.categorias_juego[i]
		buttons[i].set_h_size_flags(Control.SIZE_EXPAND_FILL)
		buttons[i].set_v_size_flags(Control.SIZE_EXPAND_FILL)
		buttons[i].connect("pressed", self, "on_categoria_selected", [Manejador.categorias_juego[i]])
		$MainContainer/Categorias.add_child(buttons[i])


func on_categoria_selected(cat):
	Manejador.categoria = cat
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Game.tscn")
