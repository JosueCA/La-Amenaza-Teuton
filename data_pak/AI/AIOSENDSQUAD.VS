//void, SquadList l, GAIKA g

int      i;
Obj      dummy;
point    pt;
Ship     ship;

//pr( "AI exec: SendSquad" );
if (!l.Rewind()) return;
//pt = l.Cur.pos;
//if (pt.x >= 0 && pt.y >= 0) ScrollTo( pt, 1000 );
//Sleep(300);
//SelSquad( l.Cur.Player, l.Cur.No );
//l.Select(l.Cur.Player);
//Sleep(700);

//if (pt.x >= 0 && pt.y >= 0) ScrollTo( pt, 1000 );

l.Lock;
while (true)
{
	if (l.Cur.GAIKAIn == g) 
		if (l.Cur.State == SS_Flee && g.settlement.IsValid) {
			l.Cur.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", g.settlement.GetCentralBuilding);
		} else
			l.Cur.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
	else
	{
		int LsaPathLen;
    Obj   teleport;
    if (AIVar(l.Cur.Player, AIV_UseTeleports) != 0)
      teleport = FindTeleport(l.Cur.Player, l.Cur.pos, g.Center);
    if (teleport.IsValid)
      LsaPathLen = 1;
    else
 		  LsaPathLen = CheckLsaPath( l.Cur.GAIKAIn.LSA, g.LSA, l.Cur.Player );

		if( LsaPathLen == 1 )
		{
      int state;
      str cmd;
			if (l.Cur.State == SS_Flee)
				{ cmd = "move"; state = SS_Flee; }
			else if (l.Cur.Leader.AsHero.IsValid)
				{ cmd = "sneak"; state = SS_Approach; }
			else
        { cmd = "advance"; state = SS_Approach; }

			pt = g.GetDestPoint(l.Cur.Leader());
      
			if (teleport.IsValid)
        l.Cur.UseTeleport(teleport, state, cmd, pt);
      else
        l.Cur.SetCmd(state, 0, SF_ADVCHOOSER, cmd, pt);
		}
		else if( LsaPathLen == 3 )
		{
			int   state;
			str   cmd;
			Ship  ship;

			if (l.Cur.State == SS_Flee)
			{
				cmd = "move";
				state = SS_Flee;
			}
			else
			{
				if (l.Cur.Leader.AsHero.IsValid)
					cmd = "sneak";
				else
					cmd = "advance";
				state = SS_Approach;
			}
			pt = g.Center();
			ship = PrepareAiTransportShip( l.Cur.GAIKAIn.LSA, g.LSA, l.Cur.Player, cmd, pt );
			if (!ship.IsValid()) {
        //pr("Could not find transport ship!?!");
				return;
      }
      ship.GetSquad.DelOrder;
      if (l.Cur.Leader.AsHero.IsValid)
        l.Cur.SetCmd( state, 0, 0, "boardshiphero", ship );
      else
			  l.Cur.SetCmd( state, 0, 0, "boardship", ship );
      //UserNotification("location message", "Offshore approach", l.Cur.pos, l.Cur.Player);
      //SetSpeed(0);
		}
	}
	if (!l.Next()) break;
}
l.Unlock;