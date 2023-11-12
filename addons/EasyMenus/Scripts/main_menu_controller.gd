extends Control
signal start_game_pressed

@export var start_scene : PackedScene

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: Control = $%OptionsMenu
@onready var content: Control = $%Content 
@onready var text_edit: TextEdit = $Panel/TextEdit
@onready var find_button: Button = $Panel/FindStart


func _ready():
	start_game_button.grab_focus()

func quit():
	get_tree().quit()
	
func open_options():
	options_menu.show()
	content.hide()
	options_menu.on_open()
	
func close_options():
	content.show();
	start_game_button.grab_focus()
	options_menu.hide()


func _on_start_game_button_pressed():
	GameManager.mode = "hide"
	MenuTemplateManager.switch_scene(start_scene)
	queue_free()


func _on_find_start_pressed():
	GameManager.mode = "find"
	GameManager.numPlaced = 8
	GameManager.inputted_code = text_edit.text
	MenuTemplateManager.switch_scene(start_scene)
	GameManager.place_items_for_player_to_find()
	queue_free()
	


func _on_text_edit_text_changed():
	var code = text_edit.text
	find_button.disabled = (code.length() < 10)
		
