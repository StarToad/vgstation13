/datum/smelting_recipe
	var/name=""
	var/list/ingredients=list() // phazon=1, iron=1
	var/yieldtype=null

// Note: Returns -1 if not enough ore!
/datum/smelting_recipe/proc/checkIngredients(var/obj/machinery/mineral/processing_unit/P)
	var/sufficient_ore=1
	var/matching_ingredient_count=0
	for(var/ore_id in P.ore)
		var/datum/material/po=P.ore[ore_id]
		var/required=(ore_id in ingredients)

		// Selected but not in ingredients
		if(po.selected&& !required)
			return 0

		// Unselected but in ingredients
		if(!po.selected && required)
			return 0

		var/min_ore_required=ingredients[ore_id]

		// Selected, in ingredients, but not enough in stock.
		if(po.selected && required)
			if(po.stored < min_ore_required)
				sufficient_ore=0
				continue

			matching_ingredient_count++

	if(!sufficient_ore)
		return -1 // -1 means not enough ore. NOT A TYPO.

	return matching_ingredient_count == ingredients.len

// RECIPES BEEP BOOP
/datum/smelting_recipe/glass
	name="Glass"
	ingredients=list(
		"glass"=1
	)
	yieldtype=/obj/item/stack/sheet/glass

/datum/smelting_recipe/rglass
	name="Reinforced Glass"
	ingredients=list(
		"glass"=1,
		"iron"=1
	)
	yieldtype=/obj/item/stack/sheet/rglass

/datum/smelting_recipe/gold
	name="Gold"
	ingredients=list(
		"gold"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/gold

/datum/smelting_recipe/silver
	name="Silver"
	ingredients=list(
		"silver"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/silver

/datum/smelting_recipe/diamond
	name="Diamond"
	ingredients=list(
		"diamond"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/diamond

/datum/smelting_recipe/plasma
	name="Plasma"
	ingredients=list(
		"plasma"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/plasma

/datum/smelting_recipe/uranium
	name="Uranium"
	ingredients=list(
		"uranium"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/uranium

/datum/smelting_recipe/metal
	name="Metal"
	ingredients=list(
		"iron"=1
	)
	yieldtype=/obj/item/stack/sheet/metal

/datum/smelting_recipe/plasteel
	name="Plasteel"
	ingredients=list(
		"iron"=1,
		"plasma"=1
	)
	yieldtype=/obj/item/stack/sheet/plasteel

/datum/smelting_recipe/clown
	name="Bananium"
	ingredients=list(
		"clown"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/clown

/datum/smelting_recipe/plasma_glass
	name="Plasma Glass"
	ingredients=list(
		"plasma"=1,
		"glass"=1
	)
	yieldtype=/obj/item/stack/sheet/glass/plasmaglass

/datum/smelting_recipe/plasma_rglass
	name="Reinforced Plasma Glass"
	ingredients=list(
		"plasma"=1,
		"glass"=1,
		"iron"=1
	)
	yieldtype=/obj/item/stack/sheet/glass/plasmarglass

/datum/smelting_recipe/phazon
	name="phazon"
	ingredients=list(
		"phazon"=1
	)
	yieldtype=/obj/item/stack/sheet/mineral/phazon
