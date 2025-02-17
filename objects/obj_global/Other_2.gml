/// @description Set the value
	
	//Dev stuff
	global.dev_mode = true;					//Flag for developer mode, which allows you to use dev commands, don't forget to turn this off when releasing the game
	
	//Character globals
	global.character = CHAR_SONIC;			//Global value for the character
	
	//Screen values
	global.window_width  = 426;				//Window's horizontal size
	global.window_height = 240;				//Window's vertical size
	
	//Read from save data
	ini_open("data.ini");
		global.window_size = ini_read_real("global", "window_size", 3);
		global.window_fullscreen = ini_read_real("global", "fullscreen", 0);
	ini_close();
	
	//keyboard inputs
	global.up = vk_up;						
    global.down = vk_down;
    global.left = vk_left;
    global.right = vk_right;
    global.a = ord("A");
    global.b = ord("S");
    global.c = ord("D");
    global.start = vk_enter;
	
	//Setup volume
	global.bgm_volume = 1;					//Music's channel volume
	global.sfx_volume = 1;					//Sound effects volume
	
	//Checkpoint values
	global.checkpoint = ds_list_create();	//The list of active checkpoints
	global.checkpoint_id = noone;			//Checkpoint that is currently active
	global.time_store = 0;					//Store value for timer when checkpoint gets active
	
	//Stage values
	global.object_timer = 0;				//Object pre frame timer, every 60 frames in a 1 second
	global.score = 0;						//Global variable for score
	global.stage_timer = 0;					//Global variable for stage timer
	global.rings = 0;						//Global variable for rings
	global.life = 3;						//Global variable for life
	global.title_card = true;				//Flag that allows title card to be triggered, used in dev
	global.emeralds = [false, false, false, false, false, false, false];				//List of active emeralds
	global.col_tile = ["CollisionMain", "CollisionSemi", "CollisionA", "CollisionB"];	//List of collision layers
	
	//Act transition variables
	global.monitor_store = [];				//List of monitor instances that were bumped with sign
	global.monitor_id = 0;					//Current list ID of bumped monitor
	global.act_transition = false;			//Act transition trigger, this is active for a single frame when new act starts
	
	//Extra life stuff
	global.score_extralife = 100000;		//Score threshold for extra life
	global.ring_extralife = 100;			//Ring threshold for extra life
	
	//Customizables variables
	global.rotation_type = 0;				//This changes player's visual rotation 
	global.use_battery_rings = true;		//If this is disabled, destroying enemies will spawn flickies instead
	global.chaotix_monitors = false;		//Changes monitor icons to be like chaotix, monitor icon spins and it turns into dust
	global.use_peelout = true;				//Flag that allows peel-out ability
	global.use_dropdash = true;				//Flag that allows dropdash ability
	global.use_airroll = true;				//Flag that allows rolling while air-borne
	global.chaotix_dust_effect = false;		//Flag that disables classic spindash/skid dust effect
	global.camera_type = 1;					//Vertical camera scrolling type, 0 = Megadrive, 1 = Mania
	global.knux_camera_smooth = true;		//Flag for using smooth ledge climb camera movement
	global.extended_camera = true;			//Flag for Sonic CD-type extended camera
	
	//Font setup:
	global.hud_number = font_add_sprite(spr_hud_numbers, ord("0"), false, 0);
	global.text_font = font_add_sprite_ext(spr_hud_font, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", false, 0);
	global.font_small = font_add_sprite_ext(fontDebug, " ! #$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ", false, 0);
	global.text_random = font_add_sprite_ext(spr_font_random, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.:-!", true, 1);
	
	//Additional variables
	global.recording_gif = false;			//Status of GIF recorder
	
	//Create controllers:
	instance_create_depth(0, 0, 0, obj_window);
	instance_create_depth(0, 0, 0, obj_input);
	instance_create_depth(0, 0, 0, obj_music);
	instance_create_depth(0, 0, -100, obj_fade);
	
	//Controllers for dev mode
	if(global.dev_mode) {
		instance_create_depth(0, 0, 0, obj_dev);
		instance_create_depth(0, 0, 0, obj_shell);
	}
	
	//Custom crash handler made by PM13
	exception_unhandled_handler(function(ex) {
	    show_debug_message("--------------------------------------------------------------");
	    show_debug_message("                   < ! >   < ! >   < ! >                      ");
	    show_debug_message("--------------------------------------------------------------");
	    show_debug_message("Unhandled exception " + string(ex));
	    show_debug_message("--------------------------------------------------------------");
	    show_debug_message("                   < ! >   < ! >   < ! >                      ");
	    show_debug_message("--------------------------------------------------------------");
	    if (file_exists("crash.txt")) file_delete("crash.txt");
	    var _f = file_text_open_write("crash.txt");
	    file_text_write_string(_f, string(ex));
	    file_text_close(_f);
		randomize();
		var _error_start = choose("Whoopsie Daisy! Sonic Eclipse has fallen into one of Dr. Robotnik's Diabolical Traps and has to eXit.\nSorry for the inconvenience!",
							"Well, that was uneXpected. Sonic Eclipse has fallen into one of Dr. Robotnik's Diabolical Traps and has to close.\nSorry for the inconvenience!",
							"Uh oh! It broke! That was uneXpected.\nThe game must now close. Sorry!",
							"We're eXtremely sorry! Looks like the game encountered a fatal error.");
		var _error_string = _error_start + "\n\nIf you would like to help, please send \"crash.txt\" to the developers."
		
	    show_message(_error_string);
	    return 0;
	});
	
	//Initialize the music list
	init_music_list();
	
	//Macros:
	#macro Input obj_input
	#macro WINDOW_WIDTH global.window_width
	#macro WINDOW_HEIGHT global.window_height
	#macro OBJECT_TIMER global.object_timer
	
	//Set fullscreen if needed
	window_set_fullscreen(global.window_fullscreen);
	
	//Ending event:
	room_goto_next();
