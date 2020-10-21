public class Transaction2Json {

	public Keys keys;
	public Values values;

	public class Keys {
		public String TransactionID;
         public Keys(Transaction__c oT)
          {
          this.TransactionID=oT.Id;
        } 
	}

	public class Values {
		public Decimal  TotalCost;
		public Decimal TotalDiscount;
		public String TransactionDate;
		public Decimal TotalCount;
   public Values(Transaction__c oT)
     {
      this.TotalCost=oT.Total_Cost__c;
      this.TotalDiscount= oT.Total_Discount__c;
      this.TotalCount= oT.Transaction_Count__c;
      this.TransactionDate = Datetime.now().format('yyyy-MM-dd');
     }
	}
  public Transaction2Json(Transaction__c oT)
  {
      this.Keys = new Keys(oT);
      this.values = new values(oT);
  }
	
	public static Transaction2Json parse(String json) {
		return (Transaction2Json) System.JSON.deserialize(json, Transaction2Json.class);
	}
}