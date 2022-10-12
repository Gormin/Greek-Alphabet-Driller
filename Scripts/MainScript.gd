extends Node

var cur_letters_dict = {}
var short_dict={}
onready var lowercase_itemlist=$Panel/VBoxContainer/HBoxContainer/VBoxContainer/LowercaseList
onready var capitals_itemlist=$Panel/VBoxContainer/HBoxContainer/VBoxContainer2/CapitalsList
onready var sprite = $Panel/VBoxContainer/VBoxContainer/LetterContainer/TextureRect
onready var textbox = $Panel/VBoxContainer/VBoxContainer/TextBoxContainer/TextEdit
onready var counts = $Panel/VBoxContainer/HBoxContainer2/Count
onready var answer = $Panel/VBoxContainer/HBoxContainer2/Answer

func _ready():
	#Populate dictionary with all possible letters to be selected
	for x in range(Global.LETTERS.size()):
		cur_letters_dict[x]=Vector2(0,0)
	textbox.grab_focus()
			
func generate_short_dict():
	short_dict.clear()
	for letter in cur_letters_dict.keys():
		var val:Vector2=cur_letters_dict[letter]
		if val!=Vector2(0,0):
			short_dict[letter]=val
	get_letter()
	textbox.grab_focus()
			
func _on_LowercaseList_multi_selected(_index, _selected):
	#set selected lowercase items and generate shortcut dict of relevant items
	var selected_items=lowercase_itemlist.get_selected_items()
	for item in cur_letters_dict:
		if item in selected_items:
			cur_letters_dict[item].y=1
		else:
			cur_letters_dict[item].y=0			
	generate_short_dict()
	
func _on_CapitalsList_multi_selected(_index, _selected):
	#set selected capital items and generate shortcut dict of relevant items
	var selected_items=capitals_itemlist.get_selected_items()
	for item in cur_letters_dict:
		if item in selected_items:
			cur_letters_dict[item].x=1
		else:
			cur_letters_dict[item].x=0			
	generate_short_dict()

func get_letter():
	answer.bbcode_text=""
	textbox.text=""
	#First select letter, then, if both active, randomly select if capital or not
	var short_dict_keys=short_dict.keys()
	var letter_ind :int = short_dict_keys[Global.random_gen.randi_range(0,short_dict_keys.size()-1)]
	var cap :bool = false
	
	if short_dict[letter_ind].x == 1 and short_dict[letter_ind].y == 1:
		if Global.random_gen.randi_range(0,1) == 0:
			cap = true
	elif short_dict[letter_ind].x == 1:
		cap = true
	var selector:String=""
	if cap:
		selector="Capital"
	else:
		selector="Lowercase"
	#If multiple letters in sprite with 1, 2 etc., select randomly from them
	var file2Check = File.new()
	if file2Check.file_exists("res://Sprites/"+selector+Global.LETTERS[letter_ind]+".png.import"):
		sprite.texture=ResourceLoader.load("res://Sprites/"+selector+Global.LETTERS[letter_ind]+".png")
	else:
		#There are multiple possible letters, select one and copy it into sprite
		var possible_letters = []
		var num :int = 1
		while file2Check.file_exists("res://Sprites/"+selector+Global.LETTERS[letter_ind]+str(num)+".png.import"):
			possible_letters.append(num)
			num+=1
		sprite.texture=ResourceLoader.load("res://Sprites/"+selector+Global.LETTERS[letter_ind]+str(possible_letters[Global.random_gen.randi_range(0,possible_letters.size()-1)])+".png")
	#set Global.answer
	Global.answer = Global.LETTERS[letter_ind]

func _on_TextEdit_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		if Global.answer!="":
		#On UI_accept, check Global.answer
			textbox.text=textbox.text.strip_edges()
			if textbox.text.to_lower() in Global.answer.to_lower():
				Global.correct_answer()
				counts.text="Correct: "+str(Global.correct)+"/"+str(Global.total)
				get_letter()
				
			else:
				Global.false_answer()
				counts.text="Correct: "+str(Global.correct)+"/"+str(Global.total)			
				answer.bbcode_text="[color=red]CORRECT ANSWER: " + Global.answer + "[/color]"
				#Wait half a second, then make a new one
				var timer = Timer.new()
				add_child(timer)
				timer.one_shot=true
				timer.wait_time = 0.8
				timer.connect("timeout", self, "get_letter")
				timer.start()
		else:
			textbox.text=""
