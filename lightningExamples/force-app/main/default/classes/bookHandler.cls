public class bookHandler{

   public static void discountPrice(List<Book__c> bookList){
       
       for(Book__c b:bookList){
       
           b.price__c = b.price__c - b.price__c * 10/100;
       
       }
   }
}