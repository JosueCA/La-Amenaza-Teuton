// void, str GroupName, str TargetArea

// Guard AI Helper

Obj target, obj;
Query qry;
ObjList ol;
point pt, ptofs;
int i, n, ang, wavecount, j;
int state;
int Attacker, retreat_timeout;

// state 0 means waiting; state 1 means attacking
state = 0;
retreat_timeout = 0;
pt = GetRandomPointInArea(TargetArea);
ang = rand(360);


n = 0;
qry = Group(GroupName);

target = GetNamedObj(TargetArea).obj;


AttackArea(qry, TargetArea);

while(1)
{
  ol = qry.GetObjList();
  for(i = 0; i < ol.count(); i += 1)
  {
    obj = ol[i];
	if(obj.AsUnit.hero.IsValid)
	   continue;
	if(!obj.IsAlive()) continue;
    
	if(obj.command == "engage")
    {
       Attacker = 0;
       for(j = 0; j < ol.count(); j += 1)
       {
          if(ol[j].AsUnit)
          if(ol[j].AsUnit.TimeWithoutAttack < 2500)
            Attacker += 1;
       }
       if(retreat_timeout == 0)
         retreat_timeout = 10;
       if(Attacker > 2 || retreat_timeout > 2)
       {
         target = obj.AsUnit.BestTargetInSquadSight;
         n = 20;
         if(retreat_timeout > 2)
           retreat_timeout -= 1;
       } else
       {
         //pr("Let's Get Back from Where we Started");
		   ol.ClearDead();
         for(j = 0; j < ol.count(); j += 1)
         {
            ol[j].SetCommand("move", GetRandomPointInArea(TargetArea));
         }
         retreat_timeout = 0;
       }
    } else
    {
       if(n > 0 && target.IsValid)
       {
          obj.AddCommand(true, "advance", target.pos);
          obj.KillCommand();
       } else
       {
         if(obj.command == "idle")
          {
          pt = GetRandomPointInArea(TargetArea);
          obj.AddCommand(true, "advance", pt);
          obj.KillCommand();
          }  
       }
    }
    n -= 1;
    if(ol.count/6 != 0)
      if((i%(ol.count/6)) == 0)
      {
         Sleep(750);
      }
  }
  if (ol.count==0) return;
  Sleep(750);
} 