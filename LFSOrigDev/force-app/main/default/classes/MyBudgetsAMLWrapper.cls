/* @Description: Wrapper class for AML and POA
 * @Author: Fahad Akhtar
 * @Date Created: DEC-10-2014
 * @History:
   =====================================================================
         04-08-15: Updated Defect 696 - Removed the server side number of characters and special character validation since issuing country is now a picklist field. - DYU
         04-09-15: Removed the validation that reference to PRS - DYU
         04-20-15: Updated Defect 896 - Add client side validation to ID number for NZ Driver Licence type - DY
   =====================================================================
 */
//===============================================================
//                    INNER CLASSES / WRAPPERS
//===============================================================
/*  Description: Wrapper class for the AML object
 *  Author: Fahad Akhtar
 *  Date Created: DEC-10-2014
 */
public class MyBudgetsAMLWrapper {

    public AML__c aml {
        get;
        set;
    }

    /*  Description: Wrapper constructor, creates new AML, refreshes validations
     *  Author: Fahad Akhtar
     *  Date Created: DEC-10-2014
     *  Input Parameters: None
     *  Return: N/A
     */

    public MyBudgetsAMLWrapper(Applicant__c applicant) {
        this.aml = new AML__c(Applicant__c = applicant.Id);
    }

    public MyBudgetsAMLWrapper(AML__c oldAML) {
        this.aml = oldAML;
    }

    /*  Description: Validates all AML fields in the wrapper
     *  Author: Fahad Akhtar
     *  Date Created: DEC-10-2014
     *  Input Parameters:
     *  Return: N/A
     */
    public Boolean validatePreSubmitAML(Boolean isStaffUI, AML__c aml, personalDetailsWrapper applicantWrapper) {
        Boolean validationResult = true;

        if (applicantWrapper.applicationCountry == GEN_OriginationsConstants.NZ_REGION) {
            //Validation rules for Pre-Submit AML
            Boolean isCountryMandatory = false;
            Integer maxCharsId = 16;

            if (aml.Identification__c == null) {
                applicantWrapper.errorCustomerIdType = true;
                applicantWrapper.errorCustomerIdTypeMsg = 'Error: Please select customer id type.';
                validationResult = false;
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE) {
                maxCharsId = 8;
                if (aml.version__c == null) {
                    applicantWrapper.errorVersion = true;
                    applicantWrapper.errorVersionMsg = 'Error: Please enter version number';
                    validationResult = false;
                } else if (aml.Version__c.length() > 3) {
                    applicantWrapper.errorVersion = true;
                    applicantWrapper.errorVersionMsg = 'Error: Version must consist of 3 characters or less.';
                    validationResult = false;
                } else if (!validateNumeric(aml.Version__c)) {
                    applicantWrapper.errorVersion = true;
                    applicantWrapper.errorVersionMsg = 'Error: No spaces hyphens or special characters allowed.';
                    validationResult = false;
                }
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_AUSTRALIA_PASSPORT) {
                isCountryMandatory = true;
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_OVERSEAS_PASSPORT) {
                isCountryMandatory = true;
                if (aml.NZ_Residency_Number__c == null) {
                    applicantWrapper.errorNZResidencyNumber = true;
                    applicantWrapper.errorNZResidencyNumberMsg = 'Error: Please enter NZ residency number.';
                    validationResult = false;
                } else if (aml.NZ_Residency_Number__c.length() > 10) {
                    applicantWrapper.errorNZResidencyNumber = true;
                    applicantWrapper.errorNZResidencyNumberMsg = 'Error: NZ residency number must consist of 10 characters or less.';
                    validationResult = false;
                } else if (!APP_CommonExt.validateLicense(aml.NZ_Residency_Number__c)) {
                    applicantWrapper.errorNZResidencyNumber = true;
                    applicantWrapper.errorNZResidencyNumberMsg = 'Error: No spaces hyphens or special characters allowed.';
                    validationResult = false;
                }
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_CERTIFIED_DOCUMENTS_REQUIRED) {
                if (!isStaffUi) {
                    applicantWrapper.errorOtherdocument = true;
                    applicantWrapper.errorOtherdocumentMsg = 'Application will be conditionally approved subject to further credit checks and validation checks. Please call our Customer Service team to discuss other acceptable type of ID for verification';
                }
            }
            System.debug('ID-->' + aml.Identification__c + '-->' + aml.ID_No__c);

            if (aml.Identification__c != 'SuperGold card with Photo') {
                if (aml.ID_No__c == null) {
                    applicantWrapper.errorIdType = true;
                    applicantWrapper.errorCustomerIdNumberMsg = 'Error: Please enter id number.';
                    validationResult = false;
                } else if (!APP_CommonExt.validateLicense(aml.ID_No__c)) {
                    applicantWrapper.errorIdType = true;
                    applicantWrapper.errorCustomerIdNumberMsg = 'Error: No spaces hyphens or special characters allowed.';
                    validationResult = false;
                } else if (aml.ID_No__c.length() > maxCharsId) {
                    applicantWrapper.errorIdType = true;
                    applicantWrapper.errorCustomerIdNumberMsg = 'Error: Driver Licence must consist of 8 characters.';
                    validationResult = false;
                } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE &&
                    !validateIDNumber(aml.ID_No__c)) {
                    applicantWrapper.errorIdType = true;
                    applicantWrapper.errorCustomerIdNumberMsg = 'Error: First two must be alpha characters and last six must be numeric characters.';
                    validationResult = false;
                }
            }
            System.debug('AML:' + aml);

            /*if(aml.Identification__c != GEN_OriginationsConstants.CUSTOMERTYPEID_CERTIFIED_DOCUMENTS_REQUIRED){
            if (aml.ID_Expiry_Date__c == NULL) {
                System.debug('AML-ExpiryDate:' + aml);
                if (applicantWrapper.applicant.Sec_ID_Expiry_Date__c == NULL) {
                    applicantWrapper.errorSecIDExpiryDate = true;
                    applicantWrapper.errorSecIDExpiryDateMsg = 'Error: Please enter expiry date.';
                }

                validationResult = false;
            } else if (aml.ID_Expiry_Date__c <= Date.today()) {
                if (applicantWrapper.applicant.Expiry_Date__c <= Date.today()) {
                    applicantWrapper.errorExpirydate = true;
                    applicantWrapper.errorExpirydateMsg = 'Error: The identification must expire after today.';
                }
                validationResult = false;
            }

            } */



            if (isCountryMandatory && aml.Issue_Country__c == null) {
                applicantWrapper.errorIssuingcountry = true;
                applicantWrapper.errorIssuingcountryMsg = 'Error: Please enter issue country.';
                validationResult = false;
            }
            
            /*
                Updated by DYU 04-08-2015 - Defect 696 
              - Removed the server side number of characters and special character validation since issuing country is now a picklist field.
            */
            /*if (aml.Issue_Country__c != null) {
                if (aml.Issue_Country__c.length() > 30) {
                    applicantWrapper.errorIssuingcountry = true;
                    applicantWrapper.errorIssuingcountryMsg = 'Error: Issue Country must consist of 30 characters or less.';
                    validationResult = false;
                } else if (!validateName(aml.Issue_Country__c)) {
                    applicantWrapper.errorIssuingcountry = true;
                    applicantWrapper.errorIssuingcountryMsg = 'Error: No hyphens or special characters allowed.';
                    validationResult = false;
                }
            }*/
        }

        return validationResult;
    }

    /*------------------------------------------------------------
     Author: Michael Lasala
     Company: Cloud Sherpas
     Description: Validation method for AML in Staff UI
     Inputs: Region, AML__c
     Returns: List<String>
     History
     12/11/14       Michael Lasala      Created
     ------------------------------------------------------------*/
    public List < String > validateStaffAML(String region, AML__c aml) {
        List < String > errorMessages = new List < String > ();

        if (region == GEN_OriginationsConstants.AU_REGION) {
            //Validation rules for Australia

            if (aml.Identification__c == 'Driving Licence' ||
                aml.Identification__c == 'Learning Permit' ||
                aml.Identification__c == 'Proof of Age' ||
                aml.Identification__c == 'Pension Card' ||
                aml.Identification__c == 'WA Driver Licence') {

                if (aml.ID_No__c == null) {
                    errorMessages.add('Please enter ID No.');
                } 
                //Updated by DYU 04-09-15 - Remove the PRS validation
                /*else if ((aml.ID_No__c != null && aml.ID_No__c != '') && aml.ID_No__c == 'ERR1') { 
                
                    errorMessages.add('ID No. must be less than 11 characters.');
                }*/

                if (aml.ID_Expiry_Date__c == null) {
                    errorMessages.add('Please enter Expiry Date.');
                }

                if (aml.ID_Expiry_State__c == null) {
                    errorMessages.add('Please enter Expiry State.');
                }

                if (aml.Issue_Country__c == null) {
                    errorMessages.add('Please enter Issue Country.');
                }
            }

            if (aml.Identification__c == 'Centrelink Statement' ||
                aml.Identification__c == 'ATO Assessment Notice' ||
                aml.Identification__c == 'Rates Notice' ||
                aml.Identification__c == 'Utility Bill' ||
                aml.Identification__c == 'Insurance - Home and Contents OR Comprehensive Motor Vehicle' ||
                aml.Identification__c == 'Electoral Roll Confirmation Letter' ||
                aml.Identification__c == 'Birth Certificate') {

                if (aml.ID_Issue_Date__c == null) {
                    errorMessages.add('Please enter Issue Date.');
                } else if ((aml.ID_Issue_Date__c != null) && aml.ID_Issue_Date__c > Date.today()) {
                    errorMessages.add('Issue Date must be before or equal to today\'s Date.');
                }

                if (aml.ID_Issuer__c == null) {
                    errorMessages.add('Please enter Issuer.');
                }
            }

            if (aml.Identification__c == 'AUS Passport' ||
                aml.Identification__c == 'Overseas Passport') {

                if (aml.ID_No__c == null) {
                    errorMessages.add('Please enter ID No.');
                
                } 
                //Updated by DYU 04-09-15 - Remove the PRS validation
                /*else if ((aml.ID_No__c != null && aml.ID_No__c != '') && aml.ID_No__c == 'ERR1') {
                    errorMessages.add('ID No. must be less than 11 characters.');
                }*/

                if (aml.ID_Expiry_Date__c == null) {
                    errorMessages.add('Please enter Expiry Date.');
                }

                if (aml.Issue_Country__c == null) {
                    errorMessages.add('Please enter Issue Country.');
                } else if (aml.Identification__c == 'Overseas Passport' && aml.Issue_Country__c == GEN_OriginationsConstants.AML_COUNTRY_AU) {
                    errorMessages.add('Issue Country is invalid for Identification.');
                }
            }

        } else if (region == GEN_OriginationsConstants.NZ_REGION) {
            //Validation rules for New Zealand

            Boolean isCountryMandatory = false;
            Integer maxCharsId = 16;

            if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE) {
                maxCharsId = 8;
                if (aml.Version__c == null) {
                    errorMessages.add('Please enter Version.');
                } else if (aml.Version__c.length() > 3) {
                    errorMessages.add('Version must consist of 3 characters or less..');

                } else if (!validateNumeric(aml.Version__c)) {
                    errorMessages.add('Version must have no spaces, hyphens or special characters.');
                }
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_AUSTRALIA_PASSPORT) {
                isCountryMandatory = true;
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_OVERSEAS_PASSPORT) {
                isCountryMandatory = true;
                if (aml.NZ_Residency_Number__c == null) {
                    errorMessages.add('Please enter NZ Residency Number.');
                } else if (aml.NZ_Residency_Number__c.length() > 10) {
                    errorMessages.add('NZ residency number must consist of 10 characters or less.');
                } else if (!APP_CommonExt.validateLicense(aml.NZ_Residency_Number__c)) {
                    errorMessages.add('NZ residency number must have no spaces, hyphens or special characters.');
                }
            }

            if (aml.ID_No__c == null) {
                errorMessages.add('Please enter ID Number.');
            } else if (!APP_CommonExt.validateLicense(aml.ID_No__c)) {
                errorMessages.add('ID Number must have no spaces hyphens or special characters.');
            }
            //Commented out by DYU 04-20-15 - Defect 896 - Validation moved to client side since field is tokenized PRS
            /*else if (aml.ID_No__c.length() > maxCharsId) {
                system.debug('id number length: '+aml.ID_No__c+'--'+aml.ID_No__c.length()+'--'+maxCharsId);
                errorMessages.add('ID Number must consist of ' + maxCharsId + ' characters.');
            } else if (aml.Identification__c == GEN_OriginationsConstants.CUSTOMERTYPEID_NZ_DRIVER_LICENSE &&
                !validateIDNumber(aml.ID_No__c)) {
                errorMessages.add('Driver Licence must consist of 8 characters for Driver Licence, The first two are alpha characters, last six are numeric characters.');
            }*/

            if (aml.Identification__c != 'SuperGold card with Photo' &&
                aml.Identification__c != 'NZ Birth Certificate' &&
                aml.Identification__c != 'NZ Certificate of Citizenship') {
                if (aml.ID_Expiry_Date__c == null) {
                    errorMessages.add('Please enter Expiry Date.');
                } else if (aml.ID_Expiry_Date__c <= Date.today()) {
                    errorMessages.add('The Identification must expire after today.');
                }
            }

            if (isCountryMandatory && aml.Issue_Country__c == null) {
                errorMessages.add('Please enter Issue Country.');
            }

            if (aml.Issue_Country__c != null) {
                if (aml.Issue_Country__c.length() > 30) {
                    errorMessages.add('Issue Country must consist of 30 characters or less.');
                }/** else if (!validateName(aml.Issue_Country__c)) {
                    errorMessages.add('Issue Country must have no spaces, hyphens or special characters.');

                }**/ else if (aml.Identification__c == 'Overseas Passport' && aml.Issue_Country__c == GEN_OriginationsConstants.AML_COUNTRY_NZ) {
                    errorMessages.add('Issue Country is invalid for Identification.');

                }
            }
        }

        return errorMessages;
    }

    /*------------------------------------------------------------
     Author: Michael Lasala
     Company: Cloud Sherpas
     Description: Proof of Address record validation
     Inputs: AML__c
     Returns: List<String>
     History
     11/27/14       Michael Lasala      Created
     ------------------------------------------------------------*/
    public List < String > validatePOA(AML__c poa) {
        List < String > errorMessages = new List < String > ();

        if (poa.POA_Type__c == null || poa.POA_Type__c == '') {
            errorMessages.add('Please select POA Type.');
        }

        if (poa.POA_Reference_Number__c == null || poa.POA_Reference_Number__c == '') {
            errorMessages.add('Please enter POA Reference Number.');
        }

        if (poa.POA_Issue_Date__c == null) {
            errorMessages.add('Please enter Issue Date.');

        } else if ((poa.POA_Issue_Date__c != null) && poa.POA_Issue_Date__c > Date.today()) {
            errorMessages.add('Issue Date must be before or equal to today\'s Date.');
        }

        if (poa.ID_Issuer__c == null || poa.ID_Issuer__c == '') {
            errorMessages.add('Please enter Issuer.');
        }

        return errorMessages;
    }

    /*  Description: Check aml category to clear the value of unwanted fields
     *  Author: Fahad Akhtar
     *  Date Created: DEC-10-2014
     *  Input Parameters: None
     *  Return: Nothing
     */
    //public void clearDebtFields(){

    //}

    public static Boolean validateIDNumber(string name) {
        Boolean flag = true;
        if (Util.nullCheck(name)) {     //05.14.15 Mike Lasala: Code Scan fix
            String patternName = '(^[a-zA-Z][A-Za-z][0-9][0-9][0-9][0-9][0-9][0-9])';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateNumeric(string name) {
        Boolean flag = true;
        if (Util.nullCheck(name)) {     //05.14.15 Mike Lasala: Code Scan fix
            String patternName = '(^[0-9]*$)';

            Pattern namePattern = Pattern.compile(patternName);
            Matcher nameMatcher = namePattern.matcher(name.trim());
            flag = nameMatcher.matches();
        }
        return flag;
    }

    public static Boolean validateName(string name) {
        Boolean flag;
        String patternName = '([a-zA-Z ' + '\']+)';

        Pattern namePattern = Pattern.compile(patternName);
        Matcher nameMatcher = namePattern.matcher(name.trim());
        flag = nameMatcher.matches();
        return flag;
    }
}