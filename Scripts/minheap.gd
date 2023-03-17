## A custom implementation of a heap for the A* graph algorithm.
##
## Based off of https://www.educative.io/answers/heap-implementation-in-python

extends Node
class_name minheap

var size: int
var heap_array: Array[Dictionary] = []
var cost_callback: Callable

func _init(
	_cost_callback: Callable = func(element): return element["f_cost"],
	lowest_element: Dictionary = {"f_cost": -INF}):
	size = 0
	# Initialize array with most minimun node.
	heap_array = [lowest_element]
	cost_callback = _cost_callback

func remove():
	if heap_array.size() == 1:
		return
	
	var root = heap_array[1]
	
	heap_array[1] = heap_array[size]
	heap_array.pop_back()
	
	size -= 1
	
	_sift_down(1)
	
	return root	

func insert(element):
	heap_array.append(element)
	size += 1
	_sift_up(size)

func _sift_up(position):
	var stop = false
	while _get_parent(position) > 0 and not stop:
		if cost_callback.call(self.heap_array[position]) < cost_callback.call(self.heap_array[_get_parent(position)]):
			_swap(position, _get_parent(position))
		else:
			stop = true
		position = _get_parent(position)

func _sift_down(position):
	# We only need to check the left child is greater than the heap size.
	while _get_left_child(position) <= size:
		var min_child_position = _get_min_child_position(position)
		if cost_callback.call(heap_array[position]) > cost_callback.call(heap_array[min_child_position]):
			_swap(position, min_child_position)
		position = min_child_position

func _get_min_child_position(position):
	# If the right child position is bigger than the heap size, then it means
	# there is only one child: the left one.
	if _get_right_child(position) > size:
		return _get_left_child(position)
	else:
		if cost_callback.call(heap_array[_get_left_child(position)]) < cost_callback.call(heap_array[_get_right_child(position)]):
			return _get_left_child(position)
		else:
			return _get_right_child(position)

func _get_parent(position: int) -> int:
	return floori(position / 2.0)

func _get_left_child(position: int):
	return position * 2

func _get_right_child(position: int):
	return (position * 2) + 1

func _swap(first_position, second_position):
	var temporary = heap_array[first_position]
	heap_array[first_position] = heap_array[second_position]
	heap_array[second_position] = temporary
