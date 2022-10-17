extends BaseTask
class_name ElementCondition

export var type_name : String = "ElementCondition"

export(Array,int) var element_list
# au moins feu et eau
# au moins feu ou eau
# que feu ou eau
# pas feu et eau en meme temps
# pas feu ou eau
# au moins un different de feu ou eau

# au moins / que
# pas / besoin
# ou / et
export var besoin : bool
export var au_moins : bool
export var ou : bool


