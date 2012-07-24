# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'
framework 'AppKit'

#load bundles
puts "Load shared frameworks"
frameworks_path = NSBundle.mainBundle.privateFrameworksPath.fileSystemRepresentation 
puts "Found shared frameworks: #{frameworks_path}"
Dir.glob(File.join(frameworks_path, '*.bundle')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  puts "Attempting to load shared framework #{File.join(frameworks_path,path)}"
  require(File.join(frameworks_path,path))
end

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main && path != 'terminal_main'
   require(path)
  end
end

# If you had a main Nib defined in the Info.plist you could jump int the main loop by doing this:
# NSApplicationMain(0, nil) 

#However, since I prefer to do as much as possible in ruby I do this:
class AppDelegate
  def applicationDidFinishLaunching(notification)    
  end

  def windowWillClose(notification)    
    exit
  end
end

app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

screen_frame = NSScreen.mainScreen.frame
screen_size = screen_frame.size
width = screen_size.width
height = screen_size.height
window_size = [(width/2 - 200),height/2, 420, 30]

window = NSWindow.alloc.initWithContentRect(window_size,
    styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask,
    backing:NSBackingStoreBuffered,
    defer:false)
window.title      = 'My Polygolt Application'
window.level      = NSModalPanelWindowLevel
window.delegate   = app.delegate

textfield = NSTextField.alloc.initWithFrame([5,5,400,20])

#prove that we're able to load from the bundle
textfield.setStringValue("Hello World!")

window.contentView.addSubview(textfield)

window.display
window.orderFrontRegardless
app.run
