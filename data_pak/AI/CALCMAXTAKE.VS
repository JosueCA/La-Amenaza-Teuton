//int, int idPlayer, GAIKA g
int own, ally, enemy, nMinNeed;
g.Eval(AI_COMING + AI_STAYING, idPlayer, own, ally, enemy);
nMinNeed = g.MinNeed(idPlayer, own, ally, enemy);
return own - nMinNeed; // will be interpreted as zero if negative
