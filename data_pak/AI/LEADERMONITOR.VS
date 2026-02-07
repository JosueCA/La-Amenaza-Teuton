//void

Sleep(rand(1000));

while (666) {

int AIPlayer;
int i;

AIPlayer = AIGetPlayer();

for (i = 1; i < NumSquads(AIPlayer); i += 1) [
  Squad sq; sq = GetSquad(AIPlayer, i);
  if (sq.Eval == 0) continue;
  if (!sq.Leader.IsValid) continue;
  if (sq.TestFlags(SF_NOAI)) continue;
  if (sq.State == SS_Flee) continue;
  if (!sq.Leader.AsHero.IsValid) continue;
  if (sq.Leader.health < sq.Leader.maxhealth * 9 / 10) continue;
  if (sq.Leader.AsHero.item_count >= sq.Leader.AsHero.max_items) continue;

  if (AIVar(AIPlayer, AIV_UseRuins) != 0) {
    Obj ruins;
    if (sq.State == SS_Ruins)
      sq.SetState(SS_IDLE);
    ruins = FindRuins(sq.pos, 2500, sq.Leader.level);
    if (ruins.IsValid) if (rand(2)==1) {
      // sq.Leader.AsHero.DetachArmy;
      sq.SetCmd(SS_Ruins, 0, SF_ADVCHOOSER, "enter", ruins);
      sq.Leader.AddCommand(false, "enter", sq.GAIKAIn.settlement.GetCentralBuilding);
      continue;
    }
  }

  Sleep(200);
]

Sleep(30000);
}
