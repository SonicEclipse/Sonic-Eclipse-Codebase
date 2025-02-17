/// @description Values
	surface = surface_create(global.window_width, global.window_height);
	timer = 0;
	state = 0;
	total_bonus = 0;
	
	//HUD Offsets
	for(var i = 0; i <= 3; i++)
		offset_x[i] = global.window_width;
	
	//Bonus
	get_end_results();
	
	//Setup Variables for syncing to Tally jingle
	tally_time_allot = 6.134 * 60 - 200;
	interval = max(time_bonus div tally_time_allot, ring_bonus div tally_time_allot);
	t_interval = interval;
	r_interval = interval;