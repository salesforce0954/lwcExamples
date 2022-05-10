public class calloutExcep{
   @future(callout=true)
   public static void getRestWC(){
     Http h = new Http();
     HttpRequest hreq = new HttpRequest();
     hreq.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals');
     hreq.setMethod('GET');
     hreq.setHeader('Content-Type', 'application/json;charset=UTF-8');
     hreq.setBody('{"name":"mighty eeee"}');
     HttpResponse hres = h.send(hreq);
     system.debug(hres.getBody());
   }
}