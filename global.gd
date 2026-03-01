extends Node

var inventory_size = 8
var locker_size = 24

var is_menu_open = false

var ogygen_depletion_speed = 2
var mining_direction = null
var oxygen_upgrades = 0
var inventory_upgrades = 0

var crafting_recipes = [
	{
		"name": "Larger oxygen tank (+50)",
		"ingredients":  [
			["aluminium",  3]
		],
		"reward": {
			"type": "global_var",
			"key": "oxygen_upgrades",
		}
	},
	{
		"name": "More inventory space (+4)",
		"ingredients":  [
			["gold",  5]
		],
		"reward": {
			"type": "global_var",
			"key": "inventory_upgrades"
		}
	},
	{
		"name": "Supports",
		"ingredients":  [
			["iron",  1]
		],
		"reward": {
			"type": "item",
			"key": "support"
		}
	},
	{
		"name": "Dynamite",
		"ingredients":  [
			["debris",  1],
			["fossil",  1]
		],
		"reward": {
			"type": "item",
			"key": "dynamite"
		}
	}
]

var keybinds_visible = ["basic"]

var keybinds = {
	"basic": '[img width=50px]res://assets/input_icons/keyboard_arrows.svg[/img] Move
[img width=50px]res://assets/input_icons/keyboard_space.svg[/img] Jump
[img width=50px]res://assets/input_icons/mouse_left.svg[/img] Mine
[img width=50px]res://assets/input_icons/mouse_right.svg[/img] Build supports
 [img width=40px]res://assets/input_icons/keyboard_f.svg[/img] Explode dynamite
 [img width=40px]res://assets/input_icons/keyboard_e.svg[/img] Inventory',
"menu": '
[img width=50px]res://assets/input_icons/mouse_left.svg[/img] Move items
 [img width=40px]res://assets/input_icons/keyboard_e.svg[/img] Exit inventory',
"locker": '
[img width=50px]res://assets/input_icons/mouse_right.svg[/img] Transfer item
'
}

const ITEMS = {
	"test": {
		"sprite": "res://assets/temp/item.png"
	},
	"aluminium": {
		"sprite": "res://assets/spritesheet/Aluminium_item.png"
	},
	"gold": {
		"sprite": "res://assets/spritesheet/Gold_item.png"
	},
	"iron": {
		"sprite": "res://assets/spritesheet/Iron_Item.png"
	},
	"rock": {
		"sprite": "res://assets/spritesheet/Mud_Item.png"
	},
	"support": {
		"sprite": "res://assets/spritesheet/Support_item.png"
	},
	"debris": {
		"sprite": "res://assets/spritesheet/Trash_item.png"
	},
	"fossil": {
		"sprite": "res://assets/spritesheet/Bone_item.png"
	},
	"dynamite": {
		"sprite": "res://assets/spritesheet/dynamite_item.png"
	}
}
