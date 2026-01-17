// void, Obj This, point pt

Unit this;
this = This.AsUnit;
.Goto( pt, 0, 3000, true, -1 );
.AddCommand( false, "selfdestroy" );