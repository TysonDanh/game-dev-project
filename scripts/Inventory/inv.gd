extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var emptyslots = slots.filter(func(slot): return slot.item == null)
	if !emptyslots.is_empty():
		var new_slot = emptyslots[0].duplicate()
		new_slot.item = item
		new_slot.amount = 1
		var index = slots.find(emptyslots[0])
		slots[index] = new_slot
		update.emit()
		return true
