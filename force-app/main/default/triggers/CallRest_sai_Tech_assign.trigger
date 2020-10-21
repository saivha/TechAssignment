trigger CallRest_sai_Tech_assign on TransactionItem__c (after insert, after update , after delete) {
    
    set <Id> TransactionIds = new set <Id> ();
    if(trigger.isInsert || trigger.isUpdate)
    {
     for(TransactionItem__c item: Trigger.New)
      TransactionIds.add(item.Transaction__c) ;    // Here Field Transaction__c is Foreign key
          
    }
 if (trigger.isDelete) 
 { 
  for(TransactionItem__c item: Trigger.old)
       TransactionIds.add(item.Transaction__c) ;    // Here Field Transaction__c is Foreign key
    
 }

    if (TransactionIds.size() > 0)
         FutureCallTransRestApi.getStockQuotes(TransactionIds);
}