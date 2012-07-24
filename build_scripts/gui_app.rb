GUI_ARCH 		    = '-arch x86_64'
GUI_FRAMEWORKS 	= '-framework MacRuby -framework Foundation -framework Cocoa'
GUI_GCFLAGS     = '-fobjc-gc-only' 
GUI_COMPILER    = 'clang' 

GUI_CONTENTS_DIR 	= "#{GUI_NAME}.app/Contents"
GUI_MAIN           ="gui_build/main.m"
GUI_RESOURCE_DIR 	= File.join(GUI_CONTENTS_DIR, 'Resources')
GUI_MACOS_DIR 		  = File.join(GUI_CONTENTS_DIR, 'MacOS')
GUI_FRAMEWORKS_DIR	= File.join(GUI_CONTENTS_DIR, 'Frameworks')

COPY_GUI_FILES = FileList["lib/*.rb", 
  "resources/images/*.tiff", 
  "resources/images/*.icns", 
  "resources/*.strings",
	"English.lproj/*.strings"]
	
COPY_GUI_FRAMEWORKS = FileList["#{GUI_FRAMEWORK_NAME}.bundle"]	

transform_task(:copy_gui_files, COPY_GUI_FILES, GUI_RESOURCE_DIR) {|target, src| cp_r(src, target)}
transform_task(:copy_gui_frameworks, COPY_GUI_FRAMEWORKS, GUI_FRAMEWORKS_DIR) {|target, src| cp_r(src, target)}

task :info_plist do 
  plist = File.open(File.join(".","gui_build/Info.plist")).  
    read.    
    sub('${EXECUTABLE_NAME}',"#{GUI_NAME}").
    sub('${BUNDLE_IDENTIFIER}',"#{GUI_IDENTIFIER}").
    sub('${RELEASE_VERSION_NUMBER}',"#{GUI_APP_VERSION}").
    sub('${BUILD_VERSION_NUMBER}',"#{GUI_BUILD_VERSION}")
  
  File.open(File.join(GUI_CONTENTS_DIR,'Info.plist'),'w').  
    write(plist)
end

# Create the Application Bundle and compile the main.m file
file File.join(GUI_MACOS_DIR, GUI_NAME) => [:copy_gui_files, :copy_gui_frameworks,:info_plist] do |t|
	mkdir_p("#{GUI_MACOS_DIR}", :verbose => false)	
	sh "#{GUI_COMPILER} #{GUI_MAIN} -L#{GUI_FRAMEWORKS_DIR} -o #{t.name} #{GUI_ARCH} #{GUI_FRAMEWORKS} #{GUI_GCFLAGS}"
end

desc "Creates a terminal application with an application bundle."
task :create_gui_app => [:create_gui_framework,
    File.join(GUI_MACOS_DIR, GUI_NAME)]

desc "Run the terminal application that is locally built"
task :run_gui_app do
  sh "#{GUI_NAME}.app/Contents/MacOS/#{GUI_NAME}"
end