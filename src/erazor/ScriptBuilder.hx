package erazor;

class ScriptBuilder
{
	private var context : String;

	public function new(context : String)
	{
		this.context = context;
	}
	
	public function build(blocks : Array<TBlock>, interceptors: Array<String->TBlock->String> = null) : String
	{
		var buffer = new StringBuf();
		
		for(block in blocks)
		{
			buffer.add(blockToString(block, interceptors));
		}
		return buffer.toString();
	}
	
	public function blockToString(block: TBlock, interceptors: Array<String->TBlock->String> = null) : String
	{
	  if(interceptors == null)
	  {
	    interceptors = [];
	  }
	  interceptors.unshift(this.defaultInterceptor);
	  
		switch(block)
		{
			case literal(s):
				return context + ".add('" + StringTools.replace(s, "'", "\\'") + "');\n";
			
			case codeBlock(s):
				return s + "\n";
			
			case printBlock(code, source):
				return context + ".unsafeAdd(" + processWith(block, interceptors) + ");\n";
			
			case keepCodeBlock(code, source):
				return code + "\n" + context + ".add('@keep" + StringTools.replace(source, "'", "\\'") + "');\n";
		}
	}
	
	public function processWith(block: TBlock, interceptors: Array<String->TBlock->String>) : String
	{
		var output = "";
		for(interceptor in interceptors)
		{
			output = interceptor(output, block);
		}
		return output;
	}
	
	public function defaultInterceptor(output: String, block: TBlock): String
	{
		switch(block)
		{
			case printBlock(code, _):
				return code;
			case _:
		}
		return output;
	}
}