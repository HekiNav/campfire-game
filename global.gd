extends Node

var inventory_size = 24

var is_menu_open = false

var ogygen_depletion_speed = 2
var mining_direction = null

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
	}
}
