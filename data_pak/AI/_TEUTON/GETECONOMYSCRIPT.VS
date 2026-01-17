// int, Settlement set, int idPlayer
if (set.IsStronghold) return ES_Stronghold;
if (!set.IsTeutonTent) if (set.gold >= 100 || set.food >= 100) return ES_StealRes;
return ES_NONE;