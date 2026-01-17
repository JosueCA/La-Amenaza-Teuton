// void, Obj This, bool bCanceled

Unit this;
if( ! bCanceled ) return;
this = This.AsUnit;
if( .GetShipToBoard.IsValid )
	.GetShipToBoard.NotifyBoardUnitCancel( this );