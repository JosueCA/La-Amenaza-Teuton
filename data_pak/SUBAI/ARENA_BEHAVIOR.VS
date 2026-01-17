//void, Obj This

Building this;
Unit newunit;
str class, groupname;
int number, maxnumber;
int level, i;
point ptExit;
Query qGroup;
this = This.AsBuilding();

while(1)
{
	class = EnvReadString(this, "Build");
	groupname = EnvReadString(this, "BuildGroup");
	number = EnvReadInt(this, "Build/" + class);
	maxnumber = EnvReadInt(this, "Build/" + class + "maxnumber");
	qGroup = Group("Player" + .player + groupname);
	.pr("left : " + number + " " + class + "; group :" + groupname);
	if(number == 0 || qGroup.GetObjList.count >= maxnumber)
	{
		if (class == "RLiberatus") {
			// update the best liberatus level for our player
			ObjList ol;
			int i, l, max_level;

			ol = qGroup.GetObjList();
			max_level = EnvReadInt(.player, "BestLiberatus");
			// find the max RLiberati level for the player
			for (i = 0; i < ol.count; i += 1) {
				l = ol[i].AsUnit().inherentlevel;
				if (l > max_level) max_level = l;
			}
			EnvWriteInt(.player, "BestLiberatus", max_level);
		}
		Sleep(2500);
	} else
	{
		groupname = EnvReadString(this, "BuildGroup");

		ptExit = .GetExitPoint( .settlement.GetCentralBuilding.pos, false );
		level = EnvReadInt(.settlement, "levels/" + class);

		// Shrine of Thor implementation
		if (EnvReadString(.settlement, "Shrine of Thor") == "researched" && 
			class == "GVikingLord"
		) {
			if (EnvReadInt(.player, "GVikingLordLevel") > level)
				level = EnvReadInt(.player, "GVikingLordLevel");
			EnvWriteInt(.settlement, "levels/GVikingLord", level + 2);
			EnvWriteInt(.player, "GVikingLordLevel", level + 2);
		}

		// Liberati guild implementation
		if (EnvReadString(.settlement, "Liberati guild") == "researched" && 
		  class == "RLiberatus" && number == 10
		) {
			level += 1;
			if (EnvReadInt(.player, "BestLiberatus") > level)
				level = EnvReadInt(.player, "BestLiberatus");
			EnvWriteInt(.settlement, "levels/RLiberatus", level);
		}

		if (ptExit.x==-1 && ptExit.y==-1) 
		{
			newunit = Place(class, Point(0,0), this.player);
			.settlement.AddUnit(newunit);
			newunit.AddToGroup("Player" + .player + groupname);
		} else 
		{
			newunit = Place(class, ptExit, this.player);
			newunit.SetCommand("enter", .settlement.GetCentralBuilding);
			newunit.AddToGroup("Player" + .player + groupname);
		}
		newunit.SetLevel(level);
		Sleep(1000);
		EnvWriteInt(this, "Build/" + class, number-1);
	}
}

