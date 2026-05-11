extends Control

func _on_client_pressed() -> void:
	HighLevelNetworkHandler.start_client()
	%HighLevelUI.hide()

func _on_host_pressed() -> void:
	HighLevelNetworkHandler.start_host()
	%HighLevelUI.hide()
