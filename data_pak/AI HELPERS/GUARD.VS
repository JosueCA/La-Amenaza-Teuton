 // void, str GroupName, str Target

// Guard AI Helper

Obj oTarget, o, oEnemy;
Settlement set;
ObjList ol, olAttackers;
Query qryDef, qryAttackers;
Gate gate;
int i, j, n;
str tgtclass;
point pt;

Query ProtectiveArea;
Query Alert;

qryDef = Group(GroupName);
ol = qryDef.GetObjList();
set = GetSettlement(Target);

tgtclass = set.GetCentralBuilding.class;

if(tgtclass == "GTownhall" || tgtclass == "RTownhall")
{

  //pr("Get OUT");
  ol.SetCommand("advanceenter", set.GetCentralBuilding);
  oTarget = set.GetCentralBuilding;
	ProtectiveArea = ObjsInSight(oTarget,"Unit");
	Alert = Intersect(ProtectiveArea,EnemyObjs(oTarget.player(),"Unit"));
  while(1)
  {
     ol = qryDef.GetObjList();
	   for(j = 0; j < ol.count; j += 1)
	   {
            o = ol[j];
			if(o.AsUnit.hero.IsValid)
				continue;
			
            if(oTarget.pos.Dist(o.pos) > oTarget.sight*8/3)
	  	      {
              //pr(oTarget.pos.Dist(o.pos));
              o.SetCommand("enter", oTarget); 
	  	      } else
	  	      if(oTarget.pos.Dist(o.pos) < oTarget.sight/2 && o.command == "enter")
		        {
		        	o.SetCommand("advanceenter", oTarget); 
	  	      }

			  
	   }
	  olAttackers = Alert.GetObjList;
	  if(olAttackers.count != 0)
	  {
	  //pr("Alert :" + olAttackers[0].class);
      for(i = 0; i < ol.count; i += 1)
			  if(!ol[i].AsUnit.hero.IsValid) // fix the full expression evaluation
			  if(ol[i].command != "advance" && ol[i].command != "engage")
						ol[i].SetCommand("advance", olAttackers[0].pos);

		}

    Sleep(1000);
  }
} else
{
// This code guards an outpost 

  if(tgtclass == "GOutpost" || 
     tgtclass == "ROutpost")
  {
    oTarget = set.GetCentralBuilding;
    ol.SetCommand("advanceenter", oTarget);
	//pr("Advance-Enter");
//	Sleep(20000);
    while(1)
    {
      ol = qryDef.GetObjList();
      qryAttackers = Intersect(ObjsInCircle(oTarget.pos, oTarget.sight+550,"Object"), Union(EnemyObjs(oTarget.player, "Unit"), EnemyObjs(oTarget.player, "Catapult")));
      olAttackers = qryAttackers.GetObjList();
      if(olAttackers.count > 0)
      {
         //pr(olAttackers.count);
         if(oTarget.health < oTarget.maxhealth*2/3 || set.loyalty < 75)
         {
            ol.SetCommandOffset("advance", olAttackers[0].pos);
            ol.AddCommand(true, "advanceenter", oTarget);
         }
         //pr("catapult ...?");
         for(j = 0; j < olAttackers.count; j += 1)
         {
            if(olAttackers[j].AsCatapult.IsValid)
            if(olAttackers[j].AsCatapult.IsBuilt)
            { 
              //pr("catapult found");
        	    for(i = 1; i < ol.count; i += 1)
	            {
                	if(ol[i].AsUnit.hero.IsValid)
						continue;
					if(ol[i].range > 100)
					  ol[i].SetCommand("attack", olAttackers[j]);
					else
					  ol[i].SetCommand("advance", olAttackers[j].pos);
              }
              break;
            }
         }
      }	
	    for(j = 0; j < ol.count; j += 1)
	    {
  		  o = ol[j];
			if(o.AsUnit.hero.IsValid)
				continue;
        if(o.AsUnit.IsValid)
        {
          if(!o.AsUnit.InHolder)
          {
            if(o.command == "idle")
            {
              o.SetCommand("advanceenter", oTarget); 
            }
            if(oTarget.pos.Dist(o.pos) > oTarget.sight*4/3)
	  	      {
	  	      	//pr("entering back "+j);
              //pr(oTarget.pos.Dist(o.pos));
              o.SetCommand("enter", oTarget); 
	  	      } else
	  	      if(oTarget.pos.Dist(o.pos) < oTarget.sight/2 && o.command == "enter")
		        {
		        	//pr("advance entering back "+j);
		        	o.SetCommand("advanceenter", oTarget); 
	  	      }
          }
        }
	    }
      Sleep(2000);
    }
  } else
// This code guards a village 
  if(tgtclass == "GVillage" || 
     tgtclass == "RVillage")
  {
    oTarget = set.GetCentralBuilding;
    qryAttackers = Intersect(UnitsAroundSettlement(Target, "Unit"), EnemyObjs(oTarget.player, "Unit"));
    ol.SetCommandOffset("advance", oTarget.pos + Point(200, 200));
    n = -1;
    while(1)
    {
      i = rand(4);
      ol = qryDef.GetObjList();
      if(qryAttackers.count > 0)
      {
        n = -1;
      } else
      {
          n += 1;
      }
//      pr("Time w/o enemies "+n);
      for(j = 0; j < ol.count; j += 1)
	    {
        o = ol[j];
		if(o.AsUnit.hero.IsValid)
			continue;
        if(o.command == "idle" || o.command == "move")
        {
          if(n > 2 || !oEnemy.IsValid)
          {
            pt = oTarget.pos - o.pos;
            if(rand(2)) 
            {
              pt.Set(-pt.x, pt.y);
            }
            if(rand(2)) 
            {
              pt.Set(pt.x, -pt.y);
            }
            o.SetCommand("move", oTarget.pos + pt);
          } else
            o.SetCommand("advance", oEnemy.pos);
        }
        if(o.command == "engage" && n > 2)
        {
          o.AddCommand(true, "move", oTarget.pos); 
          o.KillCommand();
        } else
        {
          oEnemy = o.AsUnit.BestTargetInSquadSight;
        }
      }
      Sleep(2000); 
    }
  }
}