// void, Obj me, Obj u

Hero this;
Building b;
int i;

this = me.AsHero();
b = u.AsBuilding();

if (!b.IsValid() || !this.IsValid()) return;
if(.player != u.player) {//all checks are player based, not relation based, to allow capture of allied settlements

//move near the building
	.FormSetupAndMoveTo(b, 100, 100, false);
	while(.HasPath() && .DistTo(b) > .sight*2/3 && .IsAlive() && .IsValidCaptureTarget(b))
	{
		.FormKeepMoving(1500);	
	}

//command the army first
	.army.ClearDead();
	for (i=0; i<.army.count; i+=1)
		if (.army[i].IsValidCaptureTarget(b))
			.army[i].SetCommand("capture", b);
		else
			.army[i].SetCommand("idle");
		
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
}