extends Resource
class_name ListTask

export(String) var task_list_name
export(int) var next_update_timestamp = 0
export(int) var duration_before_refresh = 86400
export(Array, Resource) var task_list
export(int) var nb_task_to_claim = 10
export(int) var nb_task_claimed
export(int) var priority = 100
