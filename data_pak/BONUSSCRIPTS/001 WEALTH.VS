// void, Settlement set, int playerid
int GoldPerSec;
Sleep(100);

set.SetGold(set.gold + 1000);
GoldPerSec = 4;

while (1) {
  Sleep(1000);
	if (set.IsValid) {
		if (set.player == playerid)
			set.SetGold(set.gold + GoldPerSec);
	}
}

