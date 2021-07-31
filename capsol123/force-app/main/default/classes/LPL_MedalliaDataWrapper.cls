public class LPL_MedalliaDataWrapper {
    
	public Query query;
    
	public class Query {
		public Integer resultCode;
		public List<String> columns;
		public List<List<String>> table;
	}
	  
	public static LPL_MedalliaDataWrapper parse(String json) {
		return (LPL_MedalliaDataWrapper) System.JSON.deserialize(json, LPL_MedalliaDataWrapper.class);
	}
}