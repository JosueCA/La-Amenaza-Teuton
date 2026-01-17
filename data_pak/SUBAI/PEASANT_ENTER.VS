// void, Obj This,Obj bld

Unit this;
point pt;
Building building;
bool error;
Settlement set;

this = This.AsUnit();
building = bld.AsBuilding();


if (!building.IsValid() || this.IsEnemy(building))
  return;

if( building.IsHeirOf("BaseRuins")) return;

set = building.settlement;
if (!set.IsValid()) return;

.SetEntering(true);																
if (!set.Units().Contains(this))
  {

    pt = building.GetEnterPoint(this);
    //.pr("unit::enter: going");
    while(!.GotoEnter(pt, 0, 1000, true, 5000));

    //.pr("unit::enter: entering");
    if (set.max_population==0) {
    	if (set.max_units != 0)
    		set.AddUnit(this);
    	else
    		pr("peasant_enter: both max_population and max_units are 0 for this settlement");
    } else {
    	set.AddToPopulation(1);
		.Erase();
	}
  }

