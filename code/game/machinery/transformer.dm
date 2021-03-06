/obj/machinery/transformer
	name = "Automatic Robotic Factory 5000"
	desc = "A large metalic machine with an entrance and an exit. A sign on the side reads, 'human go in, robot come out', human must be lying down and alive. Has to cooldown between each use."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "separator-AO1"
	layer = MOB_LAYER+1 // Overhead
	anchored = 1
	density = 1
	var/transform_dead = 0
	var/transform_standing = 0
	var/cooldown_duration = 900 // 1.5 minutes
	var/cooldown = 0
	var/robot_cell_charge = 5000
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 5000

/obj/machinery/transformer/New()
	// On us
	..()
	new /obj/machinery/conveyor/auto(loc, WEST)

/obj/machinery/transformer/power_change()
	..()
	update_icon()

/obj/machinery/transformer/update_icon()
	..()
	if(stat & (BROKEN|NOPOWER) || cooldown == 1)
		icon_state = "separator-AO0"
	else
		icon_state = initial(icon_state)

/obj/machinery/transformer/Bumped(var/atom/movable/AM)

	if(cooldown == 1)
		return

	// HasEntered didn't like people lying down.
	if(ishuman(AM))
		// Only humans can enter from the west side, while lying down.
		var/move_dir = get_dir(loc, AM.loc)
		var/mob/living/carbon/human/H = AM
		if((transform_standing || H.lying) && move_dir == EAST)// || move_dir == WEST)
			AM.loc = src.loc
			do_transform(AM)
	//Shit bugs out if theres too many items on the enter side conveyer
	else if(istype(AM, /obj/item))
		var/move_dir = get_dir(loc, AM.loc)
		if(move_dir == EAST)
			AM.loc = src.loc

/obj/machinery/transformer/proc/do_transform(var/mob/living/carbon/human/H)
	if(stat & (BROKEN|NOPOWER))
		return
	if(cooldown == 1)
		return

	if(!transform_dead && H.stat == DEAD)
		playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 50, 0)
		return

	playsound(get_turf(src), 'sound/items/Welder.ogg', 50, 1)
	H.emote("scream") // It is painful
	H.adjustBruteLoss(max(0, 80 - H.getBruteLoss())) // Hurt the human, don't try to kill them though.
	H.handle_regular_hud_updates() // Make sure they see the pain.

	// Sleep for a couple of ticks to allow the human to see the pain
	sleep(5)

	var/mob/living/silicon/robot/R = H.Robotize(1) // Delete the items or they'll all pile up in a single tile and lag
	if(R)
		R.cell.maxcharge = robot_cell_charge
		R.cell.charge = robot_cell_charge

	 	// So he can't jump out the gate right away.
		R.weakened = 5
	spawn(50)
		playsound(get_turf(src), 'sound/machines/ping.ogg', 50, 0)
		if(R)
			R.weakened = 0

	// Activate the cooldown
	cooldown = 1
	update_icon()
	spawn(cooldown_duration)
		cooldown = 0
		update_icon()

/obj/machinery/transformer/conveyor/New()
	..()
	var/turf/T = loc
	if(T)
		// Spawn Conveyour Belts

		//East
		var/turf/east = locate(T.x + 1, T.y, T.z)
		if(istype(east, /turf/simulated/floor))
			new /obj/machinery/conveyor/auto(east, WEST)

		// West
		var/turf/west = locate(T.x - 1, T.y, T.z)
		if(istype(west, /turf/simulated/floor))
			new /obj/machinery/conveyor/auto(west, WEST)