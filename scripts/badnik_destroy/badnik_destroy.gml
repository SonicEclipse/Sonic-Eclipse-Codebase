function badnik_destroy()
{
	//Create battery ring
	if(global.use_battery_rings)
		instance_create_depth(x, y, depth, obj_battery_ring);
	else	//Create flickies instead
		instance_create_depth(x, y, depth, obj_flicky);
		
	//Player bounce
	obj_player.y_speed = -abs(obj_player.y_speed);
		
	//Create score object and add combo and badnik chain
	obj_level.badnik_chain += 1;
	create_score();
		
	//Create explosion effect
	create_effect(x, y, spr_effect_explosion01, 0.3);
	
	//Create debris
	create_debris(x, y, spr_inv_sparkle, 0.3, -4, -5.5, 0, 0.4);
	create_debris(x, y, spr_inv_sparkle, 0.3, 4, -5.5, 0, 0.4);
		
	//Play destroying sound
	play_sound(sfx_destroy);
		
	//Destroy badnik
	instance_destroy();		
}