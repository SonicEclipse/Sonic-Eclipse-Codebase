function player_action_ringtoss(){
	if (global.character != CHAR_TAILS) exit;
	if !(state == ST_NORMAL || state == ST_JUMP || state == ST_TAILSFLY) exit;
	if (global.rings == 0) exit;
	
	if (instance_exists(obj_tossed_ring))
	{
		for (var i = 0; i < instance_number(obj_tossed_ring); ++i;)
		{
			var _existing_tossed_ring = instance_find(obj_tossed_ring,i);
			if (_existing_tossed_ring.thrown_state != 2)
			{
				exit;
			}
		}
	}
	
	
	if (press_c) 
	{
		var _tossed_ring = instance_create_depth(x, y, depth, obj_tossed_ring);
		with (_tossed_ring)
		{
			x_speed = 8 * other.facing;
		}
		global.rings--;
	}
}