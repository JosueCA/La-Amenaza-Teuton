// void, Obj This, point pt

bool b;
Unit this;
point ptOld;

this = This.AsUnit();


if (This.AsHero().IsValid()) {
	if (This.AsHero().army.count() != 0) return;
}

//pr("explore start");
//if the user gives an impassable or unreachable point for goto
while (1) {
//	pr("goto start");
	ptOld = .posRH;
	b = .Goto(pt, 0, 3000, true, -1);
	if (b) break; //reached the point
	if (.pos == ptOld) //not moved for a while
		break; //give up and recast to a new point
}

//if (.pos == ptOld) pr("cannot reach the start, begin from here");
//else pr("start reached, exploring");

while (1) {
//	pr("recast");
	pt = .GetUnexploredPoint(-1);
	if (pt.x == -1) break; //cannot go anywhere
	while (1) {
		//pr("going...");
		ptOld = .posRH;
		b = .Goto(pt, 0, 5000, true, -1);
		if (b) break;
		if (ptOld == .posRH)
			break; //stuck again :(
	}
//	if (b) pr("reached!"); else pr("stuck!");
}
//pr("explore end");