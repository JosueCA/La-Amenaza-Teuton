// void, Obj This,Obj bld

Unit this;
point pt;   
Building building;
bool error;
           
this = This.AsUnit();

building = bld.AsBuilding();

.SetEntering(true);
pt = building.GetEnterPoint(this);
//.pr("unit::enter: going");
while(!.GotoEnter(pt, 0, 1000, false, 0));

//.pr("unit::enter: entering");
if(building.IsValid())
{
	building.settlement.AddUnit(this);
}