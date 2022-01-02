extends Node2D

onready var text_node = RichTextLabel.new()
onready var text_bg = ColorRect.new()
onready var tween = Tween.new()

export var delay = 2
export var bg_delay = 0.2
export var color = Color.black
export var bg_color: Color = Color.white
export var text: String
export var font_resource: Resource
export var char_delay = 0.02
export var read_delay = 2

export var margin_offset = 8

func _ready() -> void:
	add_child(tween)
	add_child(text_bg)
	add_child(text_node)
	var font = DynamicFont.new()
	font.font_data = font_resource
	text_node.add_font_override('normal_font', font)
	text_node.add_color_override('default_color', color)
	text_node.bbcode_text = text
	text_node.scroll_active = false
	text_node.percent_visible = 0
	
	text_bg.color = bg_color
	animate(font)

func animate(font):
	#Duration
	var text_duration = text_node.text.length() * char_delay
	#Size of speech bubble
	var text_size: Vector2 = font.get_string_size(text)
	text_node.rect_size = text_size
	text_node.rect_position = Vector2(-text_size.x/2, -text_size.y/2)
	var bg_pos_start = Vector2(0, -text_size.y/2 - margin_offset)
	var bg_pos_end = Vector2(-text_size.x/2 - margin_offset, -text_size.y/2 - margin_offset)
	var bg_size_start = Vector2(0, text_size.y + 2*margin_offset)
	var bg_size_end = Vector2(text_size.x + 2*margin_offset, text_size.y + 2*margin_offset)
	
	#text_node.margin_right = text_size.x + margin_offset
	text_bg.margin_right = -margin_offset
	#Animation
	tween.remove_all()
	tween.interpolate_property(text_bg, "rect_position", bg_pos_start, bg_pos_end, bg_delay, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	tween.interpolate_property(text_bg, "rect_size", bg_size_start, bg_size_end, bg_delay, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	tween.interpolate_property(text_node, "percent_visible", 0, 1, text_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + bg_delay)
	
	tween.interpolate_property(text_node, "percent_visible", 1, 0, 0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + bg_delay + text_duration + read_delay)
	tween.interpolate_property(text_bg, "rect_size", bg_size_end, bg_size_start, bg_delay, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + bg_delay + text_duration + read_delay)
	tween.interpolate_property(text_bg, "rect_position", bg_pos_end, bg_pos_start, bg_delay, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + bg_delay + text_duration + read_delay)
	tween.start()
