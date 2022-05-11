//Generated by wsdl2apex

public class AsyncConsumerAnzCapitalGeComOriginations {
    public class cancelApplicationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.cancelApplicationResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.cancelApplicationResponse_element response = (consumerAnzCapitalGeComOriginations.cancelApplicationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class updateApplicationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.updateApplicationResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.updateApplicationResponse_element response = (consumerAnzCapitalGeComOriginations.updateApplicationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class approveApplicationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.approveApplicationResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.approveApplicationResponse_element response = (consumerAnzCapitalGeComOriginations.approveApplicationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class acceptContractResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.acceptContractResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.acceptContractResponse_element response = (consumerAnzCapitalGeComOriginations.acceptContractResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class verifyAMLResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.verifyAMLResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.verifyAMLResponse_element response = (consumerAnzCapitalGeComOriginations.verifyAMLResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class confirmContractReceivedResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_element response = (consumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class verifyPOIResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.verifyPOIResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.verifyPOIResponse_element response = (consumerAnzCapitalGeComOriginations.verifyPOIResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class checkHealthResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.checkHealthResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.checkHealthResponse_element response = (consumerAnzCapitalGeComOriginations.checkHealthResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class submitApplicationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.submitApplicationResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.submitApplicationResponse_element response = (consumerAnzCapitalGeComOriginations.submitApplicationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class declineApplicationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public consumerAnzCapitalGeComOriginations.declineApplicationResponse_element getValue() {
            consumerAnzCapitalGeComOriginations.declineApplicationResponse_element response = (consumerAnzCapitalGeComOriginations.declineApplicationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class AsyncOriginationApplicationServiceSOAP {
        public String endpoint_x = 'REPLACE_WITH_ACTUAL_URL';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/context', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/brokerdetails', 'consumerAnzCapitalGeComOriginations', 'http://common.model.servicing.ge.com', 'commonModelServicingGeCom', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/amldetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/productdetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice', 'consumerAnzCapitalGeComOriginations', 'http://application.model.servicing.ge.com', 'applicationModelServicingGeCom', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/disbursementdetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/fingerprint', 'consumerAnzCapitalGeComOriginations', 'http://case.model.servicing.ge.com/2.0', 'caseModelServicingGeCom20', 'http://product.model.servicing.ge.com', 'productModelServicingGeCom', 'http://contact.model.servicing.ge.com', 'contactModelServicingGeCom', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/insurancedetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/offerdetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/collateraldetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/riskReferralDetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/budgetdetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/personaldetails', 'consumerAnzCapitalGeComOriginations', 'http://sales.model.servicing.ge.com', 'salesModelServicingGeCom', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/poidetails', 'consumerAnzCapitalGeComOriginations', 'http://contract.model.servicing.ge.com', 'contractModelServicingGeCom', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/contractdetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/loandetails', 'consumerAnzCapitalGeComOriginations', 'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/branchdetails', 'consumerAnzCapitalGeComOriginations'};
        public AsyncConsumerAnzCapitalGeComOriginations.cancelApplicationResponse_elementFuture beginCancelApplication(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.applicationDataType applicationData,consumerAnzCapitalGeComOriginations.riskUserDataType riskUserData) {
            consumerAnzCapitalGeComOriginations.cancelApplicationRequest_element request_x = new consumerAnzCapitalGeComOriginations.cancelApplicationRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            request_x.riskUserData = riskUserData;
            return (AsyncConsumerAnzCapitalGeComOriginations.cancelApplicationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.cancelApplicationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/cancelApplication',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'cancelApplicationRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'cancelApplicationResponse',
              'consumerAnzCapitalGeComOriginations.cancelApplicationResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.updateApplicationResponse_elementFuture beginUpdateApplication(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.applicationCustomerDataType applicationCustomerData,consumerAnzCapitalGeComOriginations.reportDetails reportDetails,consumerAnzCapitalGeComOriginations.applicationCpuOverrideDataType applicationCpuOverrideData,consumerAnzCapitalGeComOriginations.applicationSupportingDataType applicationSupportingData,consumerAnzCapitalGeComOriginations.decisionDataType decisionData,consumerAnzCapitalGeComOriginations.amlApplicantsCollection amlApplicants,consumerAnzCapitalGeComOriginations.riskUserDataType riskUserData) {
            consumerAnzCapitalGeComOriginations.updateApplicationRequest_element request_x = new consumerAnzCapitalGeComOriginations.updateApplicationRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationCustomerData = applicationCustomerData;
            request_x.reportDetails = reportDetails;
            request_x.applicationCpuOverrideData = applicationCpuOverrideData;
            request_x.applicationSupportingData = applicationSupportingData;
            request_x.decisionData = decisionData;
            request_x.amlApplicants = amlApplicants;
            request_x.riskUserData = riskUserData;
            return (AsyncConsumerAnzCapitalGeComOriginations.updateApplicationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.updateApplicationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/updateApplication',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'updateApplicationRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'updateApplicationResponse',
              'consumerAnzCapitalGeComOriginations.updateApplicationResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.approveApplicationResponse_elementFuture beginApproveApplication(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.approveApplicationDataType applicationData) {
            consumerAnzCapitalGeComOriginations.approveApplicationRequest_element request_x = new consumerAnzCapitalGeComOriginations.approveApplicationRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            return (AsyncConsumerAnzCapitalGeComOriginations.approveApplicationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.approveApplicationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/approveApplication',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'approveApplicationRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'approveApplicationResponse',
              'consumerAnzCapitalGeComOriginations.approveApplicationResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.acceptContractResponse_elementFuture beginAcceptContract(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.acceptContractDataType applicationData) {
            consumerAnzCapitalGeComOriginations.acceptContractRequest_element request_x = new consumerAnzCapitalGeComOriginations.acceptContractRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            return (AsyncConsumerAnzCapitalGeComOriginations.acceptContractResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.acceptContractResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/acceptContract',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'acceptContractRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'acceptContractResponse',
              'consumerAnzCapitalGeComOriginations.acceptContractResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.verifyAMLResponse_elementFuture beginVerifyAML(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.verifyAMLDataType applicationData) {
            consumerAnzCapitalGeComOriginations.verifyAMLRequest_element request_x = new consumerAnzCapitalGeComOriginations.verifyAMLRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            return (AsyncConsumerAnzCapitalGeComOriginations.verifyAMLResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.verifyAMLResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/verifyAML',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'verifyAMLRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'verifyAMLResponse',
              'consumerAnzCapitalGeComOriginations.verifyAMLResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_elementFuture beginConfirmContractReceived(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.confirmContractReceivedDataType applicationData) {
            consumerAnzCapitalGeComOriginations.confirmContractReceivedRequest_element request_x = new consumerAnzCapitalGeComOriginations.confirmContractReceivedRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            return (AsyncConsumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/confirmContractReceived',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'confirmContractReceivedRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'confirmContractReceivedResponse',
              'consumerAnzCapitalGeComOriginations.confirmContractReceivedResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.verifyPOIResponse_elementFuture beginVerifyPOI(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.verifyPOIDataType applicationData) {
            consumerAnzCapitalGeComOriginations.verifyPOIRequest_element request_x = new consumerAnzCapitalGeComOriginations.verifyPOIRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            return (AsyncConsumerAnzCapitalGeComOriginations.verifyPOIResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.verifyPOIResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/verifyPOI',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'verifyPOIRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'verifyPOIResponse',
              'consumerAnzCapitalGeComOriginations.verifyPOIResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.checkHealthResponse_elementFuture beginCheckHealth(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.checkHealthDataType checkHealthData) {
            consumerAnzCapitalGeComOriginations.checkHealthRequest_element request_x = new consumerAnzCapitalGeComOriginations.checkHealthRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.checkHealthData = checkHealthData;
            return (AsyncConsumerAnzCapitalGeComOriginations.checkHealthResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.checkHealthResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/checkHealth',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'checkHealthRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'checkHealthResponse',
              'consumerAnzCapitalGeComOriginations.checkHealthResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.submitApplicationResponse_elementFuture beginSubmitApplication(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.applicationCustomerDataType applicationCustomerData,consumerAnzCapitalGeComOriginations.applicationSupportingDataType applicationSupportingData,consumerAnzCapitalGeComOriginations.amlApplicantsCollection amlApplicants) {
            consumerAnzCapitalGeComOriginations.submitApplicationRequest_element request_x = new consumerAnzCapitalGeComOriginations.submitApplicationRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationCustomerData = applicationCustomerData;
            request_x.applicationSupportingData = applicationSupportingData;
            request_x.amlApplicants = amlApplicants;
            return (AsyncConsumerAnzCapitalGeComOriginations.submitApplicationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.submitApplicationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/submitApplication',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'submitApplicationRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'submitApplicationResponse',
              'consumerAnzCapitalGeComOriginations.submitApplicationResponse_element'}
            );
        }
        public AsyncConsumerAnzCapitalGeComOriginations.declineApplicationResponse_elementFuture beginDeclineApplication(System.Continuation continuation,consumerAnzCapitalGeComOriginations.ServiceContext serviceContext,consumerAnzCapitalGeComOriginations.applicationDataType applicationData,consumerAnzCapitalGeComOriginations.riskUserDataType riskUserData) {
            consumerAnzCapitalGeComOriginations.declineApplicationRequest_element request_x = new consumerAnzCapitalGeComOriginations.declineApplicationRequest_element();
            request_x.serviceContext = serviceContext;
            request_x.applicationData = applicationData;
            request_x.riskUserData = riskUserData;
            return (AsyncConsumerAnzCapitalGeComOriginations.declineApplicationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncConsumerAnzCapitalGeComOriginations.declineApplicationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice/declineApplication',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'declineApplicationRequest',
              'http://consumer.anz.capital.ge.com/originations/2013/09/applicationservice',
              'declineApplicationResponse',
              'consumerAnzCapitalGeComOriginations.declineApplicationResponse_element'}
            );
        }
    }
}