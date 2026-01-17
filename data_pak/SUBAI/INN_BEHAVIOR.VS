// void, Obj This


Building this;
Query qPartyInSight;
str note;

this = This.AsBuilding();

Sleep(300); //give chance to other scripts to make this inn known, so the notification wouldn't come

while (1) {
	while (GetInnState(this) != 3) Sleep(5000);
	qPartyInSight = Intersect(ObjsInSight(this,"Unit"), PartyQuery());

	WaitNonEmptyQuery(qPartyInSight, -1);
	note = Translatef("Inn found: %s1, %s2.", .name, MapName());
	UserNotification("inn spotted",note, .pos(), Party()[0].player);
	SetInnState(this, 1);
}

