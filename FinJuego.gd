extends Control


func _ready():
	$VBoxContainer/Puntaje.text = str(Manejador.last_score)


func _on_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")
