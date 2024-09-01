@icon("res://addons/rational/icons/Leaf.svg")
@tool
class_name Leaf extends RationalComponent

# const EXPRESSION_PLACEHOLDER: String = "Insert an expression..."

# var expression_data: Dictionary = {}

# func parse_expressions(source: String) -> Expression:
# 	var result: Expression = Expression.new()
# 	var error: int = result.parse(source)

# 	if not Engine.is_editor_hint() and error != OK:
# 		push_error(
# 			(
# 				"[Leaf] Couldn't parse expression with source: `%s` Error text: `%s`"
# 				% [source, result.get_error_text()]
# 			)
# 		)

# 	return result


# func _has_expression() -> bool:
# 	return true


# func _get_property_list() -> Array[Dictionary]:
# 	var props: Array[Dictionary] = []
# 	if _has_expression():
# 		props.append(
# 			{
# 				"name": &"expression_strings",
# 				"type": TYPE_PACKED_STRING_ARRAY,
# 				"hint": PROPERTY_HINT_TYPE_STRING,
# 				"hint_string": "4/18:", # TYPE_STRING/TYPE_TRANSFORM3D?? | "hint": 23, "hint_string": "4/18:", "usage": 4102 }
# 				"usage": 4102,
# 			}
# 		)
	
# 	return props


# func _validate_property(property: Dictionary) -> void:
# 	if property.name == "expression_arrays":
# 		print(property)


# func _get(property: StringName) -> Variant:
# 	match property:
# 		&"expression_strings":
# 			return expression_data.get(property, PackedStringArray())
# 	return null


# func _set(property: StringName, value: Variant) -> bool:
# 	super(property, value)

# 	match property:
# 		&"expression_strings":
# 			expression_data[property] = value
	
# 	return false
