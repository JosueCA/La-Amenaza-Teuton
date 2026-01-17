// void, Settlement set
while (set.supplied.IsValid) {
  if (EnvReadString(set, "GOutpostSellFood") != "yes") { // not sellig food yet
//    if (set.gold >= 500) { // hardcoded cost, manual implementation
      //pr("GOutpist " + (SetToIdx(set) + 1) + ": starting food sell");
      EnvWriteString(set, "GOutpostSellFood", "yes");
//      set.SetGold(set.gold - 500);
//    }
    Sleep(500);  
    continue;
  }

  if (set.gold >= 100) { // send gold
    Wagon wagon; wagon = set.CreateMuleGold(set.gold);
    if (wagon.IsValid && set.supplied.IsValid) { //may have been taken during the sleep
	    wagon.AddCommand(false, "unload", set.supplied.GetCentralBuilding);
	    wagon.KillCommand();
    }
  }

  Sleep(2000);
}

