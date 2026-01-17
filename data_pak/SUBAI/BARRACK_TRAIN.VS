// void, Obj This

Unit newunit;
Barrack this;
point ptExit, ptEnter;
int perc, level, maxtrainlevel;
Query qEnemies;
bool bTemple;

this = This.AsBarrack();
qEnemies = Intersect(ObjsInSight(.settlement.GetCentralBuilding(),"Object"),EnemyObjs(.player(),"Object"));
bTemple = .IsHeirOf("RTemple") || .IsHeirOf("GDruidHouse");

perc = 100 - EnvReadInt(.settlement, "BarrackTrainTimeDecrease");
if (bTemple) perc = 100;
.Progress((.cmddelay * perc) / 100);

// Check for unit-specific level first (from Steel Weapons, Import horses, etc.)
level = EnvReadInt(.settlement, "levels/" + cmdparam);

// If no specific level, use maxtrainlevel from Training research (player-wide)
if (level == 0) {
	maxtrainlevel = EnvReadInt(.player, "maxtrainlevel");
	if (maxtrainlevel > 0)
		level = maxtrainlevel;
}

ptExit = .GetExitPoint(.settlement.GetCentralBuilding.pos, false);
if (ptExit.x==-1 && ptExit.y==-1) {
	newunit = Place(cmdparam, Point(0,0), this.player);
	.settlement.AddUnit(newunit);
} else {
	newunit = Place(cmdparam, ptExit, this.player);
	if (qEnemies.IsEmpty())
		newunit.SetCommand("enter", .settlement.GetCentralBuilding);
	else
		newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
}
newunit.SetLevel(level);

if (!bTemple) {
	if (EnvReadInt(.settlement, "items/Bear teeth amulet") == 1)
		newunit.AddItem("Bear teeth amulet");
	if (EnvReadInt(.settlement, "items/Herb amulet of luck") == 1)
		newunit.AddItem("Herb amulet of luck");
	if (EnvReadInt(.settlement, "items/Belt of might") == 1)
		newunit.AddItem("Belt of might");
}
