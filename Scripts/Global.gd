extends Node


const LETTERS = ["Alpha", "Beta", "Gamma", "Delta", 
				"Epsilon", "Zeta", "Eta", "Theta", 
				"Iota", "Kappa", "Lambda", "Mu", 
				"Nu", "Xi", "Omikron", "Pi", 
				"Rho", "Sigma", "Tau", "Upsilon", 
				"Phi", "Chi", "Psi", "Omega"]
var answer:String=""
var correct:int=0
var total:int=0
var random_gen:RandomNumberGenerator

func _ready():
	random_gen=RandomNumberGenerator.new()
	random_gen.randomize()

func correct_answer():
	total +=1
	correct+=1

func false_answer():
	total+=1
