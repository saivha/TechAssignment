global class FutureCallTransRestApi {@future(callout = true)
  public static void getStockQuotes(Set < Id > TransIds) {
    for (Id id: TransIds) {
      // Following list contains , Trasaction item Json payload and Transaction Payload

      system.debug('calling getJsonstring method for Transaction Id:' + id);
      map < String,
      String > msresult = FutureCallTransRestApi.getJsonString(id);
      system.debug('calling makeRestcall method to send Transaction details of :' + id);
      Integer status = makeRestcall(msresult.get('TransactioItem Payload'), 'Transaction Item', 'Post');

      system.debug('Response received from makeRestCall Method for Id:' + id);
      if (status == 0) {
        system.debug('Sucess Response received from makeRestCall Method for Id:' + id + ': so sending Transaction details');
        status = makeRestcall(msresult.get('Transaction Payload'), 'Transaction', 'Post');
      }

      else system.debug('Failed Response received from makeRestCall Method for Id:' + id + ': so  not sent Transaction details');

    }

  }
  public static map < string,
  String > getJsonString(Id id) {
    system.debug('inside getJsonstring method and processing  Transaction Id:' + id);
    map < String,
    String > lsRetun = new map < String,
    String > ();
    List < TransItems2JSON > lTransitems = new List < TransItems2JSON > ();
    Transaction2Json oTrans;
    Integer i = 1;
    system.debug('bringing Transaction and Item detais for :' + id);
    List < Transaction__c > ls = [select Id, Total_Cost__c, Total_Discount__c, Transaction_Count__c, (select Id, Name, Item_Cost__c from TransactionItem__r) from Transaction__c where Id = :id];
    for (Transaction__c t: ls) {
      // there will be only Transaction so prepare object only ones
      if (i == 1) oTrans = new Transaction2Json(t);
      i++;

      for (TransactionItem__c ti: t.TransactionItem__r) {
        TransItems2JSON oItems = new TransItems2JSON(ti.Id, ti.Name, ti.Item_Cost__c);
        lTransitems.add(oItems);
      } // end for inner loop

    } // end for main loop

    // Serialize the list of  objects.
    String JSONStringTransItems = JSON.serialize(lTransitems);
    String JSONStringTrans = JSON.serialize(oTrans);
    System.debug('Serialized list of Transactions items into JSON format: ' + JSONStringTransItems);
    System.debug('Serialized list of Transactions into JSON format: ' + JSONStringTrans);
    lsRetun.put('TransactioItem Payload', JSONStringTransItems);
    lsRetun.put('Transaction Payload', JSONStringTrans);
    system.debug('Completed getJsonString Method for Transaction Id : ' + id);
    return lsRetun;
  } // end for getJsonString

  public static integer makeRestcall(String payload, String Type, String Method) {

    system.debug('inside the  makeRestcall Method and processing the type : ' + Type);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://th-apex-http-callout.herokuapp.com/test');
    request.setMethod(Method);
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Set the body as a JSON object
    request.setBody(payload);
    system.debug('sending json payload for  the type : ' + Type);
    try {
      HttpResponse response = http.send(request);

      // Parse the JSON response
      if (response.getStatusCode() != 201) {
        System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus() + ' for Type :' + Type);
        return 1;
      } else {
        System.debug('***** Response Received for the Type' + Type + '*****' +response.getBody());
        return 0;
      }
    } // end for try
    catch(Exception e) {
      System.debug('An exception occurred: ' + e.getMessage());
      return 1;
    } // end for catch
    finally {}
  } // end for makeRestcall
}