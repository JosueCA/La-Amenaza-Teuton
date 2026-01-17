// void, Obj me, Obj target


Unit this;

this = me.AsUnit();
while (!.Stop(2000)); //wait to stop
while (1) { //wait to die :)
	//Sleep(10000);
	.StartAnim(18, target.pos);
	Sleep(.TimeToAnimFinish());
	Sleep(500 + rand(1000));
}
 