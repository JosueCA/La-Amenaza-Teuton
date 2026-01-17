// void, Obj This, Obj bld

Hero this;
Building building;
point pt;

this = This.AsHero;
building = bld.AsBuilding;
//.pr("Hero::enter");

if (!.IsValid)
	return;
if (!building.IsValid)
	return;
if (building.IsHeirOf("Catapult"))
	return;
if (.IsEnemy(building))
if (!building.IsHeirOf("BaseRuins"))
	return;

.SetEntering(true);

if (!building.settlement.Units.Contains(this))
{
	pt = building.GetEnterPoint(this);
	.FormSetupAndMoveTo (pt, 0, 0, false);
	while (.HasPath && building.IsAlive)
	{
		if (.FormPathLeft < .FormRadius  + 150)
			break;
		if (.DistTo(building) < .FormRadius)
			break;
		.FormKeepMoving (500);
	}
	if (!building.IsAlive)
	{
		.army.SetCommand("idle");
		.Stop(10000);
		return;
	}
	if (!building.IsHeirOf("BaseRuins"))
		.army.SetCommand("enter", building);
	else
		.army.SetCommand("idle");
	while(!.GotoEnter(pt, 0, 1000, false, 2500));

	if (!building.IsValid || (.IsEnemy(building) && !building.IsHeirOf("BaseRuins")))
		{ .Stop(10000); .SetEntering(false); return; }

	building.settlement.AddUnit(this);
	if (building.IsHeirOf("BaseRuins"))
		.AddCommand(true, "sleep");
}
else
	if (!building.IsHeirOf("BaseRuins"))
		.army.SetCommand("enter", building);
	else
		.army.SetCommand("idle");


.SetEntering(false);
