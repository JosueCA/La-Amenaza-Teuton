// void, Obj This, point pt


Druid this;
Unit tgt;
int  time, retries, try;

this = This.AsDruid;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

tgt = .FindUnit2HTL(1);
while (!.Goto(pt, 0, 2000, true, -1))
	{
		if(tgt.IsValid)
		if(.DistTo(pt) < .sight)
			break;
		tgt = .FindUnit2HTL(1);
		if (.TimeWithoutWalking() > 2500) break;
	}

if(!tgt.IsValid)
{
	tgt = .FindUnit2HTL(1);
	while (try < retries && !tgt.IsValid()) {
		Sleep(time);
		tgt = .FindUnit2HTL(1);
		try += 1;
	}
}
if(tgt.IsValid) {
	.AddCommand(true, "heal", pt);
	.AddCommand(true, "heal", tgt);
}
