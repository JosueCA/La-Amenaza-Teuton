// void, Obj This

Flying this;
Query crows, bad_scary_giants, strangely_shaped_rocks;
ObjList ol;
point ptDir, ptLand;
int iters, behavior, targetz, z, i;
bool fly;
Obj bird;

this = This.AsFlying();
crows = ObjsInRange(this, "Crow", 900);
bad_scary_giants = ObjsInRange(this, "Unit", 550);
strangely_shaped_rocks = ObjsInRange(this, "Building", 550);

Sleep(rand(2000));
while (1) {
	
	if (!.IsInAir())
		{
			iters = 0;
			fly = false;
			while (1) {
				iters+=1;
				.Idle(1300);

				ol = crows.GetObjList();
				for (i = 0; i<ol.count; i+=1)
					{
						if (ol[i].AsFlying().IsInAir())
							{
								if (ol[i].AsFlying().user==1)
									{ fly = false; break; }
								fly = true;
							}
					}
				if (fly) break;
				if (iters>30 && rand(15)==1) break;
				if (!bad_scary_giants.IsEmpty()) 
					{ /*.pr("Too scared - we will fly"+GetTime()+" an "+bad_scary_giants.GetObjList()[0].class+" found.");*/ break; }
			}
		}

	// Decide what to do while flying
	bird.Clear();
	if (crows.count==0) // Looking for a friend
		bird = .FindNearBird();

	targetz = 260+rand(100);
	if (bird.IsValid())
		{
			ptDir = bird.pos - .pos;
			ptDir.SetLen(100);
			.PlayAnim(16, .pos+ptDir, 80+GetTerrainHeight(.pos));
			behavior = 0;
		}
	else
		{
			.PlayAnim(16, .PickFlyingPoint(120), 80+GetTerrainHeight(.pos));
			behavior = (GetTime()/10000) % 6; // Use the game time as a synced seed
			if (rand(5)==1) // Probability to immediately land
				{ .SetUser(1); targetz = 0; }
		}

	iters = 0;
	if (behavior==0)
		iters = 30;
	while (1) {
		iters+=1;

		ptDir = .GetDir();
		if (behavior == 0)
			if (rand(3)==1 && crows.count!=0)  // Go straight ahead
				ptDir = crows.GetAverageDirection();
			else
				ptDir.Rot(rand(10)-5);
		else if (behavior == 3)
			ptDir.Rot(-15-rand(15)); // Go round in a circle
		else
			ptDir.Rot(15+rand(15)); // Go round in the opposite direction
		ptDir.SetLen(75);
		
		z = .z;
		if (z<targetz)
			z += 15+rand(8);
		else if (z>targetz+25)
			z -= 15+rand(8);
		if (z<GetTerrainHeight(.pos+ptDir)+30) // We're too low
			z += 25;
		
		.AdjustFlyDir(ptDir);
		.PlayAnim(0, .pos+ptDir, z);

		if (.user==1 && z - GetTerrainHeight(.pos)<=60)
			if (strangely_shaped_rocks.IsEmpty())
				if (bad_scary_giants.IsEmpty())
					{
						ptLand = .PickLandingPoint(120);
						if (ptLand.x>=0)
							break;
					}

		if (bad_scary_giants.IsEmpty())
			if (strangely_shaped_rocks.IsEmpty())
				{
					ol = crows.GetObjList();
					for (i = 0; i<ol.count; i+=1)
						if (ol[i].AsFlying().user == 1)
							{ .SetUser(1); targetz = 0; }
					if (iters>40)
						if (rand(25)==17 || iters>160)
							{ .SetUser(1); targetz = 0; }
				}
			else
				if (z<GetTerrainHeight(.pos)+200)
					z += 40;
		if (iters>80 && (GetTime()/5000)%3==1)
			{ behavior = 0; /*.pr("Cannot land - flying straigh ahead");*/ }
	}

	// Now land carefully
	.PlayAnim(17, ptLand, -1);
	.PlayAnim(18, .pos, -1); // Transition to idle
	.SetUser(0);
}
