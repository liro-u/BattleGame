extends BaseTask
class_name RequiredBattler

export var type_name : String = "RequiredBattler"

export(Array,Resource) var required_bat_list
#if true, to validate you just need one battler in the list, else you need all of them ( in the team )
export var ou : bool = true
