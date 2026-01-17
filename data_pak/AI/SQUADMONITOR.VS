//void

Sleep(rand(1000));

while (666) {

int AIPlayer;
int i;
int time, min;
bool bLog;

AIPlayer = AIGetPlayer();
bLog = (AIVar(AIPlayer, AIV_LogFlee) != 0);
time = GetTime / 60000;
if (time < 10) min = 30;
else min = 40;

for (i = 1; i < NumSquads(AIPlayer); i += 1) [
  Squad sq; sq = GetSquad(AIPlayer, i);
  if (sq.Eval == 0) continue;
  if (!sq.Leader.IsValid) { pr("Inconsistent squad?!?"); continue; }
  if (sq.TestFlags(SF_NOAI)) continue;

  if (IsWaterLsa(sq.GAIKAIn.LSA)) {
    if (sq.InHolder || sq.Leader.AsShip.IsValid) continue; // ships and units in ships are not "monitored"
    // todo: squad in water GAIKA, move it out (be careful not to take boarding units away)
  }

  if (sq.State != SS_IDLE) if (sq.State != SS_ApproachWait) if (sq.State != SS_Siege) if (sq.State != SS_Catapult) if (!sq.Leader.InHolder) if (sq.Leader.command == "idle") { // patch fix :)
    sq.DelOrder;
    sq.SetState(SS_IDLE);
  }

  if (sq.State == SS_IDLE) if (sq.Leader.command == "idle") 
		if (sq.GAIKAIn != sq.AIDest) 
			{ // oops, I did it again :)
				sq.SendTo(sq.AIDest,1);
				Sleep(100);
				continue;
			}
		else // Send units from Teuton tents and other small armies at home
			{
				if (sq.Units().count<=10 || sq.Eval<1000) if (sq.Eval<5000) if (sq.GAIKAIn.StratRunning(AIPlayer) == GS_NONE)
					if (!sq.TestFlags(SF_PEACEFUL) || sq.Leader.AsDruid.IsValid)
						if (sq.Leader.GetHolderSett.IsTeutonTent())
							{
								if (rand(15)==0)
									if (sq.Leader.GetHolderSett.UnitsCount()>=8)
										{
											Settlement s;
											s = NearestStronghold(sq.pos, sq.Player);
											if (s.IsValid)
												{
													SquadList SL;
													sq.GAIKAIn.GetSquads(SL, AI_STAYING, AIPlayer); SL.Lock;
													for (0; !SL.EOL; SL.Next)
														if (SL.Cur.Leader.GetHolderSett.IsTeutonTent())
															sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
													SL.Unlock;
													Sleep(100);
													continue;
												}
										}
							}
						else if (!sq.InHolder) if (GetTime() > 900000)
							{
								Settlement s;
								s = NearestStronghold(sq.pos, sq.Player);
								if (s.IsValid)
									{
										sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
										Sleep(100);
										continue;
									}
							}
			}

	// Retreat idle units from tower range
  if (sq.State == SS_IDLE || sq.State == SS_Wait) if (sq.Leader.command == "idle" || sq.Leader.command == "stand_position") 
		if (sq.LastFightTime() > GetTime()-3000) if (sq.GetLastAttacker().AsBuilding())
			{
				point pt;
				pt = sq.pos - sq.GetLastAttacker().pos;
				pt.SetLen(100);
				sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sq.pos + pt);
			}

  // use ruins
	if (rand(3)==3) if (AIVar(AIPlayer, AIV_UseRuins) != 0) if (sq.InHolder) if (sq.Leader.AsHero) if (sq.GAIKAIn.settlement.IsStronghold)
		{
			Obj ruins;
			if (sq.State == SS_Ruins)
				sq.SetState(SS_IDLE);
			ruins = FindRuins(sq.pos, 6500, sq.Leader.level);
			if (ruins.IsValid)
				{
					sq.Leader.AsHero.DetachArmy;
					sq.SetCmd(SS_Ruins, 0, SF_ADVCHOOSER, "enter", ruins);
					sq.Leader.AddCommand(false, "enter", sq.GAIKAIn.settlement.GetCentralBuilding);
					Sleep(100);
					continue;
				}
		}
	
	// use items
  if (AIVar(AIPlayer, AIV_UseItems) != 0) if (sq.Leader.AsHero.IsValid) if (sq.Leader.item_count > 0) {
    if (sq.Leader.HasItem("Poison Mushroom")) if (sq.Leader.HasItem("Healing herbs"))
      sq.Leader.UseItem("Poison Mushroom");

    if (sq.Leader.HasItem("Healing herbs")) if (sq.Leader.health < sq.Leader.maxhealth / 2)
      sq.Leader.UseItem("Healing herbs");

    if (sq.Leader.HasItem("Healing water")) if ((sq.health < sq.maxhealth / 2) || (sq.health <= sq.maxhealth - 1000))
      sq.Leader.UseItem("Healing water");

    if (sq.Leader.HasItem("Ash of druid heart")) if ((sq.Leader.health < sq.Leader.maxhealth / 2) || (sq.health < sq.maxhealth / 2))
      sq.Leader.UseItem("Ash of druid heart");

    if (sq.Leader.HasItem("Rye spikes")) if (sq.food < sq.Size * 3 / 2)
      sq.Leader.UseItem("Rye spikes");

		if (rand(3)==1) // Don't use too often
			if (sq.Leader.HasItem("Horn of victory") || sq.Leader.HasItem("Finger of death"))
				{
					int own, ally, enemy, nMinNeed;
					sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy);
					nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
					if (own + ally < nMinNeed*5/4 ) // we are losing here
						{
							if (sq.Leader.HasItem("Horn of victory"))
								sq.Leader.UseItem("Horn of victory");
							if (sq.Leader.HasItem("Finger of death"))
								sq.Leader.UseItem("Finger of death");
						}
				}
  }

  if (AIVar(AIPlayer, AIV_FeedWithWagons) != 0) if (sq.State != SS_Flee) if (sq.Eval >= 3000) { // check feeding
    int dist, food, needed;
    dist = sq.pos.Dist(sq.AIDest.Center) + 200; // add 200 to help feeding already hungry squads :)
    food = sq.food + sq.FoodComing;
    needed = sq.Size * dist / 700;
    if (AIVar(AIPlayer, AIV_SynchApproach))
      needed = needed*4/3;
    if (food + 100 < needed) // don't ask for less than 100 food
      if (sq.SendFoodWagon(needed - food, 3000)) if (AIVar(AIPlayer, AIV_LogFeed) != 0)
        UserNotification("location message", "Sent food wagon", sq.pos, AIPlayer);
  }

	// Stop for healing
	if (sq.Leader.AsHero) if (sq.State == SS_Flee) if (!sq.Leader.BestTargetInSquadSight().IsValid)
		if (sq.Count("BaseMage")>=7) if (sq.food>100)
			sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sq.Leader.pos);

	// Flee logic
  if (sq.Leader.AsHero) if (sq.State != SS_Flee) if (sq.State != SS_Ruins) { // --------- hero squad
		// Init druid attaching for the hero
		if (sq.Size == 1)
			if (rand(100) < AIVar(AIPlayer, AIV_DruidAttach))
				sq.SetState(sq.State, SF_WANTDRUIDS, 0);
			else
				sq.SetState(sq.State, 0, SF_WANTDRUIDS);

    /*if (sq.DestGAIKA != sq.SrcGAIKA) */
		{ // check flee
      int nFlee = 0; // 1 - smallarmy | 2 - herosick | 4 - armysick | 8 - losing
    
      //if (sq.Size < min - 10) nFlee += 1; // army too small in number
      if (sq.Leader.health < sq.Leader.maxhealth / 2)
				if (sq.Leader.BestTargetInSquadSight.IsAlive) nFlee += 2; // hero badly hurt in battle
      if (AIVar(AIPlayer, AIV_Coward) != 0) {
        if (sq.health < sq.maxhealth / 2) nFlee += 4; // army sick
        if (sq.GAIKAIn.settlement.IsTeutonTent || (sq.AIDest == sq.GAIKAIn)) {
          int own, ally, enemy, nMinNeed;
          sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy);
          nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
          if (own + ally < nMinNeed / 2) // we are losing here
            nFlee += 8;
        }
      }

      if (nFlee != 0) if (nFlee != 8) { // willing to flee, en-route, more than just losing
        int own, ally, enemy, nMinNeed;
        sq.AIDest.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy);
        nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
        if (own + ally >= nMinNeed) if (own + ally - sq.Eval < nMinNeed) if (own + ally - sq.Eval > 0) if (sq.Size>6)
          nFlee = 0; // don't flee if others can't do it without you ;)
      }

      if (nFlee != 0) {
        int own, ally, enemy;
        sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
        enemy += sq.GAIKAIn.Eval(AI_LEAVING, AIPlayer, AI_ENEMY);
        if (enemy == 0) if (sq.GAIKAIn.settlement.IsEnemy(AIPlayer)) if (sq.GAIKAIn.settlement.CanBeCaptured)
          nFlee = 0;

        if (enemy != 0) if (nFlee == 1) // if enemies around, don't flee only because army is small
          nFlee = 0;

        if (nFlee != 0) {
          GAIKA gFlee; gFlee = NearestHospital(sq);
          if (nFlee == 1) if (gFlee.LSA != sq.GAIKAIn.LSA) { // don't go for reequip only if offshore
            Sleep(100);
            continue;
          }
            
          if ((nFlee == 8) && (sq.AIDest != sq.GAIKAIn)) { // ambushed but otherwise OK, decide where to flee
            int distGoal, distHospital;
            // try to go around
            if (sq.DestGAIKA == sq.AIDest) // &&
            if (sq.Leader.command == "move" || sq.Leader.command == "sneak" || sq.Leader.command == "advance" || sq.Leader.command == "enter") { 
              SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
              if (AIVar(AIPlayer, AIV_GoAround) != 0) if (sq.CalcGoAround) { // worked :)
                //UserNotification("location message", "Hero go around", sq.pos, AIPlayer);
                //SetSpeed(0);
                Sleep(100);
                continue;
              }  
            }
            //gFlee = NearestHospital(sq);
            distGoal = sq.pos.Dist(sq.AIDest.Center);
            distHospital = sq.pos.Dist(gFlee.Center);
            if (distGoal >= 1500) if (distGoal < distHospital)
              gFlee = sq.AIDest;
          }

          if (gFlee == 0) nFlee = 0;
          else if (gFlee == sq.GAIKAIn)
            if (enemy != 0) nFlee = 0;
            else if (sq.State == SS_Enter) nFlee = 0;

          if (nFlee != 0) {
            if (bLog) {
              str dbg = "";
              if (UEnabled(nFlee, 0)) dbg = dbg + " (reequip)";
              if (UEnabled(nFlee, 1)) dbg = dbg + " (herosick)";
              if (UEnabled(nFlee, 2)) dbg = dbg + " (armysick)";
              if (UEnabled(nFlee, 3)) dbg = dbg + " (losing)";
              UserNotification("location message", "Squad fled" + dbg, sq.pos, AIPlayer);
            }
            SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
            sq.SetState(SS_Flee);
						if (AIVar(AIPlayer, AIV_Coward) != 0)
							sq.SendTo(gFlee, 1000);
						else
							sq.SendTo(gFlee, 1);
            Sleep(100);
            continue;
          }
        }
      }
    }

    // take items from nearby item holders
    if (AIVar(AIPlayer, AIV_TakeItems) != 0) if (sq.TakeNearbyItems(sq.Leader.sight)) { 
      // UserNotification("location message", "Found item", sq.pos, AIPlayer);
      Sleep(100);
      continue;
    }
  }

  if (sq.State == SS_Flee) {
		if (sq.InHolder)
			sq.SetState(SS_IDLE);
		else
			{
				bool bStop = true;
				if (sq.pos.Dist(sq.AIDest.Center) > 1500)
					if (sq.Leader.BestTargetInSquadSight.IsValid)
						bStop = false;
				if (bStop) 
					if (sq.GAIKAIn == sq.AIDest) {
						if (!sq.GAIKAIn.settlement.IsOwn(AIPlayer)) sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
						else if (sq.GAIKAIn.settlement.IsFull) sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
						else sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", sq.GAIKAIn.settlement.GetCentralBuilding);
						Sleep(100);
						continue;
					} else if (AIVar(AIPlayer, AIV_Coward) != 0) 
						if (sq.Size >= min - 10) if (sq.Leader.health >= sq.Leader.maxhealth / 2) if (sq.health >= sq.maxhealth / 2) {
							 /*sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);//*/sq.SetState(SS_Approach);
							 Sleep(100);
							 continue;
							 if (bLog) { 
								 UserNotification("location message", "Squad flee stopped", sq.pos, AIPlayer);
								 //if (CurPlayer == AIPlayer) if (!sq.AIDest.settlement.IsStronghold) SetSpeed(0);
							 }
						}
			}
  }

  // attach free units
  if (!sq.TestFlags(SF_PEACEFUL) || sq.Leader.AsDruid.IsValid)
	if (!sq.Leader.AsShip.IsValid) if (sq.State != SS_Catapult) if (sq.State != SS_Train){
    Unit BestHero; int BestEval = 0;
    { SquadList SL; // this scope is to ensure SquadList destruction
      for (sq.GAIKAIn.GetSquads(SL, AI_STAYING + AI_LEAVING, AIPlayer, AI_OWN); !SL.EOL; SL.Next) {
        int eval;
				eval = sq.EvalAttach(SL.Cur.Leader, min);
				if (eval==0) continue;

				if (SL.Cur.State == SS_Ruins)
					continue;
				if (sq.Leader.AsDruid.IsValid) {
					if (!SL.Cur.TestFlags(SF_WANTDRUIDS)) continue;
					if (SL.Cur.Count("BaseMage")>=9)
						continue;
				}
				if (SL.Cur.Size!=1)
					if (SL.Cur.Count("Horse")==SL.Cur.Size-1)
						if (sq.Count("Horse")!=sq.Size)
							{ /*pr("Refusing to attach non-horse units");*/ continue; }

        if (eval > BestEval) 
          { BestHero = SL.Cur.Leader; BestEval = eval; }
      }
    }
    if (BestEval > 0) 
      if (!sq.Leader.AsHero.IsValid) {
        bool bAttached = true;
        if (!BestHero.InHolder || sq.InHolder) {
          if (!sq.InHolder && sq.State == SS_Attach)
            bAttached = false;
          sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "attach", BestHero);
        } else
          sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "enter", sq.GAIKAIn.settlement.GetCentralBuilding);
        if (bAttached) {
          Sleep(100); 
          continue;
         }
      } else if (BestHero != sq.Leader.AsHero) if (sq.Size > 1) if (sq.Size < 51) if (BestHero.InHolder) if (sq.Leader.SameHolderAs(BestHero)) {
        // check if worth transfering army
        int e1, e2;
        e1 = (101 - min) * (1 + sq.Leader.level / 5); // cur hero eval after detach
        e2 = BestHero.GetSquad.Size + sq.Size - 1; // best hero squad size after attach
        if (e2 < min) e2 = 100 - (min - e2); else e2 = e2 - min + 1;
        e2 = e2 * (1 + BestHero.level / 50); // best hero eval after attach
        if (e1 < e2) { // still worh it
          sq.Leader.AsHero.DetachArmy;
          Sleep(100);
          continue;
        }
      }
  }
  if (sq.State == SS_Attach) if (sq.Leader.command == "idle") { sq.DelOrder; sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER); Sleep(100); continue; }

  // peaceful go around
  if (sq.TestFlags(SF_PEACEFUL)) if (sq.AIDest != sq.GAIKAIn) if (sq.AIDest != sq.SrcGAIKA) if (sq.DestGAIKA == sq.AIDest) // &&
  if (sq.Leader.command == "move" || sq.Leader.command == "enter"|| sq.Leader.command == "unload") { 
    int own, ally, enemy;
    sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
    if (enemy > 1000) if (own + ally < 500) { // peaceful go around
      SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
      if (AIVar(AIPlayer, AIV_GoAround) != 0) if (sq.CalcGoAround) { 
        //UserNotification("location message", "Peaceful go around", sq.pos, AIPlayer);
        //SetSpeed(0);
        Sleep(100);
        continue;
      }  
    }
  }

	// Nothing for this squad
	Sleep(50);
]

Sleep(AIVar(AIPlayer, AIV_Sleep_SquadMonitor));
}