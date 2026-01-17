 // void, Obj me

 Tower this;
 Unit u;

 this = me.AsTower();
 if (!.IsValid) return; // added by Miho to remove an annoyng message

 //.pr("FireTower::Guard");

 while (1) {      
 	//.pr("Looking for best target");
 	u = .BestTarget();
 	if (!u.IsValid()) {
 		//.pr("Best target not found, sleeping for 1000");
 		Sleep(1000); 
 		continue;
 	}                                               
 	//.pr("Trying to attack enemy");
 	while (.Attack(u)) {      
		
 		//.pr("Attacked enemy!");
 		//.pr("FireTower::Guard - attacking");
 		Sleep(100);
 	}                      
 	Sleep(500);
 }