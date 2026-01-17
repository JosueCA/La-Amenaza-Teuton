// void, Obj This,Obj bld

Unit this;
point pt;   
Building building;
bool error;
bool bEnterCatapult;

this = This.AsUnit();
building = bld.AsBuilding();

if (!building.IsValid() ||
    (this.IsEnemy(building) && !building.AsTeleport().IsValid()) ||
    building.settlement.max_units==0)
  return;

if( ! .AsHero.IsValid && building.IsHeirOf("BaseRuins")) return;

bEnterCatapult = building.IsHeirOf( "Catapult" );

if( ! bEnterCatapult ) .SetEntering(true);

if (!building.settlement.Units().Contains(this))
{
    pt = building.GetEnterPoint(this);
    //.pr("unit::enter: going");
	if( bEnterCatapult )
	{
		while(!.Goto(pt, 0, 1000, true, 5000));
	}
	else
	{
	    while(!.GotoEnter(pt, 0, 1000, true, 5000));
	}

    //.pr("unit::enter: entering");
	{	bool bStop=false;
		if (building.IsDead()) {
			bStop =true;
		} else if ( (this.IsEnemy(building) && !building.AsTeleport().IsValid()) ||
					building.settlement.max_units==0) {
			bStop = true;
		}
		if (bStop) {
			.Stop(10000); 
			.SetEntering(false); 
			return;
		}
	}
	building.settlement.AddUnit(this);
}

if( ! bEnterCatapult ) .SetEntering(false);
