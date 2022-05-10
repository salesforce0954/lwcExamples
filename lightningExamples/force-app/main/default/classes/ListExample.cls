public class ListExample{

    public String getSave() {
        stud = new List<Student__c>();
        Student__c res = new Student__c(Name = 'Suneel',Age__c = 31);
        stud.add(res);
        insert stud;
        return null;
    }


public List<Student__c> stud {get;set;}

public ListExample(){

System.debug('Student Results' +stud);
}


}