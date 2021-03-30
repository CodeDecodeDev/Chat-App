extends Node

var Nickname

var socket = StreamPeerTCP.new()

func from_pool_byte_array_u16(array: PoolByteArray, offset: int) -> int:
	var return_value := 0
	
	for i in range(2):
		return_value += array[offset + i] * (1 << i * 8)
	
	return return_value

func from_pool_byte_array_u32(array: PoolByteArray, offset: int) -> int:
	var return_value := 0
	
	for i in range(4):
		return_value += array[offset + i] * (1 << i * 8)
	
	return return_value

func from_pool_byte_array_u64(array: PoolByteArray, offset: int) -> int:
	var bytes := array.subarray(offset, offset + 7)
	
	var val2 := from_pool_byte_array_u32(bytes, 0)
	var val1 := from_pool_byte_array_u32(bytes, 4)
	if val1 > 2147483647: # signed integer
		# Spamming int() because release builds weird
		return int(0) - int(int(4294967295 - val1) * int(pow(2, 32)) + int(4294967296 - val2))
	else:
		return int(val1 * pow(2, 32)) + int(val2)

func to_pool_byte_array_u16(value: int) -> PoolByteArray:
	var bytes : PoolByteArray = []
	for i in range(2):
		bytes.append((value / int(pow(2, i * 8))) % 256)
	
	return bytes

func to_pool_byte_array_u32(value: int) -> PoolByteArray:
	var bytes : PoolByteArray = []
	for i in range(4):
		bytes.append((value / int(pow(2, i * 8))) % 256)
	
	return bytes

func to_pool_byte_array_u64(value: int) -> PoolByteArray:
	var bytes : PoolByteArray = []
	bytes.append_array(to_pool_byte_array_u32(value % 4294967296))
	bytes.append_array(to_pool_byte_array_u32(value / 4294967296))
	
	if value < 0:
		for i in range(bytes.size() - 1):
			bytes[i + 1] -= 1
	return bytes

func _connect(host, nickname):
	
	Nickname = nickname
	
	socket.connect_to_host(str(host), 6970)
	
	var nick_not_sent = true
	
	while nick_not_sent:
		if socket.get_available_bytes() > 0:
			var data = socket.get_string(4)
			if data == "NICK":
				var string_bytes = nickname.to_utf8()
				var final_bytes : PoolByteArray = to_pool_byte_array_u16(string_bytes.size())
				final_bytes.append_array(string_bytes)
				socket.put_data(final_bytes)
				nick_not_sent = false



func send_to_host(message):
	var string_bytes = (Nickname + ": " + message).to_utf8()
	var final_bytes : PoolByteArray = to_pool_byte_array_u16(string_bytes.size())
	final_bytes.append_array(string_bytes)
	socket.put_data(final_bytes)
