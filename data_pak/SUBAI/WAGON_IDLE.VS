// void, Obj This

int prev_health;
point pt;
Wagon this;

this = This.AsWagon();

//.pr("Wagon::idle");

// We can make the wagon to run to the nearest friendly army, so
// the enemies will have a little surprise :)
// For now just run away to a random point on the map (MAP SIZE 8192 ASSUMED!!!)

prev_health = .health;

while (1) {
	Sleep(1000);
// Disabled, because when the wagon gets hungry it gets mad
/*	if (prev_health!=.health)
		{
			pt.Set(rand(8192),rand(8192));
			.Goto(pt,2000);
			while (.HasPath())
				if (!.Goto(pt,2000))
					.CancelPath();
			prev_health = .health;
		}*/
}