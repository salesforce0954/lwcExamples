public class dynamicCalculator{
   public integer x {get;set;}
   public integer y {get;set;}
   public integer z {get;set;}
   public integer resultAdd {get;set;}
  public dynamicCalculator(){
  
  }
  public static integer add(integer x,integer y,integer z){
    z = x + y;
    system.debug('Result of add' + z);
    return z;
  }
  public static integer sub(integer x,integer y,integer z){
    z = x - y;
   return z;
  }
  public static integer mul(integer x,integer y,integer z){
    z = x * y;
   return z;
  }
  
  public pageReference addResult(){
  resultAdd = add(x,y,z);
  return null;
  }
  public pageReference subResult(){
  resultAdd = sub(x,y,z);
  return null;
  }
  public pageReference mulResult(){
  resultAdd = mul(x,y,z);
  return null;
  }
  
}