// void
int AIPlayer;
int i, nMagesRequired, nEnemyPlayers;
int nEnemyUnits, nEnemyMages, nOwnUnits, nAllMages;
int nSpellId, nSkipChance;
Building stonehenge;
Query qStonehenge, qStrongholds, qAllMages;
ObjList olMages;
Obj mage;
Druid d;
Settlement s;
point ptStone;
bool bNeedGold, bIsRoman, bEnoughFood;

AIPlayer = AIGetPlayer();

// Stagger start time based on player ID + random offset to avoid race condition
// Base: 180s + (player * 10s) + random 0-60s
Sleep(180000 + (AIPlayer * 10000) + rand(60000));

// Only AI players 1-8 should run this script
if (AIPlayer < 1 || AIPlayer > 8) {
	return;
}

// Determine if player is Roman or Gaul
qStrongholds = ClassPlayerObjs("RStronghold", AIPlayer);
bIsRoman = (qStrongholds.count > 0);

// Random chance (0-33%) to skip each ritual attempt
nSkipChance = rand(34);

while( true )
{
	// Find Stonehenge
	qStonehenge = ClassPlayerObjs("Stonehenge", 15);
	if (qStonehenge.count > 0) {
		stonehenge = qStonehenge.GetObjList()[0].AsBuilding();
		if (stonehenge.IsValid) {
			if (!stonehenge.IsSpellCasted()) {
				ptStone = stonehenge.pos;

				// Count enemies and own units
				nEnemyUnits = 0;
				nEnemyMages = 0;
				nEnemyPlayers = 0;
				for (i = 1; i <= 8; i += 1) {
					if (i != AIPlayer) {
						if (!DiplGetCeaseFire(AIPlayer, i)) {
							nEnemyUnits = nEnemyUnits + ClassPlayerObjs("Unit", i).count;
							nEnemyMages = nEnemyMages + ClassPlayerObjs("BaseMage", i).count;
							nEnemyPlayers = nEnemyPlayers + 1;
						}
					}
				}
				if (nEnemyPlayers < 1) {
					nEnemyPlayers = 1;
				}
				nOwnUnits = ClassPlayerObjs("Military", AIPlayer).count;
				qAllMages = ControllableObjs(AIPlayer, "BaseMage");
				nAllMages = qAllMages.count;

				// Decide spell
				nSpellId = 0;
				nMagesRequired = 5;

				// Priority 1: Death Wish - enemy has more mages than us
				if (nEnemyMages >= 20) {
					if ((nEnemyMages + 10) > nAllMages) {
						nMagesRequired = GetConst("StonehengeFinalSacrifice");
						nSpellId = 4;
					}
				}

				// Priority 2: Bloodlust - army advantage
				if (nSpellId == 0) {
					if (nOwnUnits >= 100) {
						if (nEnemyUnits < 450) {
							nMagesRequired = GetConst("StonehengeBloodlust");
							nSpellId = 5;
						}
					}
				}

				// Priority 3: Teuton Disaster - average enemy army per player > 20
				if (nSpellId == 0) {
					if (nOwnUnits > 50 && nEnemyUnits > 1) {
						if ((nEnemyUnits / nEnemyPlayers) > 50) {
							nMagesRequired = GetConst("StonehengeTeutonDisaster");
							nSpellId = 6;
						}
					}
				}

				// Priority 4: Starvation - large enemy army (20+ units per enemy player)
				if (nSpellId == 0) {
					if (nEnemyUnits >= (20 * nEnemyPlayers)) {
						bEnoughFood = false;
						qStrongholds = ClassPlayerObjs("BaseStronghold", AIPlayer);
						if (qStrongholds.count > 0) {
							s = qStrongholds.GetObjList()[0].AsBuilding().settlement;
							if (s.IsValid) {
								if (s.food > 4000) {
									bEnoughFood = true;
								}
							}
						}

						if (bEnoughFood) {
							nMagesRequired = GetConst("StonehengeStarvation");
							nSpellId = 2;
						}
					}
				}

				// Priority 5: Golden Rain - low gold
				if (nSpellId == 0) {
					bNeedGold = false;
					qStrongholds = ClassPlayerObjs("BaseStronghold", AIPlayer);
					if (qStrongholds.count > 0) {
						s = qStrongholds.GetObjList()[0].AsBuilding().settlement;
						if (s.IsValid) {
							if (s.gold < 4000) {
								bNeedGold = true;
							}
						}
					}
					if (bNeedGold) {
						nMagesRequired = GetConst("StonehengeGoldenRain");
						nSpellId = 3;
					}
				}

				// Fallback: Golden Rain - low gold
				if (nSpellId == 0) {
					nMagesRequired = GetConst("StonehengeGoldenRain");
					nSpellId = 3;
				}

				if (nMagesRequired <= 0) {
					nMagesRequired = 5;
				}

				// Random chance (0-25%) to skip this ritual
				if (rand(100) < nSkipChance) {
					Sleep(120000);
					continue;
				}

				// Create mages at Stonehenge position and cast spell
				olMages.Clear();
				for (i = 0; i < nMagesRequired; i += 1) {
					if (bIsRoman) {
						mage = Place("RPriest", ptStone, AIPlayer);
					} else {
						mage = Place("GDruid", ptStone, AIPlayer);
					}
					olMages.Add(mage);
					if (nSpellId == 4) {
						d = mage.AsDruid;
						if (d.IsValid) {
							d.SetStonehenge(stonehenge);
						}
					}
				}
				olMages.SetCommand("globalspell", stonehenge);
				stonehenge.GlobalSpellStart(nSpellId, AIPlayer);
				stonehenge.SetCommand("wait_for_finish_sacrifice");
				// pr("Player " + AIPlayer + " casting spell " + nSpellId);
			}
		}
	}

	Sleep(120000);
}
