// void, Settlement set
// AI Script for performing Stonehenge rituals
// This script should be called from ES_STRONGHOLD.VS or similar settlement scripts

int AIPlayer;
int i, nEnemyUnits, nEnemyMages, nOwnMages, nOwnUnits;
int nSpellCooldown;
str strSpell;
Building stonehenge;
Query qStonehenge, qMages;
ObjList olMages;
int nMagesRequired;
bool bCanCast;

AIPlayer = set.player;

// Find Stonehenge owned by this player
qStonehenge = ClassPlayerObjs("Stonehenge", AIPlayer);
if (qStonehenge.count == 0) return;

stonehenge = qStonehenge.GetObjList()[0].AsBuilding();
if (!stonehenge.IsValid()) return;

// Check if a spell is already being cast
if (stonehenge.IsSpellCasted()) return;

// Check cooldown (stored in environment variable per player)
nSpellCooldown = EnvReadInt(AIPlayer, "StonehengeCooldown");
if (nSpellCooldown > 0) {
	EnvWriteInt(AIPlayer, "StonehengeCooldown", nSpellCooldown - 1);
	return;
}

// Count available mages near Stonehenge
qMages = Intersect(ObjsInSight(stonehenge, "BaseMage"), ControllableObjs(AIPlayer, "BaseMage"));
nOwnMages = qMages.count;

// Count enemy forces
nEnemyUnits = 0;
nEnemyMages = 0;
for (i = 1; i <= 8; i += 1) {
	if (i != AIPlayer) {
		if (!DiplGetCeaseFire(AIPlayer, i)) {
			nEnemyUnits = nEnemyUnits + ClassPlayerObjs("Unit", i).count;
			nEnemyMages = nEnemyMages + ClassPlayerObjs("BaseMage", i).count;
		}
	}
}

// Count own military units
nOwnUnits = ClassPlayerObjs("Military", AIPlayer).count;

// Decide which spell to cast based on situation
// Default: no spell
strSpell = "";
nMagesRequired = 0;

// Priority 1: Death Wish if enemy has many mages (40+)
if (nEnemyMages >= 40) {
	strSpell = "death_wish";
	nMagesRequired = GetConst("StonehengeFinalSacrifice");
}

// Priority 2: Bloodlust if we have a decent army and fewer enemies
if (strSpell == "") {
	if (nOwnUnits >= 50 && nEnemyUnits < 450) {
		strSpell = "bloodlust";
		nMagesRequired = GetConst("StonehengeBloodlust");
	}
}

// Priority 3: Teuton Disaster if enemy army is moderate
if (strSpell == "") {
	if (nEnemyUnits < 450 && nEnemyUnits > 100) {
		strSpell = "teuton_disaster";
		nMagesRequired = GetConst("StonehengeTeutonDisaster");
	}
}

// Priority 4: Starvation as default offensive spell
if (strSpell == "") {
	if (set.food > 2000 && nEnemyUnits >= 200) {
		strSpell = "starvation";
		nMagesRequired = GetConst("StonehengeStarvation");
	}
}

// Priority 5: Golden Rain if we need economy boost
if (strSpell == "") {
	if (set.gold < 500) {
		strSpell = "golden_rain";
		nMagesRequired = GetConst("StonehengeGoldenRain");
	}
}

// No spell selected or not enough mages
if (strSpell == "") return;
if (nMagesRequired <= 0) nMagesRequired = 5; // fallback default
if (nOwnMages < nMagesRequired) return;

// Gather required mages
olMages.Clear();
for (i = 0; i < nMagesRequired; i += 1) {
	olMages.Add(qMages.GetObjList()[i]);
}

// Send mages to perform the ritual
olMages.SetCommand("globalspell", stonehenge);

// Start the global spell
// Spell IDs: 0=invalid, 1=wind_of_wisdom, 2=starvation, 3=golden_rain, 4=death_wish, 5=bloodlust, 6=teuton_disaster
int nSpellId;
nSpellId = 0;
if (strSpell == "starvation") nSpellId = 2;
else if (strSpell == "golden_rain") nSpellId = 3;
else if (strSpell == "death_wish") nSpellId = 4;
else if (strSpell == "bloodlust") nSpellId = 5;
else if (strSpell == "teuton_disaster") nSpellId = 6;

if (nSpellId > 0) {
	stonehenge.GlobalSpellStart(nSpellId, AIPlayer);
	stonehenge.SetCommand("wait_for_finish_sacrifice");

	// Set cooldown (approximately 15 minutes in game ticks, assuming this runs every few seconds)
	// Adjust based on how often ESH scripts are called
	EnvWriteInt(AIPlayer, "StonehengeCooldown", 100);

	if (AIVar(AIPlayer, AIV_LogResearch) != 0)
		pr("Player " + AIPlayer + " is casting Stonehenge ritual: " + strSpell);
}
