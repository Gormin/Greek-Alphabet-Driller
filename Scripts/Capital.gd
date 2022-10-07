extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	for letter in Global.LETTERS:
		var file2Check = File.new()
		if file2Check.file_exists("res://Sprites/Capital"+letter+".png.import"):
			add_item(letter, ResourceLoader.load("Sprites/Capital"+letter+".png"))
		else:
			#There are multiple possible letters, select the first
			add_item(letter, ResourceLoader.load("res://Sprites/Capital"+letter+"1.png"))	
