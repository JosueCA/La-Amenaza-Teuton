// void, str GroupName, str Target

// Siege Gate AI Helper

Obj oTarget, o, oEnemy;
Settlement set;
ObjList ol, olAttackers;
Query qryDef, qryAttackers, qry;
Gate gate;
int i, j, n;
str tgtclass;
point pt, ptInit;
bool bReached, bReSiege;
int Reached;

qryDef = Group(GroupName);
ol = qryDef.GetObjList();
oTarget = GetNamedObj(Target);
if(!oTarget.AsGate.IsValid)
  return;
set = oTarget.AsGate.settlement;
{
  if(ol.count == 0)
    return;
// Find gather point
  while(1)
  {
    ol = qryDef.GetObjList();
    Reached = 0;
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
		if(o.AsUnit.hero.IsValid)
			continue;
      if(GetGAIKA(o) != set.GetGaika)
      {
        if(o.command != "advance")
           o.SetCommand("advance", oTarget.pos);
      } else
      {
          o.KillCommand();
		  Reached+=1;
		  if(o.AsHero.IsValid)
			Reached += o.AsHero.army.count();
      } 
    }
    if(Reached > ol.count*2/3)
      break;
    Sleep(2000);
    if(ol.count == 0)
      break;
  }
//  pr("Army's gathered");
// Take some army to build a catapult  
  ol.Siege(oTarget, 1, 0);
  bReSiege = false;
  while(!oTarget.AsGate.IsBroken)
  {
    ol = qryDef.GetObjList();
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
		if(o.AsUnit.hero.IsValid)
			continue;
	  if(o.AsHero.IsValid)
		continue;
      if(o.command == "engage")
      {
        oEnemy = o.AsUnit.BestTargetInSquadSight.AsUnit;
      }
      if(o.command == "idle" || o.command == "attack")
      {
        if(oEnemy.AsUnit.IsAlive)
        {
          //pr(oEnemy.class);
          if(!o.AsUnit.InHolder && rand(3) == 0)
            o.SetCommand("advance", oEnemy.pos);
          bReSiege = true;
        } else
        {
          if(o.pos.Dist(oTarget.pos) > 500 && !o.AsUnit.InHolder)
          {
             o.SetCommand("advance", oTarget.pos);
          } else
          {
             o.KillCommand();
          }
        }
      }
    }
    if(!oEnemy.AsUnit.IsValid && bReSiege) 
    {
       //pr("Siege");
       ol.Siege(oTarget, 1, 0);
       bReSiege = false;
    }
    Sleep(2000);
    if(ol.count == 0)
      break;
  }
  ol = qryDef.GetObjList();
  oTarget = set.GetCentralBuilding;
  for(j = 0; j < ol.count; j += 1)
  {
    o = ol[j];
	  if(o.AsUnit.hero.IsValid)
		continue;
    pt.Set(0, oTarget.radius+rand(60));
    pt.Rot(rand(360));
    o.SetCommand("advance", oTarget.pos + pt);
  }
  if(ol.count > 0)
  while(oTarget.IsEnemy(ol[0]))
  {
    ol = qryDef.GetObjList();
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
	  if(o.AsUnit.hero.IsValid)
		continue;

      if(o.command == "idle" || o.command == "capture")
      {
		  if(rand(30) == 0)
		  {			  
			pt.Set(0, oTarget.radius+rand(60));
			pt.Rot(rand(360));
			o.SetCommand("advance", oTarget.pos + pt);
		  } else
			o.SetCommand("capture", oTarget);
	  }
    }
    if(ol.count == 0)
      break;
  
    Sleep(2000);
  }
}