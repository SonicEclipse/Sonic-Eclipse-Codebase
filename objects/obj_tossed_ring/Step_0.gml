/// @description Script
    //Set in front of the player
    depth = obj_player.depth - 1;
	image_index = global.object_timer / 4;
	
	switch (thrown_state)
	{
		case 0: // Thrown
			x += x_speed;
			y += y_speed;
			
			if (!on_screen())
			{
				//show_message("Off Screen!")
				thrown_state = 1;
			}
			
			if (place_meeting(x, y, par_badnik)) {
				with (instance_nearest(x, y, par_badnik))
				{
					//Create battery ring
					if(global.use_battery_rings)
						instance_create_depth(x, y, depth, obj_battery_ring);
					else	//Create flickies instead
						instance_create_depth(x, y, depth, obj_flicky);
						
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
				
				//show_message("Badnik Hit!")
				thrown_state = 1;
			}
			
			var _monitor = instance_nearest(x, y, obj_monitor)
			if (place_meeting(x, y, obj_monitor) && !_monitor.destroyed)
			{
				with (_monitor)
				{
					destroyed = true;	
					ground = false;
					y_speed = -2 * sign(image_yscale);
					create_effect(x, y, spr_effect_explosion01, 0.3);
					play_sound(sfx_destroy);
					
					//Create icons
					var icon = instance_create_depth(x, y, depth, obj_monitor_icon);
					icon.monitor_type = monitor_type;
					icon.sprite_index = monitor_icon;
					icon.y_speed *= sign(image_yscale);	
				}
				
				//show_message("Monitor Hit!")
				thrown_state = 1;
			}
			
			//if (place_meeting(x, y, par_boss)) {
			//	with (instance_nearest(x, y, par_boss))
			//	{
			//		if (!been_hit && !cannot_hit) {
			//			hits++;
			//			invincible = true;
			//			been_hit = true;
			//			create_ringloss(2);
			//			play_sound(sfx_break2);
			//		}
			//	}
				
			//	//show_message("Boss Hit!")
			//	thrown_state = 1;
			//}
			
			if (collision_instance(0, 0, 0, true, true))
			{
				//show_message("Terrain Hit!")
				thrown_state = 1;
			}
		break;
		case 1: // Begin return
			x_speed *= -1;
			y_speed *= -1;
			
			x += x_speed;
			y += y_speed;
			
			thrown_state = 2;
		break;
		case 2: // Return
			
			timer++;
		
			//Collect
			if(player_collide_object(C_MAIN) && obj_player.state != ST_KNOCKOUT)
			{
				//Play the sound
				audio_stop_sound(sfx_ring);
				play_sound(sfx_ring, false);
				
			    //Add rings!
				global.rings++;
			    
			    //Create the effect
			    create_effect(x, y, spr_ring_sparkle, 0.2);
			    
			    //Destroy the ring
			    instance_destroy();
			}
			
			// Return to Player
			//when i steal from the physics guide (:exploding_head:)
			var ringacceleration = [0.75, 0.1875];
			
			//relative positions
			var signx = sign(obj_player.x - x);
			var signy = sign(obj_player.y - y);
			
			//check relative movement
			var arrayx = (sign(x_speed) == signx);
			var arrayy = (sign(y_speed) == signy);
			
			x += x_speed;
			y += y_speed;
			
			//add to speed
			x_speed += (ringacceleration[arrayx] * signx);
			y_speed += (ringacceleration[arrayy] * signy);
		break;
	}