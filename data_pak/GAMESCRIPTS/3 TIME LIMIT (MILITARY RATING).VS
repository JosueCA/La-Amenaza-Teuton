//void, int player, str param

Query q;
int i, nTimeLimit, nTime, nRemainingTime, nScore, nTimeout;
int nTop1, nTop2, nSuddenDeathTimeout;
bool bSuddenDeath;
int nMaxEnemyTimeout;
bool bEnemiesLosing;


q = ClassPlayerObjs("BaseTownhall", player);

nTimeLimit = Str2Int(param);
nTime = 0;
nTimeout = -1;
nSuddenDeathTimeout = GetConst("SuddenDeathTimeout");
bSuddenDeath = false;

EnvWriteInt(player, "elimination", 0);


while (1) {
	nRemainingTime = nTimeLimit - nTime;
	if (nTimeout == 0) {
		SetWinLoseStatus(player, Translate("You were eliminated."), true);
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true); //true = lose
		return;
	}



	nScore = GetTeamMilitaryScore(player);
	nTop1 = -1;
	nTop2 = -1;
	for (i=1; i<=8; i+=1)	{
		int n;
		n = GetTeamMilitaryScore(i);
		if (n > nTop2) {
			if (n > nTop1) {
				nTop2 = nTop1;
				nTop1 = n;
			} else {
				nTop2 = n;
			}
		}
	}
	if (nTop2 == -1) nTop2 = nTop1;
	if (!bSuddenDeath) {
		if (nRemainingTime >0) {
			if (nRemainingTime < 10*60) {
				if (nRemainingTime%60<10)
					SetWinLoseStatus(player, Translatef("Time limit (%s1:0%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), true);
				else 
					SetWinLoseStatus(player, Translatef("Time limit (%s1:%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), true);
			} else  {
				if (nRemainingTime%60<10)
					SetWinLoseStatus(player, Translatef("Time limit (%s1:0%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), false);
				else 
					SetWinLoseStatus(player, Translatef("Time limit (%s1:%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), false);
			}
			nTime +=1;
		} else {
			if (nTop1 == nTop2) {
				bSuddenDeath = true;
			} else {
				if (nScore == nTop1) {
					SetWinLoseStatus(player, Translate("You win." ), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, false); //false = win
					return;
				} else {
					SetWinLoseStatus(player, Translate("You lose." ), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, true); //true = lose
					return;
				}
			}
		}
	}

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


	if (bSuddenDeath) { //recheck, it may have been changed
		if (nSuddenDeathTimeout == 0) {
			if (nScore == nTop1) {
				SetWinLoseStatus(player, Translate("You win." ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, false); //false = win
				return;
			} else {
				SetWinLoseStatus(player, Translate("You lose." ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}
		}
		if (q.IsEmpty()) {
			if (MilUnits(player)==0) {
				SetWinLoseStatus(player, Translate("You were eliminated." ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}

			if (nTimeout == -1)
				nTimeout = GetConst("EliminationTimeout");
			nTimeout -= 1;
		} else {
			nTimeout = -1;
			EnvWriteInt(player, "elimination", 0); //recaptured
		}

		if (nTimeout != -1 && nTimeout < nSuddenDeathTimeout) {
			EnvWriteInt(player, "elimination", nTimeout);
			if (nTimeout%60<10)
				SetWinLoseStatus(player, Translatef("You lose after %s1:0%s2 minutes", nTimeout/60, nTimeout%60), true);
			else
				SetWinLoseStatus(player, Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
		} else {
			EnvWriteInt(player, "elimination", nSuddenDeathTimeout);
			if (nSuddenDeathTimeout%60<10)
				SetWinLoseStatus(player, Translatef("Sudden death (%s1:0%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
			else
				SetWinLoseStatus(player, Translatef("Sudden death (%s1:%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
		}
		nSuddenDeathTimeout -=1 ;

		
	} else {
		if (q.IsEmpty()) {
			if (MilUnits(player)==0) {
				SetWinLoseStatus(player, Translate("You were eliminated." ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}

			if (nTimeout == -1)
				nTimeout = GetConst("EliminationTimeout");
			nTimeout -= 1;
			EnvWriteInt(player, "elimination", nTimeout);
			if (nTimeout%60<10)
				SetWinLoseStatus(player, Translatef("You lose after %s1:0%s2 minutes", nTimeout/60, nTimeout%60), true);
			else
				SetWinLoseStatus(player, Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
		} else {																		
			nTimeout = -1;
			EnvWriteInt(player, "elimination", 0); //recaptured
		}
	}
	Sleep(1000);
}

