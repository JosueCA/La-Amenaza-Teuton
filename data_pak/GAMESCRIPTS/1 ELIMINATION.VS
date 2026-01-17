//void, int player, str param
Query q;
int i, nTime, nMaxEnemyTimeout;
bool bEnemiesLosing;

q = ClassPlayerObjs("BaseTownhall", player);

EnvWriteInt(player, "elimination", 0);

while (1) {
	Sleep(1000);
	SetWinLoseStatus(player, Translate("Elimination"), false);
	//check if all others will lose
	nMaxEnemyTimeout = 0;
	bEnemiesLosing = true;
	for (i=1; i<=8; i+=1) {
		if (i != player && !DiplAreAllied(i, player)) {
			int nEnemyTimeout;
			nEnemyTimeout = EnvReadInt(i, "elimination");
			if (nEnemyTimeout != 0) {
				if (nEnemyTimeout > nMaxEnemyTimeout) nMaxEnemyTimeout = nEnemyTimeout;
			} else {
				bEnemiesLosing = false;
			}
		}
	}
	if (bEnemiesLosing && nMaxEnemyTimeout>1) {
		if (nMaxEnemyTimeout % 60 < 10)
			SetWinLoseStatus(player, Translatef("You win after %s1:0%s2 minutes", nMaxEnemyTimeout/60, nMaxEnemyTimeout%60), true);
		else
			SetWinLoseStatus(player, Translatef("You win after %s1:%s2 minutes", nMaxEnemyTimeout/60, nMaxEnemyTimeout%60), true);
	}

	if (!q.IsEmpty()) continue;

	nTime = GetConst("EliminationTimeout");
	while (nTime>0) {
		if (MilUnits(player)==0) {
			SetWinLoseStatus(player, Translate("You were eliminated."), true);
			EnvWriteInt(player, "elimination", 1);
			EndGame(player, true); //true = lose
			return;
		}
		EnvWriteInt(player, "elimination", nTime);
		if (nTime%60 < 10)
			SetWinLoseStatus(player, Translatef("You lose after %s1:0%s2 minutes", nTime/60, nTime%60), true);
		else
			SetWinLoseStatus(player, Translatef("You lose after %s1:%s2 minutes", nTime/60, nTime%60), true);
		Sleep(1000);
		if (!q.IsEmpty()) break;
		nTime -= 1;
	}
	if (nTime==0) {
		SetWinLoseStatus(player, Translate("You were eliminated."), true);
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true); //true = lose
		return;
	}
	EnvWriteInt(player, "elimination", 0); //managed to recapture
}

