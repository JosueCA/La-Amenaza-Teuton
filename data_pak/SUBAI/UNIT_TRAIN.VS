// void, Obj This

Unit this, u;
int maxlevel, idle_time;
int i;
 
maxlevel = EnvReadInt(This.player, "maxtrainlevel");
idle_time = 400;  
  
this = This.AsUnit();

.StartTraining();
while (!.Stop(1000));

//.pr("unit::train: started");
while(.health > .maxhealth/10 && .inherentlevel < maxlevel)
{
	u = .BestTrainingTarget();
	if(u.IsValid())
	{
		if (.IsEnemy(u))
			{
				UserNotification("cannot train", "", .posRH, .player);
				return; // break the training; enemy approaching
			}
		//.pr("unit::train: approaching train partner");
		if (.GotoAttack(u, 2000, true, -1)) 
		{
			//.pr("unit::train: we're there");
			for(i = 0; i < 3; i += 1)
			{
				//.pr("unit::train: training");
				if (!.TrainAttack(u))
					break; 
				if(.health <= .maxhealth/10)
					break; 
				if(.inherentlevel >= maxlevel)
					{
						.SetLevel(maxlevel);
						break;
					}
			}
		}
	} else 
	{
	  .Idle(idle_time);
	  if (idle_time < 2000) idle_time += 400;
	  if(!.BestTrainingTarget().IsValid())
		break;
	}
}
