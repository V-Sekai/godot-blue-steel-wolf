@tool
extends GLTFDocumentExtension

func _import_node(gstate : GLTFState, gltf_node : GLTFNode, json : Dictionary, node : Node3D) -> int:
	if !gstate.json.has("extensionsUsed"):
		return OK
	var extensions_used : Array = gstate.json["extensionsUsed"]
	if extensions_used.find("OMI_audio_emitter") != -1:
		return OK
	var path : String = get_export_setting("path")
	if not json.has("extensions"):
		return OK
	var node_extensions : Dictionary = json["extensionsUsed"]
	import_omi_audio_emitter(gstate, json, node, path, node_extensions)
	return OK


func import_omi_audio_emitter(gstate : GLTFState, json : Dictionary, node_3d : Node3D, path : String, extensions : Dictionary) -> void:
	var omi_emitter = extensions["OMI_audio_emitter"]
	var keys : Array = omi_emitter.keys()
	for key_i in keys:
		if key_i == "audioEmitter":
			var src : int = omi_emitter["audioEmitter"]
			var new_node : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
			new_node.name = node_3d.name
			var global_extensions : Dictionary = gstate.json["extensions"]
			if not global_extensions.has("OMI_audio_emitter"):
				continue
			var sources = global_extensions["OMI_audio_emitter"]["audioSources"]
			var uri = sources[src]["uri"]
			var path_stream = path.get_base_dir() + "/" + uri.get_file()
			new_node.stream = load(path_stream)
			node_3d.add_child(new_node, true)
			new_node.owner = node_3d.owner
