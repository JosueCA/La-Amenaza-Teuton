// void, Settlement set

// ============================================================================
// TRAINPEASANT DESACTIVADO - Los campesinos se envian automaticamente en VILLAGE_IDLE.VS
// ============================================================================

int idPlayer;
Building cb;
//int min_pop, pop_group;
//str strCmd;
//point ptDummy;
//Obj objDummy;

idPlayer = set.player;
cb = set.GetCentralBuilding;
//min_pop = GetConst("MinPopulation");
//pop_group = GetConst("PopGroup");
//if (set.IsGaulVillage)
//	strCmd = "trainpeasantg";
//else
//	strCmd = "trainpeasantr";

/// RestartEconomyScript is for debug purpose only -> it stops the current script and starts the new one.
/// -> EnvWriteInt(sels, "RestartEconomyScript", 1)

while (set.player == idPlayer)
{
	Settlement DestStronghold;
	bool bIdle;
	//bool bCanDrain;

	bIdle = cb.command == "idle";
	//bCanDrain = bIdle && set.population - pop_group >= min_pop;
	//if (bCanDrain)
	//if (AIVar(idPlayer, AIV_VillageDrain) == 0)
	//if (set.population < set.max_population)
	//	bCanDrain = false;

	/// by dafault produced food go to stronghold
	DestStronghold = set.BestToSupply(); /// the return value is always stronghold
	if (DestStronghold.IsValid)
	{
		if (bIdle)
			set.StartSupplyFood(DestStronghold);
		EnvWriteInt(set, "SupplyStronghold", cb.DistTo(DestStronghold.GetCentralBuilding));
	} else {
		set.StopSupply();
		//bCanDrain = false;
	}

	/// drain peasants to stronghold (DESACTIVADO)
	//if (bCanDrain)
	//{
	//	bool bDrain = false;
	//	if (set.population >= set.max_population)
	//		bDrain = true;
	//	if (!bDrain)
	//	{
	//		int nThreshold = 60;
	//		int nSFood, nSPop, nVPop, nVDist, nS, nV, nSendPop;
	//		int i, nMin, nMax, nMaxFood;
	//		nMaxFood = MilUnits(idPlayer) * 20;
	//		i = Strongholds(idPlayer);
	//		if (i > 1) nMaxFood = nMaxFood / i;
	//		if (nMaxFood < 300) nMaxFood = 300;
	//		nSFood = 100 * DestStronghold.food / nMaxFood;
	//		if (nSFood > 100) nSFood = 100;
	//
	//		nSPop = 100 * DestStronghold.population / DestStronghold.max_population;
	//		nVPop = 100 * set.population / set.max_population;
	//		i = GetMapRect.width;
	//		if (i < GetMapRect.height)
	//			i = GetMapRect.height;
	//		nVDist = 100 * cb.DistTo(DestStronghold.GetCentralBuilding) / i;
	//
	//		nS = nSFood - nSPop;
	//		nV = (nThreshold - nVDist) - nVPop/2;
	//		if (nS >= nV)
	//			bDrain = true;
	//
	//		nMax = (nThreshold - nVDist) - (1000 / set.max_population) / 2;
	//		nMin = (nThreshold - nVDist) - 100 / 2;
	//
	//		i = (nThreshold - nVDist - nS) * 2;
	//		i = i * set.max_population / 100;
	//		/// to see stats from the game write -> pr(EnvReadString(sels, "sendpop"))
	//		EnvWriteString(set, "sendpop",
	//			"     Stronghold pop/food weight: " + nS + " (Food=" + nSFood + "%, Pop=" + nSPop + "%),\n" +
	//			"     Village pop/food weight [" + nMin + ".." + nMax + "]: " + nV + " (pop=" + nVPop + "%, dist=" + nVDist + "%)\n" +
	//			"     Ballance: village sends pop when it is " + i);
	//	}
	//	bCanDrain = bDrain;
	//}
	//// drain
	//if (bCanDrain)
	//	cb.ExecCmd(strCmd, ptDummy, objDummy, false);

	Sleep(AIVar(idPlayer, AIV_Sleep_ES));
}

EnvWriteInt(set, "RestartEconomyScript", 0);
