//%attributes = {"invisible":true,"preemptive":"capable"}

Case of 
	: (True:C214)
		TRACE:C157
	: (False:C215)
		Case of 
			: (True:C214)
				TRACE:C157
			: (False:C215)
				ABORT:C156
			Else 
				Case of 
					: (True:C214)
						TRACE:C157
					: (False:C215)
						ABORT:C156
					Else 
						Case of 
							: (True:C214)
								TRACE:C157
							: (False:C215)
								ABORT:C156
							Else 
								Case of 
									: (True:C214)
										TRACE:C157
									: (False:C215)
										ABORT:C156
									Else 
										Case of 
											: (True:C214)
												TRACE:C157
											: (False:C215)
												ABORT:C156
											Else 
												  //perhaps
										End case 
								End case 
						End case 
				End case 
		End case 
	Else 
		Case of 
			: (True:C214)
				TRACE:C157
			: (False:C215)
				ABORT:C156
			Else 
				  //perhaps
		End case 
End case 