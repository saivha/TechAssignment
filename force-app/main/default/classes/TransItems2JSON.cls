/* Sai Vamaraju created on 21/10/2020 for Tech assignment.
 * this is the Stub for json obect for represeting Transaction items
 */
public class TransItems2JSON {

	public Keys keys;
	public Values values;

	public class Keys {
		public String TransactionItemID;
         public Keys(String TransactionItemID )
        {
         this.TransactionItemID = TransactionItemID;
        }
	}

	public class Values {
		public decimal ItemCost;
		public String ItemName;
          public Values(String ItemName, decimal ItemCost)
          {
            this.ItemCost = ItemCost;
            this.ItemName = ItemName;
           }
	}

	public TransItems2JSON(String TransactionItemID,String ItemName, Decimal ItemCost )
         {
          this.keys = new keys(TransactionItemID);
          this.values = new Values(ItemName,ItemCost);
           }
	public static List<TransItems2JSON > parse(String json) {
		return (List<TransItems2JSON >) System.JSON.deserialize(json, List<TransItems2JSON >.class);
	}
}