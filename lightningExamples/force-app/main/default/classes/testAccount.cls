public class testAccount{
Account acc {get;set;}
List<Account> lstAcc {get;set;}

public testAccount(){
acc = new Account(Name='Naveeeen');
lstAcc = new List<Account>();
lstAcc.add(acc);
}
public void result(){
insert lstAcc;
}
}