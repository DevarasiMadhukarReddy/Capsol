public class GenerateRepaymentSchedule{

    loan__Loan_Account__c loanAccount;
    Id loanAccountId;
   /* loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
    Date systemDate = loanFacade.getCurrentSystemDate(); */
    Date lastAccrualDate;
    
    public GenerateRepaymentSchedule(ID loanAccId,Date lastAccDate){
        loanAccountId = loanAccId;
        lastAccrualDate = lastAccDate;
    }
    
    public GenerateRepaymentSchedule(){
        
    }
    public loan__loan_Account__C getLoanAccountDetails(Id loanAccId){
       loan__loan_Account__c loanAccountQueried = new loan__loan_Account__c();
       
       loanAccountQueried = [SELECT ID,Name,
                          loan__Principal_Paid__c,
                          loan__Interest_Paid__c,
                          loan__Fees_Paid__c,
                          loan__Last_Accrual_Date__c,
                          loan__Payoff_Fee_Indicator__c,
                          loan__Excess__c,
                          loan__Fee_Set__c,
                          loan__Expected_Disbursal_Date__c,
                          loan__Next_Installment_Date__c, 
                          loan__Due_Day__c,
                          loan__Disbursal_Date__c,
                          loan__Principal_Interest_EMI_generated_on_req__c,
                          loan__Index_Rate__c,
                          loan__Margin_Rate__c,
                          loan__Pre_Bill_Days__c,
                          loan__Expected_Repayment_Start_Date__c,
                          loan__Repayment_Procedure__c,
                          loan__Loan_Status__c,
                          loan__Term_Cur__c,
                          loan__Maturity_Date_Current__c,
                          loan__Number_of_Installments__c,
                          loan__Frequency_of_Loan_Payment__c,
                          loan__Principal_Remaining__c,
                          loan__Principal_Adjustment__c,
                          loan__First_Installment_Date__c,
                          loan__Second_Installment_Date__c,
                          loan__Principal_Adjustment_Subtract__c,
                          loan__Interest_Rate__c,
                          loan__Pre_Paid_Interest_Paid_Till_Date__c,
                          loan__Interest_Calculation_Method__c,
                          loan__Interest_estimated__c,
                          loan__Interest_Remaining__c,
                          loan__Interest_Only_Period__c,
                          loan__Balloon_Payment__c,
                          loan__Loan_Amount__c,
                          loan__Number_of_Days_Overdue__c,
                          loan__Metro2_Account_highest_bal_amount__c,
                          loan__Metro2_First_Delinquency_Date__c,
                          loan__Time_Counting_Method__c,
                          loan__Total_Amount_Overdue__c, 
                          loan__Branch__c,
                          loan__Accrual_Stop_Indicator__c,
                          loan__Payment_Amount__c,
                          loan__Pmt_Amt_Cur__c, 
                          loan__Last_Transaction_Timestamp__c,
                          loan__Last_Transaction_Type__c, 
                          loan__Pay_Off_Amount_As_Of_Today__c,
                          loan__Total_Due_Charges__c,
                          loan__Closed_Date__c,
                          loan__Interest_Accrued_Not_Due__c,
                          loan__Fees_Remaining__c,
                          loan__Fee_Accrued__c,
                          loan__Accrual_Start_Days__c,
                          loan__Next_Due_Generation_Date__c , 
                          loan__Write_off_Tolerance_Amount__c,
                          loan__Reserve_Amount_for_Next_Due__c,
                          loan__Delinquency_Grace_Days__c,
                          loan__Delinquent_Amount__c,
                          loan__Oldest_Due_Date__c,
                          loan__Previous_Installment_Date__c,
                          loan__Last_Payment_Date__c,
                          loan__Last_Payment_Amount__c,
                          loan__Rate_Change_Dt_Next__c,
                          loan__Rate_Change_Dt_last__c,
                          loan__Interest_Rate_Last__c,
                          loan__Accrual_Start_Date__c,
                          loan__Repayments_Count__c,
                          loan__Migration_Date__c,
                          loan__Product_Type__c,
                          loan__credit_limit__c,
                          loan__Credit_Limit_Current__c,
                          loan__Minimum_Draw_Amount__c,
                          loan__Maximum_Draw_Amount__c,                               
                          loan__Draw_Term__c,
                          loan__Draw_Term_Payment_Percent__c,
                          loan__Minimum_Due_Amount_On_Billing__c,                                 
                          loan__Repayment_Billing_Method__c,
                          loan__Repayment_Term_Payment_Percent__c,
                          loan__Cleared_Disbursal_Txn_Count__c,
                          loan__Contractual_Interest_Rate__c,
                          loan__Contractual_Due_Day__c,  
                          loan__Pre_Paid_Interest_Amount__c,
                          loan__Loan_Effective_Date__c,
                          loan__Next_Commission_Payment_Date__c,
                          loan__LA_Next_Amortization_date__c,
                          loan__LA_Amortization_Enabled__c,
                          loan__LA_Amortization_Frequency__c,
                          loan__LA_Amortization_Calculation_Method__c,
                          loan__LA_Amortized_Balance_Type__c,
                          loan__Next_Crb_Payment_Profile_Date__c,
                          loan__Metro2_Payment_Rating__c, 
                          loan__Metro2_Account_Status_Code__c,
                          loan__Metro2_Payment_History__c,
                          loan__Metro2_Account_pmt_history_date__c,
                          loan__Repayment_Tied_to_Meeting_Schedule__c,
                          loan__is_Rescheduled__c,
                          //Added following columns for F-i-T feature
                          loan__Funding_in_Tranches__c,
                          loan__Repayment_Start_Basis__c,
                          loan__Draw_Billing_Method__c,   // Also used for LOC
                          loan__Draw_Period_End_Date__c,
                          loan__Disbursal_Amount__c,
                          loan__Disbursed_Amount__c,
                          loan__Disbursal_Status__c,
                          loan__Amortization_Schedule_Generated__c,
                          loan__Last_Disbursal_Date__c,
                          loan__Last_Disbursal_Amount__c,
                          // 
                          loan__Actual_Interest_Only_Payments__c,
                          loan__Suspended__c,
                          loan__Client__c,
                          loan__Group__c,
                          loan__Prin_Int_EMI_generated_on_total__c,
                          loan__Group__r.Name,
                          loan__Branch__r.loan__Branch_s_Bank__c,
                          loan__Loan_Product_Name__c,
                          loan__Loan_Product_Name__r.Name,
                          loan__Loan_Product_Name__r.loan__Fee_Set__c,
                          loan__Loan_Product_Name__r.loan__Loan_Product_Type__c,
                          loan__Loan_Product_Name__r.loan__Interest_Only_Period__c,
                          loan__Loan_Product_Name__r.loan__Accrual_Based_Accounting__c,
                          loan__Loan_Product_Name__r.loan__Holiday_Shift__c,
                          loan__Loan_Product_Name__r.loan__Accrual_Start_Basis__c,
                          
                          //Loan_Product_Name__r.Office__r.Cash_Account__c,
                          loan__Loan_Product_Name__r.loan__Product_Loan_Control_Account__c,
                          loan__Client__r.loan__Group__r.loan__Office__r.loan__Cash_Account__c,
                          loan__Client__r.loan__Center__r.loan__Branch__r.loan__Cash_Account__c,
                          (SELECT Id, Name,
                                  loan__Due_Date__c,
                                  loan__Total_Due_Fees__c,
                                  loan__Due_Interest__c,
                                  loan__Due_Principal__c,
                                  loan__Total_Installment__c,
                                  loan__Barcode_Type__c,
                                  loan__Is_Archived__c,
                                  loan__Balance__c
                                  FROM loan__Repayment_Schedule__r
                                  ORDER BY loan__Due_Date__c ASC),
                          (SELECT Id,Name,
                                  loan__Interest_Rate__c,
                                  loan__Rate_Change_Date_Next__c,
                                  loan__Sequence__c,
                                  loan__Start_Date__c
                             FROM loan__Multi_Step_Loan_Setup__r
                            ORDER BY loan__Sequence__c ASC),                                            
                          
                          (SELECT Id,
                                  loan__Contract__c,
                                  loan__Amortize_Balance__c,
                                  loan__Amount__c,
                                  loan__Fee_Type__c
                             FROM loan__Pre_Paid_Fee__r) ,                                    
                          
                       (Select id, name,loan__RSS_Primary_flag__c from loan__Repayment_Schedule_Summary__r)
                     FROM loan__loan_Account__C
                    WHERE Id = :loanAccId Limit 1];   
                      
        return loanAccountQueried;
    }
    
     
     
    public void generateEMI(ID loanAccId,Date lastAccDate){
            

       loanAccount = getLoanAccountDetails(loanAccId);
       lastAccrualDate = lastAccDate;
      // systemDate = Date.newInstance(2015,2,28);
       List<loan.EMI> emiList = getRepaymentSchedule(loanAccount,lastAccrualDate,True);
       
       
       loan.RepaymentScheduleUtil rsutil = new loan.RepaymentScheduleUtil();
       List<loan__Repayment_Schedule_Summary__c> repaymentScheduleSummary =  rsutil.getRepaymentScheduleSummary(emiList,loanAccount,false);
       List<loan__Repayment_Schedule__c> repaymentScheduleRecords = rsutil.getRepaymentSchedule(emiList,loanAccount);
       
       System.debug('===repaymentScheduleSummary==='+repaymentScheduleSummary);
       System.debug('===repaymentScheduleRecords ==='+repaymentScheduleRecords );
       
       insert repaymentScheduleSummary;
       insert repaymentScheduleRecords ;
       
       Date currentMaturityDate = loanAccount.loan__Next_Installment_Date__c;
       for(loan__Repayment_Schedule__c rSch : repaymentScheduleRecords){
           if (rSch.loan__Due_Date__c > currentMaturityDate){
               currentMaturityDate = rSch.loan__Due_Date__c;
           }
       }
       loanAccount.loan__Maturity_Date_Current__c = currentMaturityDate; 
       update loanAccount;
    }
    public List<loan.EMI> getRepaymentSchedule(loan__Loan_Account__c loanAccount, Date transactionDate,Boolean changeMaturityDate){
        Date firstPaymentDate = loanAccount.loan__Next_Installment_Date__c;
        system.debug(logginglevel.error,'-- firstPaymentDate : ' + firstPaymentDate );
        Date secondPaymentDate = loan.DateUtil.getNextCycleDate(firstPaymentDate
                                                          ,(Integer)firstPaymentDate.day()
                                                          ,loanAccount.loan__Frequency_of_Loan_Payment__c
                                                          ,loanAccount.loan__First_Installment_Date__c
                                                          ,loanAccount.loan__Second_Installment_Date__c
                                                          ,1);
        system.debug(logginglevel.error,'-- secondPaymentDate : ' + secondPaymentDate);

        List<loan__Multi_Step_Loan_Setup__c> rateSchedule = loanAccount.loan__Multi_Step_Loan_Setup__r;
        if (rateSchedule == null){
            rateSchedule =  new List<loan__Multi_Step_Loan_Setup__c>();
        }
        List<loan__Payment_schedule_setup__c> paymentSchList = new List<loan__Payment_schedule_setup__c>();
        Integer remainingTerm = loan.DateUtil.cyclesBetween(loanAccount.loan__Next_Installment_Date__c,loanAccount.loan__Maturity_Date_Current__c,loanAccount.loan__Frequency_of_Loan_Payment__c) + 1;
        
        system.debug(logginglevel.error,'--abhinav changeMaturityDate : ' + changeMaturityDate);

        Boolean flexibleRepaymentFlag = (rateSchedule.size() >0)?true:false;
        List<loan.EMI> emiList;
        loan__FinancialCalculator__c calc = new loan__FinancialCalculator__c();
        calc.loan__Contract_Dt__c = transactionDate;
        calc.loan__Actual_Interest_Only_Payments__c = loanAccount.loan__Actual_Interest_Only_Payments__c;
        calc.loan__First_Payment_Dt__c = firstPaymentDate;
        calc.loan__Loan_Amt__c  = loanAccount.loan__Principal_Remaining__c;
        calc.loan__Original_Loan_Amt__c = calc.loan__Loan_Amt__c;   
        calc.loan__Prepaid_Fees__c = 0.00;
        calc.loan__Financed_Fees__c = 0.00;
        calc.loan__Rate__c = loanAccount.loan__Interest_Rate__c;
        calc.loan__Term__c = (changeMaturityDate)?(Integer)loanAccount.loan__Term_Cur__c:remainingTerm;//Added by Abhinav
        //calc.Term__c = (Integer)loanAccount.Term_Cur__c;//Commented by Abhinav
        calc.loan__Interest_Only_Period__c = loanAccount.loan__Interest_Only_Period__c;
        calc.loan__Balloon_Payment_Amt__c = (loanAccount.loan__Balloon_Payment__c == null)?0:loanAccount.loan__Balloon_Payment__c;
        calc.loan__Balloon_Method_Cd__c  = 'DUMMY';
        calc.loan__Accrual_Base_Method_Cd__c  = (loanAccount.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS)?loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_365_365:loan.LoanConstants.LOAN_ACCRUAL_METHOD_CD_360_360;
        calc.loan__Time_Counting_Method_Cd__c  = (loanAccount.loan__Time_Counting_Method__c == loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS)?loan.LoanConstants.TIME_COUNTING_ACTUAL_DAYS:loan.LoanConstants.TIME_COUNTING_MONTH_AND_DAYS;
        calc.loan__Payment_Frequency_Cd__c  = loanAccount.loan__Frequency_of_Loan_Payment__c;
        calc.loan__Payment_Amt__c = loanAccount.loan__pmt_amt_cur__c;
        calc.loan__Interest_Amt__c = 0;
        calc.loan__Financed_Amt__c = 0;
        calc.loan__Balance_Amt__c = 0;
        calc.loan__First_Period_Calender_Days__c = 0;
        calc.loan__First_Period_Interest__c = 0;
        calc.loan__APR__c = 0;
        calc.loan__Total_Financed_Amt__c = 0;
        calc.loan__Total_Finance_Charge__c = 0;
        calc.loan__Total_Of_Payments__c = 0;
        calc.loan__Amortization_Calculation_Method_Cd__c  = 'NONE';
        calc.loan__Additional_Interest_Amt__c = loanAccount.loan__Interest_Remaining__c;
        calc.loan__Final_Payment_Amt__c  = 0;
        calc.loan__Installment_Method_Cd__c  = 'UNDEFINED';
        calc.loan__Flexible_Repayment_Flag__c  = flexibleRepaymentFlag;
        calc.loan__Repayment_Type_Cd__c  = 'UNDEFINED';
        calc.loan__Billing_Method_Cd__c  = loanAccount.loan__Interest_Calculation_Method__c;
        calc.loan__Principal_Payment_Amt__c  = 0;         
        calc.loan__Payment_Amt_2_Start_dt__c = firstPaymentDate;
        calc.loan__First_Payday_Date__c = firstPaymentDate;
        calc.loan__Second_Payday_Date__c= secondPaymentDate;     
        //calc.loan__Action__c = 'CALCULATE_TERM';
        calc.loan__Action__c  = 'CALCULATE_ALL';
        calc.loan__Repayment_Procedure__c = 'Equated Principal';
        calc.loan__Due_Day__c = firstPaymentDate.day();        

        // Generate EMIs
        //emiList = loan.FinancialCalc2.calculateEMI(calc,rateschedule);
        emiList = loan.FinancialCalc3.calculateEMI(calc,rateschedule,paymentschList);
        system.debug(logginglevel.error,'-- EMI List: ' + emiList);

        // Update details on loan a    ccount
        calc.loan__Payment_Amt__c = loan.ValueUtil.round(calc.loan__Payment_Amt__c);
        calc.loan__Interest_Amt__c = loan.ValueUtil.round(calc.loan__Interest_Amt__c);
        system.debug(logginglevel.error,'-- calc.Payment_Amt__c: ' + calc.loan__Payment_Amt__c);
        system.debug(logginglevel.error,'-- calc.Interest_Amt__c: ' + calc.loan__Interest_Amt__c);
        
        loanAccount.loan__Next_Installment_Date__c = calc.loan__First_Payment_Dt__c;
        loanAccount.loan__Next_Due_Generation_Date__c = loanAccount.loan__Next_Installment_Date__c.addDays((Integer)(-1*loanAccount.loan__Pre_Bill_Days__c));
        loanAccount.loan__Contractual_Due_Day__c = loanAccount.loan__Next_Installment_Date__c.day();
        loanAccount.loan__Due_Day__c = loanAccount.loan__Contractual_Due_Day__c;
        loanAccount.loan__Pmt_Amt_Cur__c = calc.loan__Payment_Amt__c;
        //loanAccount.loan__Payment_Amount__c = loanAccount.loan__Pmt_Amt_Cur__c;
        loanAccount.loan__APR__c = calc.loan__APR__c;

        return emiList;
    }
}