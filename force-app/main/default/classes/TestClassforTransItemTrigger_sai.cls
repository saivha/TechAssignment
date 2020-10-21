/* Sai Vamaraju : created : 21/10/2020 for Tech assignment 
 * this is simple test calss to test the Trigger on Transaction item object.
 * this code creates transaction and transaction item and establish parent child relationship and test check the relationship
 */
 
@istest
public class TestClassforTransItemTrigger_sai{

    static testMethod void  updateMethodTest(){
        //creating Transaction
        Transaction__c oT= new Transaction__c ();
        oT.Total_Cost__c=11.34;
        oT.Total_Discount__c=6.6;
         oT.Transaction_Count__c=4;
        insert oT;

    TransactionItem__c Testitem = new TransactionItem__c();
    Testitem.Name = 'Test Account';
    Testitem.Item_Cost__c =12.3;
    Testitem.Transaction__c = oT.Id;
    insert Testitem;
    Test.startTest();
    List<TransactionItem__c> itemList = new List<TransactionItem__c>([SELECT Transaction__c FROM TransactionItem__c]);
    Set<Id> idsSet = new Set<Id>();
    for(TransactionItem__c itm : itemList)
       system.assertEquals(itm.Transaction__c, oT.Id);
     Test.stopTest();
}
}