extends Control

func _on_copy_button_pressed():
	DisplayServer.clipboard_set(GameManager.generated_code)
	print(GameManager.generated_code)

	# this does nothing

func _on_menu_button_pressed():
	get_tree().quit()
