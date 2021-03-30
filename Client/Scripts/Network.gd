extends Node


var socket = PacketPeerUDP.new()


func connect_to_host(host, nickname):
	
	socket.set_dest_address(host, 6969)

	if socket.get_available_packet_count() > 0:
		var data = socket.get_packet().get_string_from_ascii()

		if data == "NICK":
			socket.put_packet(nickname)
