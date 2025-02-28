@tool
extends EditorPlugin

const Toolbar = preload("toolbar.gd")
var selection: EditorSelection
var canvas_toolbar: Toolbar


func _get_plugin_name():
	return "Hexagon TileMapLayer"


func _get_plugin_icon():
	return preload("hexagon_tilemaplayer.svg")


func _enter_tree():
	selection = EditorInterface.get_selection()
	selection.selection_changed.connect(_on_selection_changed)


func _exit_tree():
	selection.selection_changed.disconnect(_on_selection_changed)


func _on_selection_changed():
	if _is_hexagon_tilemaplayer_node_selected():
		if not canvas_toolbar:
			canvas_toolbar = Toolbar.new(self)
			add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, canvas_toolbar)
	elif canvas_toolbar:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, canvas_toolbar)
		canvas_toolbar = null


func _is_hexagon_tilemaplayer_node_selected() -> bool:
	var selected = selection.get_selected_nodes()
	return selected.size() == 1 and selected[0] is HexagonTileMapLayer
