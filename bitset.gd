class_name Bitset
extends Reference

const MASK_SIZE := 32

var bitmasks: PoolIntArray = []
var bits: int

func _init(size: int, default_state: bool = false, enforce_soft_size: bool = true) -> void:
	resize(size, default_state, enforce_soft_size)


func resize(size: int, default_state: bool = false, enforce_soft_size: bool = true) -> void:
	assert(size >= 0)
	var old_masks := bitmasks.size()
	if old_masks > 0 and bits % MASK_SIZE:
		if default_state:
			bitmasks[old_masks - 1] |= (~0 << (bits % MASK_SIZE))
		else:
			bitmasks[old_masks - 1] &= ~((~0) << (bits % MASK_SIZE))
	bitmasks.resize(ceil(size / float(MASK_SIZE)))
	bits = size if enforce_soft_size else bitmasks.size() * MASK_SIZE
	for i in range(old_masks, bitmasks.size()):
		bitmasks[i] = ~0 if default_state else 0


func check_bit(index: int) -> bool:
	assert(index < bits)
	return bitmasks[index / MASK_SIZE] & (1 << (index % MASK_SIZE)) != 0


func set_bit(index: int, state: bool) -> void:
	assert(index < bits)
	if state:
		bitmasks[index / MASK_SIZE] |= (1 << (index % MASK_SIZE))
	else:
		bitmasks[index / MASK_SIZE] &= ~(1 << (index % MASK_SIZE))


func flip_bit(index: int) -> void:
	assert(index < bits)
	set_bit(index, !check_bit(index))

