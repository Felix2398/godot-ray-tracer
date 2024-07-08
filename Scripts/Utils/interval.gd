class_name Interval
extends RefCounted

var min_value: float
var max_value: float

func _init(new_min_value: float = -INF, new_max_value: float = INF):
	self.min_value = new_min_value
	self.max_value = new_max_value

func size() -> float:
	return max_value - min_value

func contains(value: float) -> bool:
	return value >= min_value and value <= max_value

func surrounds(value: float) -> bool:
	return value > min_value and value < max_value

static func empty() -> Interval:
	return Interval.new(INF, -INF)

static func universe() -> Interval:
	return Interval.new(-INF, INF)
