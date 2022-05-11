global interface IS_RFRetryInterface {
	
    List<IS_ValidationError> RFinvokeRetryRequest(ID applicationID, ID disbursementID, Boolean mockEnable, String requestedName, Id exceptionLogId);

}