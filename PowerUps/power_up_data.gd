extends Resource
class_name PowerUpData

enum PowerTipe { ESCUDO, NITRO, CRONOMETRO }

@export var item_name : String
@export var type: PowerTipe
@export var texture: Texture2D
@export var time: float = 5.0
