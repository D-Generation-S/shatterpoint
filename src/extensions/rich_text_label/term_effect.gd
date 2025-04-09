extends RichTextEffect

func _process_custom_fx(char_fx: CharFXTransform):
    var rect = char_fx.get
    char_fx.color = Color.YELLOW
    pass
