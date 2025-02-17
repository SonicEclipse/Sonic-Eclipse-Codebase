var _y_direction = 0; var _x_direction = 0;
var _can_aerodash = false;
function player_state_aerodash(){
	//Authorize aerodash if on ground
	if(ground) _can_aerodash = true;
	
	//Trigger the aerodash
	if(press_a && character == CHAR_SONIC
		&& !ground && _can_aerodash && (state == ST_JUMP || state == ST_ROLL))
	{
		//Reset the spindash pitch
		audio_sound_pitch(sfx_spindash, 1);
		
		//Change animation
		animation_play(animator, ANIM_SPINDASH);
	
		//Reset variables
		spindash_rev = 0;
		spindash_pitch = 0;
		
		//Update the state
		state = ST_AERODASH;
		
		//Reset direction
		_x_direction = 0;
		_y_direction = 0;
	}
	
	//Stop executing if not aerodashing
	if(state != ST_AERODASH)
		exit;
	
	//Stop the movement
	ground_speed = 0;
	
	//Change flags
	direction_allow = 1 - ground;
	movement_allow = 1 - ground;
	attacking = true;
	
	//Change animation
	animation_play(animator, ANIM_SPINDASH);
	
	//Subtract the spindash rev
	spindash_rev -= spindash_rev / 32;
	spindash_pitch -= spindash_pitch / 28;
	
	//Change facing
	if (_x_direction != 0) facing = _x_direction;
	
	//Deactivate if on ground
	if(ground) {
		state = ST_NORMAL;
		ground_speed = (5+(floor(spindash_rev)/2)) * _x_direction;
		exit;
	}
	
	//Rev up!
	if(hold_a)
	{
		////Reset the spindash frame
		//if(animation_is_playing(animator, ANIM_SPINDASH))
		//{
		//	animation_set_frame(animator, 0);
		//}
		
		//Update spindash rev
		spindash_pitch = min(spindash_pitch + 1, 12);
		spindash_rev = min(spindash_rev + 2, 9);
		
		//Slow X and Y speed down
		x_speed *= 0.75;
		y_speed *= 0.75;
		
		//Change the spindash sound pitch
		if(spindash_pitch != 1) 
		{
			audio_sound_pitch(sfx_spindash, 1 + spindash_pitch / 13);
			
			//Play spindash sound
			play_sound(sfx_spindash);
		}
		
		//Figure out direction
		if(Input.LeftPress || (Input.Left && _x_direction != -1))
			_x_direction = -1;
		else if(Input.RightPress || (Input.Right && _x_direction != 1))
			_x_direction = 1;
		
		if(Input.UpPress || (Input.Up && _y_direction != -1))
			_y_direction = -1;
		else if(Input.DownPress || (Input.Down && _y_direction != 1))
			_y_direction = 1;
	}
	
	//Release the spindash
	if(!hold_a)
	{
		//Stop the spindash sound
		audio_stop_sound(sfx_spindash);
		
		//Play the release sound
		play_sound(sfx_release);
		
		//Lag the camera
		camera_set_lag(10 - spindash_rev);
		
		//Check direction
		if(!Input.Up && !Input.Down) _y_direction = 0;
		if(!Input.Left && !Input.Right) _x_direction = 0;
		if (_x_direction == 0 && _y_direction == 0) {
			state = ST_ROLL;
			exit;
		}
		
		//Set the ground speed, Y speed and update the state
		if(ground)
			ground_speed = (6.5+(floor(spindash_rev)/2)) * _x_direction;
		else x_speed = (6.5+(floor(spindash_rev)/2)) * _x_direction;
		if(_y_direction == -1) {
			if (_x_direction == 0) y_speed = -10;
			else y_speed = -7;
		}
		else if(_y_direction == 1) {
			if (_x_direction == 0) y_speed = 10;
			else y_speed = 7;
		}
		state = ST_ROLL;
		
		//Set aerodash flag to false
		_can_aerodash = false;
	}
}