public class DupTracker{
public list<account> acclst = new list<account>();
public set<account> orglist = new set<account>();
public set<string> strlst = new set<string>();
public list<account> duplist = new list<account>();

public void checkDup(){
acclst =  [select id, name from account];
system.debug('my list..................' + acclst);

for(account acc: acclst){
if(strlst.contains(acc.name)){
duplist.add(acc);
system.debug('duplcates................' + duplist);
}

else{
orglist.add(acc);
strlst.add(acc.name);
}

}

delete duplist;

}

}