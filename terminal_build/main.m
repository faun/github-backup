#import <MacRuby/MacRuby.h>

//Entry point for the terminal version of your application
int main(int argc, char *argv[])
{
	return macruby_main("lib/terminal_main.rb", argc, argv); 
}