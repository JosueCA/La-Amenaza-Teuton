// void, Obj This, Obj other

Unit this;
Settlement sle, invalid;

if(other.AsUnit.IsValid())
{
	this = This.AsUnit();
	while(other.IsAlive())
	{
    Obj teleport; teleport = FindTeleport(.player, .posRH, other.posRH);
    if (!.AI) if (teleport.IsValid) if (.posRH.Dist(teleport.pos) > 1000) teleport.Clear;
    if (teleport.IsValid) {
	  	.AddCommand(true, "follow", other);
  		.AddCommand(true, "teleport", teleport);
      return;
    }

		if(other.AsUnit.InHolder)
		{
			Settlement sett;
			sett = other.AsUnit.GetHolderSett();
			if(sett.IsValid)
			{//goto enter
				point pt;
				Building bld;
				if(sle == sett)
				{
					Sleep(3000);
					continue;
				}
				bld = sett.GetCentralBuilding();
				if( bld.IsValid ) {
					if( bld.IsHeirOf( "BaseRuins" )) {
						Sleep(11000);
					  	.AddCommand(true, "follow", other);
						return;
					} else if( bld.IsHeirOf("Catapult") ) {
						Sleep(1000);
						.AddCommand(true, "follow", other);
						return;
					}
					pt = bld.GetEnterPoint(this);
					while(other.IsAlive())
					{
						if(other.AsUnit.InHolder)
						{
							.SetEntering(true);
							if(.GotoEnter(pt, 0, 1000, false, -1))
							{
								sett.AddUnit(this);
								sle = sett;
								break;
							}
						}
						else break;
					}
				}
			}
			else
				return; // Followed unit in ship case
		}
		else
		{
			sle = invalid;
			.SetEntering(false);
			if(.Goto(other, 70, 1000, true, -1)) Sleep(1500);
		}
	}
}