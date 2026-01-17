// void, Settlement set, int playerid
int GoldPerSec;
Sleep(100);

set.SetGold(set.gold + 4000);
GoldPerSec = 16;

while (1) {
  Sleep(1000);
	if (set.IsValid) {
		if (set.player == playerid)
			set.SetGold(set.gold + GoldPerSec);
	}
}

