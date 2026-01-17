// int, Settlement set, int idPlayer
if (set.IsVillage)    return ES_Village;
if (set.IsStronghold) return ES_Stronghold;

if (set.IsOutpost) {
  if (set.supplied.IsValid) { if (set.IsGaulOutpost) return ES_OutpostSellFood; }
  else if (set.gold >= 100) return ES_OutpostSendGold;
}

if (set.IsShipyard) return ES_Shipyard;

return ES_NONE;