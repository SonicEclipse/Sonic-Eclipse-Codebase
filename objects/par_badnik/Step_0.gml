/// @description Parent script
	
	//Destroy the enemy
	if(player_collide_object(C_MAIN))
	{
		if(obj_player.attacking || obj_player.invincible)
		{
			badnik_destroy();
		}else
		{
			//Player getting hurt
			player_hurt();
		}
	}