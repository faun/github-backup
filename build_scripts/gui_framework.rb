#Compile everything in ext as a framework to be used by the terminal application. This will be called by the Rakefile.

#this must match the main method in ext/bundle.m or you'll get a missing symbol error at runtime.
GUI_FRAMEWORK_NAME = 'gui_dependencies_bundle' 

GUI_FRAMEWORK_SRC = FileList['ext/*.mm','ext/*.m','gui_build/bundle.m']
GUI_FRAMEWORK_TARGET = GUI_FRAMEWORK_SRC.ext('o')
GUI_FRAMEWORK_COMPILER = 'clang'
GUI_FRAMEWORKS_DEPENDENCIES = "-framework Foundation -framework Macruby" 
GUI_MACRUBY = "/Library/Frameworks/MacRuby.framework/Versions/0.10/usr/include/ruby-1.9.2"
GUI_STATIC_INCLUDES = '/Users/sholloway/Dropbox/Jitterbug/ext/vendor/glm-0.9.2.3'
GUI_INCLUDES = %{-Iext -I#{GUI_MACRUBY} -I#{GUI_STATIC_INCLUDES} }

GUI_COMPILE_LANG_OPTS = "-ObjC++ -fobjc-gc"
GUI_LINK_LANG_OPTS = "-ObjC++ -fobjc-gc -flat_namespace"
GUI_DEBUG_OPTS = "-undefined suppress"
GUI_ARCH_OPTS = "-arch x86_64"
GUI_LIBS = "-L. -L/Library/Frameworks/MacRuby.framework/Versions/0.10/usr/lib -lmacruby"
GUI_RUBY_BUNDLE = "-I#{GUI_MACRUBY}/ruby.h -I#{GUI_MACRUBY}/ruby/defines.h -I#{GUI_MACRUBY}/ruby/config.h"

rule '.o' => '.mm' do |t|  
  puts "compiling #{t.name}"
  sh %{#{GUI_FRAMEWORK_COMPILER} #{GUI_ARCH_OPTS} #{GUI_COMPILE_LANG_OPTS} #{GUI_FRAMEWORKS_DEPENDENCIES} #{GUI_INCLUDES} -d -g -c -pipe -o #{t.name} #{t.source}}
end

rule '.o' => '.m' do |t|  
  puts "compiling #{t.name}"
  sh %{#{GUI_FRAMEWORK_COMPILER} #{GUI_ARCH_OPTS} -ObjC -fobjc-gc #{GUI_FRAMEWORKS_DEPENDENCIES} #{GUI_INCLUDES} -d -g -c -pipe -o #{t.name} #{t.source}}
end

#create the Framework
file "#{GUI_FRAMEWORK_NAME}.bundle" => GUI_FRAMEWORK_TARGET do  
  puts "compiling #{GUI_FRAMEWORK_NAME}.bundle"
  sh %{#{GUI_FRAMEWORK_COMPILER} #{GUI_ARCH_OPTS} #{GUI_LINK_LANG_OPTS} #{GUI_FRAMEWORKS_DEPENDENCIES} #{GUI_LIBS} -pipe -v -bundle -o #{GUI_FRAMEWORK_NAME}.bundle #{GUI_FRAMEWORK_TARGET}}
end

task :create_gui_framework => ["#{GUI_FRAMEWORK_NAME}.bundle"] do
  puts "should be done creating the gui framework"
end