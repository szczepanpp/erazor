package erazor;

enum TBlock
{
	// Pure text
	literal(s : String);
	
	// Code
	codeBlock(s : String);

	// Code that should be kept after execution
	keepCodeBlock(code : String, source: String);
	
	// Code that should be printed immediately
	printBlock(code : String, source: String);
}