Public with sharing class Example2Ctrl{

    Public String SelectedCity{get;set;}
    Public String SelectedMonth{get;set;}
    Public String SelectedDay{get;set;}
    Public String SelectedYear{get;set;}
    public date DateToday{get;set;}
    public String DateTodayString{get;set;}
    Public String birthdate{get;set;}
    Public Date   birthdateDateFormat{get;set;}

    Id runningUserId = UserInfo.getUserId();

    public Example2Ctrl() {
        birthdate=SelectedMonth+'/'+SelectedDay+'/'+SelectedYear;
        system.debug('Birthdate$$$$$$$$$'+birthdate);

    }

    public List<SelectOption> getMonth() {

        List<SelectOption> MonthOptions = new List<SelectOption>();
        MonthOptions.add(new SelectOption('--None--','Month'));
        for(Integer i=01;i<13;i++){
            MonthOptions.add(new SelectOption(String.valueOf(i),String.valueOf(i)));        
        }
        return MonthOptions;
    }  

    public List<SelectOption> getDay() {

        List<SelectOption> DayOptions = new List<SelectOption>();
        DayOptions.add(new SelectOption('--None--','Day'));
        for(Integer i=01;i<32;i++){
            DayOptions.add(new SelectOption(String.valueOf(i),String.valueOf(i)));        
        }
        return DayOptions;
    }

    public List<SelectOption> getYear() {

        List<SelectOption> YearOptions= new List<SelectOption>();
        YearOptions.add(new SelectOption('--None--','Year'));
        DateToday=system.today();
        system.debug('DateToday@@@@'+DateToday);
        Integer DateTodayInteger= DateToday.year();

        for(Integer i=1920;i<=DateTodayInteger;i++){
            YearOptions.add(new SelectOption(String.valueOf(i),String.valueOf(i)));        
        }
        return YearOptions;
    }

   
}