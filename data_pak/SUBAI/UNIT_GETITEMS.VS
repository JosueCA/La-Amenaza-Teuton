// void, Obj This, Obj other

Unit this;
ItemHolder holder;

this = This.AsUnit();
holder = other.AsItemHolder();

if (holder.IsAlive())
	{
		while (!.Goto(holder,GetConst("GiveDistance"),5000,true,5000));
			if(!holder.IsAlive())
				return;
		if(!.IsVisible)
			.SetVisible(true);
		.OpenItemHolder(holder);
	}
