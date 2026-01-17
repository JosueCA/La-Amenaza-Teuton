// void, Settlement set, int playerid

str ItemName;
Sleep(100);

ItemName = "Finger of death";
while (1) {
	Sleep(500);
	if (set.player == playerid) {
		int i;
		ObjList units;

		units = set.Units;
		for (i = 0; i < units.count; i += 1)
		if (units[i].AsHero())
			if (units[i].AsHero().AddItem(ItemName))
				return;
	}
}

