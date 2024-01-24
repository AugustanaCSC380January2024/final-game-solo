extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
func peer_connected(id):
	print("Player Connected " + str(id))

func peer_disconnected(id):
	print("Player Disconnected " + str(id))

func connected_to_server():
	print("Connected to Server!")
	send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"name" : name,
			"id" : id
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_information.rpc(GameManager.Players[i].name, i)

func connection_failed():
	print("Couldn't Connect!")

@rpc("any_peer","call_local")
func start_game():
	var scene = load("res://Scenes/Game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host:" + error)
		return
	peer.get_host().compress(1)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	send_player_information($LineEdit.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_button_down():
	print("Attempting to Join")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(1)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_game_button_down():
	start_game.rpc()
	pass # Replace with function body.
