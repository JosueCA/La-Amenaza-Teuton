//bool, int idPlayer, GAIKA gSrc, GAIKA gDst, GAIKA gMAIKA
int own, ally, enemy, nMinNeed;
gMAIKA.Eval(AI_STAYING, idPlayer, own, ally, enemy);
nMinNeed = gMAIKA.MinNeed(idPlayer, own, ally, enemy);

//pr("MAIKA<"+gSrc.ID+"-"+gMAIKA.ID+"-"+gDst.ID+">: Own: "+own+" Needed: "+nMinNeed);

if (own + ally < nMinNeed) {
  int nDstPriority, nMAIKAPriority;
  nDstPriority = gDst.GetPriority(idPlayer);
  nMAIKAPriority = gMAIKA.GetPriority(idPlayer);
  if (nMAIKAPriority < nDstPriority)
    gMAIKA.SetPriority(idPlayer, nDstPriority * 3 / 2);
//  pr("  BMAIKA");
  return false;
}
//pr("  OK");
return true;