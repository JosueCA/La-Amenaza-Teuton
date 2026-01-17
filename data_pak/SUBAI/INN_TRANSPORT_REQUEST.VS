//void, Obj b

Building this;
Query qPartyInSight;

this = b.AsBuilding();
qPartyInSight = Intersect(ObjsInSight(this,"Unit"), PartyQuery());

if(.IsValid())
{
	if (GetInnState(this) != 1) {
		pr(Translate("This inn is closed."));
		return;
	}

	if (qPartyInSight.count == Party().count) {
		.PopTransportationUI();
	} else {
		ObjList p;
		int i;
		bool bTransporting;
		//see if anyone else from the party tries to transport
		p = Party(); 
		bTransporting = false;
		for (i=0; i<p.count; i+=1) {
			if (p[i].command == "transport") {
				bTransporting = true;
				break;
			}
		}
		if (!bTransporting) {
			pr(Translate("Gather your party before travelling."));
			return;
		}

		Sleep(5000);
		if (qPartyInSight.count == Party().count) {
			.PopTransportationUI();
		} else {
			pr(Translate("Gather your party before travelling."));
		}
	}
}
