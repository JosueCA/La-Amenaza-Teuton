// void, Obj This

Unit  this;
point ptm;

this = This.AsUnit;
ptm = .pos;
.Disappear;
.AddToStoreBin;
Sleep( 2000 );
.RemoveFromStoreBin;
.SetPos( ptm );

if(  ptm.x == -1 ) pr("Unit dissapear: unable to recover old position 1!");
if( .pos.x == -1 ) pr("Unit dissapear: unable to recover old position 2!");