// void, Settlement set
Settlement Dest; Dest = set.BestToSupply();

if (Dest.IsValid) {
  Wagon wagon; wagon = set.CreateMuleGold(set.gold);
  if (wagon.IsValid) {
	  wagon.AddCommand(false, "unload", Dest.GetCentralBuilding);
	  wagon.KillCommand();
  }
}
