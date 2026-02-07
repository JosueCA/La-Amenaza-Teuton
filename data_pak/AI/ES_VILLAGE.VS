// void, Settlement set

int idPlayer;
Building cb;

idPlayer = set.player;
cb = set.GetCentralBuilding;

while (set.player == idPlayer)
{
	Settlement DestStronghold;
	bool bIdle;

	bIdle = cb.command == "idle";

	/// by dafault produced food go to stronghold
	DestStronghold = set.BestToSupply(); /// the return value is always stronghold
	if (DestStronghold.IsValid)
	{
		if (bIdle)
			set.StartSupplyFood(DestStronghold);
		EnvWriteInt(set, "SupplyStronghold", cb.DistTo(DestStronghold.GetCentralBuilding));
	} else {
		set.StopSupply();
	}

	Sleep(AIVar(idPlayer, AIV_Sleep_ES));
}
