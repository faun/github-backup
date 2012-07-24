#load bundles
puts "Load shared frameworks"
frameworks_path = NSBundle.mainBundle.privateFrameworksPath.fileSystemRepresentation 
puts "Found shared frameworks: #{frameworks_path}"
Dir.glob(File.join(frameworks_path, '*.bundle')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  puts "Attempting to load shared framework #{File.join(frameworks_path,path)}"
  require(File.join(frameworks_path,path))
end

# Loading all the Ruby project files.
puts "Load all ruby files"
main = File.basename(__FILE__, File.extname(__FILE__))
resources_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
puts "Found resource path: #{resources_path}"
Dir.glob(File.join(resources_path,'lib','*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main && path != 'gui_main'
   puts "Attempting to load ruby file #{resources_path}/lib/#{path}"
   require(File.join(resources_path,'lib',path))
  end
end

puts "Hello world"
