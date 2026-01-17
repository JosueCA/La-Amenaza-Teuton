// void, Settlement set
int idPlayer, gold, i, l;
Settlement base;
ObjList ol;
bool bAttacked;

idPlayer = set.player;
base = NearestStronghold(set.GetCentralBuilding.pos, idPlayer);

EnvWriteInt(idPlayer, "GoldTradeStartInProgress", 1);
set.StopSupply();

// Preparation phase - get gold needed from the closest stronghold
while (set.gold<2000)
{
  // Calculate gold in mules and attack status
  gold = 0;
  bAttacked = false;
  ol = Group("GoldMules"+idPlayer).GetObjList();
  for (i = 0; i<ol.count; i+=1)
    {
      gold += ol[i].AsWagon().amount;
      if (ol[i].health<ol[i].maxhealth*2/3)
        bAttacked = true;
    }

  if (bAttacked) 
		Sleep(20000); // Don't send more gold if a mule is attacked
	else
		if (gold+set.gold<2000) if (base.gold>=250)
			{
				Wagon wagon; wagon = base.CreateMuleGold(250);
				if (wagon.IsValid) {
					wagon.AddCommand(false, "unload", set.GetCentralBuilding);
					wagon.KillCommand();
					wagon.AddToGroup("GoldMules"+idPlayer);
				}
			}

  Sleep(1000);

  if (set.player != idPlayer || base.player != idPlayer) 
    {
			if (base.player == idPlayer)
				Group("GoldMules"+idPlayer).SetCommand("unload", base.GetCentralBuilding);
			Group("GoldMules"+idPlayer).RemoveFromAllGroups();
      EnvWriteInt(idPlayer, "GoldTradeStartInProgress", 0);
      return;
    }
}

Group("GoldMules"+idPlayer).RemoveFromAllGroups();
EnvWriteInt(idPlayer, "GoldTradeStartInProgress", 0);
EnvWriteInt(idPlayer, "GoldTradeOutposts", EnvReadInt(idPlayer, "GoldTradeOutposts")+1);
set.StartSupplyFood(base);

// Selling phase - only look if the outpost is under attack
l = set.loyalty;
while (set.player == idPlayer)
{
  Sleep(2000);

	if (base.player != idPlayer)
		{
			set.StopSupply;
			base = NearestStronghold(set.GetCentralBuilding.pos, idPlayer, AI_ALLY);
			if (!base.IsValid()) return; //just leave the gold where it is
			while (set.gold>=250)
				{
					Wagon wagon; wagon = set.CreateMuleGold(250);
					if (wagon.IsValid) {
						wagon.AddCommand(false, "unload", base.GetCentralBuilding);
						wagon.KillCommand();
					}
					Sleep(1000);
				}
			EnvWriteInt(idPlayer, "GoldTradeOutposts", EnvReadInt(idPlayer, "GoldTradeOutposts")-1);
			return;
		}
	else
		{
			set.StartSupplyFood(base);
			// Get gold back if attacked
			if (set.loyalty<l) if (set.loyalty<50)
				{
					while (set.gold>=250)
						{
							Wagon wagon; wagon = set.CreateMuleGold(250);
							if (wagon.IsValid) {
								wagon.AddCommand(false, "unload", base.GetCentralBuilding);
								wagon.KillCommand();
							}
							Sleep(1000);
						}
					EnvWriteInt(idPlayer, "GoldTradeOutposts", EnvReadInt(idPlayer, "GoldTradeOutposts")-1);
					return;
				}
		}
	l = set.loyalty;
}

EnvWriteInt(idPlayer, "GoldTradeOutposts", EnvReadInt(idPlayer, "GoldTradeOutposts")-1);
