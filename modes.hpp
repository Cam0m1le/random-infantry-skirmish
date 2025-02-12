class RSTF_Modes
{
	class Classic
	{
		title = "Classic";
		description = "Score-based team deathmatch, where first one that reaches specific number of points wins.";
		enabled = 1;
		order = 4;

		init = "RSTF_MODE_CLASSIC_init";
		startLoop = "RSTF_MODE_CLASSIC_startLoop";
		unitKilled = "RSTF_MODE_CLASSIC_unitKilled";
		taskCompleted = "RSTF_MODE_CLASSIC_taskCompleted";
		vehicleKilled = "RSTF_MODE_CLASSIC_vehicleKilled";
	};

	class KOTH
	{
		title = "King of the Hill";
		description = "Side with more units in the predefined capture point receives points, side which reaches specified number of points wins.";
		enabled = 1;
		order = 2;

		init = "RSTF_MODE_KOTH_init";
		startLoop = "RSTF_MODE_KOTH_startLoop";
		unitKilled = "RSTF_MODE_KOTH_unitKilled";
		taskCompleted = "RSTF_MODE_KOTH_taskCompleted";
		vehicleKilled = "RSTF_MODE_KOTH_vehicleKilled";
	};

	class Push
	{
		title = "Push - Attack";
		description = "Capture a series of fortified points.";
		enabled = 1;
		order = 0;

		init = "RSTF_MODE_PUSH_init";
		startLoop = "RSTF_MODE_PUSH_startLoop";
		unitKilled = "RSTF_MODE_PUSH_unitKilled";
		taskCompleted = "RSTF_MODE_PUSH_taskCompleted";
		vehicleKilled = "RSTF_MODE_PUSH_vehicleKilled";
	};

	class PushDefense
	{
		title = "Push - Defense";
		description = "Defend a series of fortified points.";
		enabled = 1;
		order = 1;

		init = "RSTF_MODE_PUSH_initDefense";
		startLoop = "RSTF_MODE_PUSH_startLoop";
		unitKilled = "RSTF_MODE_PUSH_unitKilled";
		taskCompleted = "RSTF_MODE_PUSH_taskCompleted";
		vehicleKilled = "RSTF_MODE_PUSH_vehicleKilled";
	};

	class Defense
	{
		title = "Defense - BETA";
		description = "Hold area for predefined amount of time agains never ending waves of enemies. This game mode is in BETA stage and could be unablanced.";
		enabled = 1;
		order = 3;

		init = "RSTF_MODE_DEFEND_init";
		startLoop = "RSTF_MODE_DEFEND_startLoop";
		unitKilled = "RSTF_MODE_DEFEND_unitKilled";
		taskCompleted = "RSTF_MODE_DEFEND_taskCompleted";
		vehicleKilled = "RSTF_MODE_DEFEND_vehicleKilled";
	};
};
