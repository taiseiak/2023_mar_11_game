extends Node

func _init():
	var min_heap = minheap.new()
	min_heap.insert(10)
	min_heap.insert(15)
	min_heap.insert(20)
	min_heap.insert(1)
	min_heap.insert(3)
	print(min_heap.heap_array)
	
	while min_heap.size > 0:
		print("-------")
		print("removed: ", min_heap.remove())
		print("heap array: ", min_heap.heap_array)
		print("heap size: ", min_heap.size)
