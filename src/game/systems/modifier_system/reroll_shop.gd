extends Button

func change_reroll_price(price: int):
    if price > GlobalDataAccess.get_resource_overlay().get_scrap():
        disabled = true
    else:
        disabled = false