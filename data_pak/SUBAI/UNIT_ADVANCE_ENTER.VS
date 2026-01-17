// void, Obj This,Obj bld

Unit this,u;
point pt;
Building building;
bool error;

this = This.AsUnit();
building = bld.AsBuilding();

if (!building.IsValid() || this.IsEnemy(building) || building.settlement.max_units==0)
  return;

.SetEntering(true);
if (!building.settlement.Units().Contains(this))
  {
    pt = building.GetEnterPoint(this);
	while (1) {
		u = .BestTargetInSquadSight().AsUnit();
		if(u.IsAlive())
		if(u.maxattack > 0)	
		{
			//pr("Best target found");
			while (u.IsAlive() && .IsValidTarget(u)) {
				//pr("Going to target");
				while(!.GotoAttack(u, 1500, true, -1)) {
					u = .BestTargetInSquadSight().AsUnit();
					if(!u.IsAlive() || !.IsValidTarget(u)) break;
				}
				//pr("attacking target");
				if (u.IsAlive() && .IsValidTarget(u))
				{
					while (.Attack(u)) if(!.IsVisible) .SetVisible(true);
				}
				u = .BestTargetInSquadSight().AsUnit();
			}
			continue;
		} 

		//pr("entering");
		if (.GotoEnter(pt, 0, 2000, true, 2500)) break;
		
	}

    //.pr("unit::enter: entering");
    building.settlement.AddUnit(this);
  }

