extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	for letter in Global.LETTERS:
		#Go through sprite folder and fill yourself up
		var file2Check = File.new()
		if file2Check.file_exists("res://Sprites/Lowercase"+letter+".png.import"):
			add_item(letter, ResourceLoader.load("res://Sprites/Lowercase"+letter+".png"))
		else:
			#There are multiple possible letters, select the first
			add_item(letter, ResourceLoader.load("res://Sprites/Lowercase"+letter+"1.png"))			
