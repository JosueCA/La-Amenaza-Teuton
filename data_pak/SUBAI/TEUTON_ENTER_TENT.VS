// void, Obj This,Obj bld

/*
As the teuton tents cannot be "enter"-ed  the behaviour script uses THIS command 
*/


Unit this;
point pt;   
Building building;
bool error;
           
this = This.AsUnit();
building = bld.AsBuilding();

if (!building.IsValid() ||
    (this.IsEnemy(building) && !building.AsTeleport().IsValid()))
  return;

.SetEntering(true);
if (!building.settlement.Units().Contains(this))
  {
    pt = building.GetEnterPoint(this);
    while(!.GotoEnter(pt, 0, 1000, true, 5000));
    building.settlement.ForceAddUnit(this);
  }
	
