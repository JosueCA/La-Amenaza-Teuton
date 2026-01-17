// void, str GroupName, str Target

// Guard AI Helper

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
set = GetSettlement(Target);

tgtclass = set.GetCentralBuilding.class;
if(tgtclass == "GOutpost" || tgtclass == "ROutpost")
{
  oTarget = set.GetCentralBuilding;
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
      if(o.pos.Dist(oTarget.pos) > oTarget.sight*3/2)
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
	if (ol.count!=0) {
		  while(oTarget.IsEnemy(ol[0])) {
			ol = qryDef.GetObjList();
			for(j = 0; j < ol.count; j += 1)
			{
			  o = ol[j];
 			  if(o.AsUnit.hero.IsValid)
				continue;

			  if(o.command == "engage")
			  {
				oEnemy = o.AsUnit.BestTargetInSquadSight.AsUnit;
			  }
			  if(o.command == "idle" || o.command == "attack")
			  {
				if(oEnemy.IsAlive)
				{
				//	pr(oEnemy.class);
					o.SetCommand("advance", oEnemy.pos);
					bReSiege = true;
				} else
				{
				  if(!o.AsUnit.InHolder)
				  {
					if(o.pos.Dist(oTarget.pos) < 500)
						o.SetCommand("capture", oTarget);
					else
					{
						pt = o.pos-oTarget.pos;
						pt = (pt*(rand(40)+(oTarget.range+oTarget.radius)))/pt.Len;
						o.SetCommand("advance", oTarget.pos+pt);
					}
				  }
				}
			  }
			}
			if(!oEnemy.AsUnit.IsValid && bReSiege) 
			{
			   ol.Siege(oTarget, 1, 0);
			   bReSiege = false;
			}
			Sleep(2000);
			if(ol.count == 0)
			  break;
		}
	}
}
if(tgtclass == "GTownhall" || tgtclass == "RTownhall")
{
  if(ol.count == 0)
    return;
  oTarget = set.BestGate(ol[0].pos);
//	pr("Find gather point");
  
  while(1)
  {
    ol = qryDef.GetObjList();
    Reached = 0;
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
	  if(!o.AsUnit.hero.IsValid)
	  {
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
	  while(oTarget.IsEnemy(ol[0])) {
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
} else
{
  oTarget = set.GetCentralBuilding;
// Find gather point
  while(1)
  {
    ol = qryDef.GetObjList();
    bReached = true;
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
	  if(o.AsUnit.hero.IsValid)
		continue;
      if(o.pos.Dist(oTarget.pos) > oTarget.sight*4)
      {
        if(o.command != "advance")
           o.SetCommand("advance", oTarget.pos);
        bReached = false;
      } else
          o.KillCommand();
    }
    if(bReached)
      break;
    Sleep(1000);
    if(ol.count == 0)
      break;
  }
//  pr("Army's gathered");
    for(j = 0; j < ol.count; j += 1)
    {
      o = ol[j];
	  if(o.AsUnit.hero.IsValid)
		continue;
      pt = oTarget.pos - o.pos;
      ;pt.Set(-pt.x, -pt.y);
      o.SetCommand("advance", oTarget.pos-pt);
    }
	if (ol.count != 0)
		  while(oTarget.IsEnemy(ol[0]))
		  {
			  Sleep(1000);
			  ol = qryDef.GetObjList();
			  for(j = 0; j < ol.count; j += 1)
				{
				o = ol[j];
			  if(o.AsUnit.hero.IsValid)
				continue;

				if(rand(10) == 0)
	     			oEnemy = o.AsUnit.BestTargetInSquadSight.AsUnit;
				pt = oTarget.pos - o.pos;
				if(rand(2)) 
				{
				  pt.Set(-pt.x, pt.y);
				}
				if(rand(2)) 
				{
				  pt.Set(pt.x, -pt.y);
				}
				if(oEnemy.IsAlive)
				{
				   if(o.command != "advance")
				   {
					 o.AddCommand(true, "advance", oEnemy.pos);
					 o.KillCommand();
					}
				} else
				if(rand(20) == 0)
				{
					if(o.command != "advance")
					{
					  o.AddCommand(true, "advance", oTarget.pos + pt);
					  o.KillCommand();
					}
				} else
				if(o.command != "capture")
				{
				   o.AddCommand(true, "capture", oTarget);
				   o.KillCommand();
				}

			  }
			if(ol.count == 0)
			  break;
		  }
//  pr("Done :)");
} 
