// void, GAIKA g, int AIPlayer

int own, lown, ally, enemy, nMinNeed;

g.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
nMinNeed = g.MinNeed(AIPlayer, own, ally, enemy);

if (own + ally < nMinNeed) {
  lown = g.Eval(AI_LEAVING, AIPlayer);
  if (own + ally + lown >= nMinNeed) {
    SquadList SL; g.GetSquads(SL, AI_LEAVING, AIPlayer);
    SL.Lock;
    while( SL.EOL == false ) {
      Squad sq; sq = SL.Cur; SL.Next();
      if (sq.State != SS_Flee) {
		    //sq.DelOrder(); sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
        sq.SetState(SS_IDLE); sq.SendTo(g, 1);
      }
    }
    SL.Unlock;
  }
}
