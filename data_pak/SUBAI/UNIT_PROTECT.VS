// void, Obj me, Obj master_obj

Unit this, u, master;
point offs;
bool b;

this = me.AsUnit();
master = master_obj.AsUnit();
offs = .posRH - master.posRH;

//.pr("unit::protect: protecting");

while (master.IsAlive()) 
{
  u = .BestTargetInSquadSight();
  if(u.IsValid())
  {
		.AddCommand(true, "protect", master_obj);
		.AddCommand(true, "engage");
		return;
	} else
	{
		if (.Goto(master.dest + offs, .range, 2000, true, -1)) 
		{
			.Idle(2000);
		}
	}
}

//.pr("unit::protect: protected object is dead");
