// void, Obj This

Unit newunit;
Barrack this;
point ptExit;
int level;

this = This.AsBuilding();
while(.settlement.IsFull)
	Sleep(500);
.Progress();
while(.settlement.IsFull)
	Sleep(500);
level = EnvReadInt(.settlement, "levels/Hero");

ptExit = .GetExitPoint(.settlement.GetCentralBuilding.pos, false);
if (ptExit.x==-1 && ptExit.y==-1) {
	newunit = Place(GetRandomHeroClass(cmdparam, .player), Point(0,0), this.player);
	newunit.SetLevel(level);
} else {
	newunit = Place(GetRandomHeroClass(cmdparam, .player), ptExit, this.player);
	newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
}
newunit.SetLevel(level);
