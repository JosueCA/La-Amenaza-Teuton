// void, Obj me, Obj u

Unit this;
Building b;

this = me.AsUnit();
b = u.AsBuilding();

if (!b.IsValid() || !this.IsValid()) return;
if(.player != u.player)
	while(u.IsAlive() && .IsValidCaptureTarget(u))
	{
		if(.player == u.player) return;
		if(.Goto(u, 250, 5000, true, 2500))
		{
			while (.player != u.player) {
				if (b.settlement.loyalty==0) {
					b.settlement.SetPlayer(.player);
					return;
				}
				if (.IsEnemy(b))
					UserNotification("building attacked", "", b.pos, b.player);
				if(!.IsVisible)
					.SetVisible(true);
				b.settlement.DecreaseLoyalty(1);
				.Face(b.pos);
				.Taunt(2000);
			}
		}
	}
