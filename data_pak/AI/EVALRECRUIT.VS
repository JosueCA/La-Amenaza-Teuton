//int, Squad sq, GAIKA g, GAIKA *gDepend
GAIKA gCurDest;
int   lsaPathLen;
Obj   teleport;
bool  bFightForFood = false;

if (sq.State != SS_IDLE && 
    sq.State != SS_Approach && 
    sq.State != SS_Wait && 
    sq.State != SS_ApproachWait && 
    sq.State != SS_Enter)
  return 0;

gCurDest = sq.AIDest();
if (gCurDest == g) return 0;

if (sq.Leader.AsShip.IsValid) {
  if (sq.Leader.AsShip.HasAiTransport)
    return 0;
  if (!IsWaterLsa(g.LSA))
    return 0;
} else if (IsWaterLsa(g.LSA))
  return 0;

if (AIVar(sq.Player, AIV_UseTeleports) != 0)
  teleport = FindTeleport(sq.Player, sq.pos, g.Center);
if (teleport.IsValid)
  lsaPathLen = 1;
else
  lsaPathLen = CheckLsaPath( sq.GAIKAIn.LSA, g.LSA, sq.Player );
if (lsaPathLen == 0) return 0;

// Do not explore with Liberati or Viking Lords (prevent scattering them and force using on purpose)
if (sq.Leader.HasFreedom)
	{
		if (sq.Leader.class=="GVikingLord")
			{
				if (g.Eval(AI_STAYING, sq.Player, AI_ENEMY)<500)
					return 0;
			}
		if (g.settlement.IsIndependent && g.settlement.IsStronghold)
			return 0;
		if (!g.Explored(sq.Player))
			return 0;
	}

if (g.settlement.IsVillage) if (sq.GAIKAIn.settlement.IsStronghold) 
  if (sq.GAIKAIn.settlement.food < 100)
    bFightForFood = true;

if (!bFightForFood) 
  if (sq.Leader.AsHero.IsValid) {
    //if (sq.SrcGAIKA == 0) // &&
    if (sq.GAIKAIn.settlement.IsStronghold) {
      int time, min;
      time = GetTime / 60000;
      if (time < 10) min = 15;
      else if (time < 20) min = 20;
      else if (time < 30) min = 31;
      else min = 41;
      if (sq.Size < min) 
        return 0;
    }

    if (!g.settlement.IsOwn(sq.Player) || !g.settlement.IsStronghold) // && 
    //if (sq.Leader.InHolder || sq.State == SS_Enter) // &&
    if (sq.health < sq.maxhealth*8/10) // &&
    if (sq.GAIKAIn.settlement.IsValid)
    if (sq.GAIKAIn.settlement.food > 100)
      return 0; // heal first
  } else {
		if (sq.Units().count<10 && sq.Leader().GetHolderSett().IsTeutonTent())
			return 0;

    // Don't send weak squads to attack TeutonTents early in the game
    if (g.settlement.IsTeutonTent) {
      if (GetTime < 300000) return 0; // No tent attacks in first 5 minutes
      if (GetTime < 600000) if (sq.Eval < 1500) return 0; // Need strong squad for early tent attacks
      if (sq.Eval < 1000) return 0; // Always require minimum strength for tent attacks
    }

    if (g.Explored(sq.Player)) 
			if (!g.settlement.IsIndependent)
				{
					Settlement s;
					s = sq.GAIKAIn.settlement;
					if (s.IsStronghold()) if (!sq.HasFreedom) if (s.IsOwn(sq.Player)) 
						return 0; // Wait to attach before sending
				}
	}

if (gCurDest.GetPriority(sq.Player) >= g.GetPriority(sq.Player))
  gDepend = gCurDest;

return 100000 - sq.pos.Dist(g.Center) * lsaPathLen;