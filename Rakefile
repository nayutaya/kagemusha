
require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = Dir.glob("test/test_*.rb")
  test.verbose    =  true
end

desc "Generate gemspec file from template"
task :gemspec do
  require "erb"
  require "lib/kagemusha"

  src = File.open("kagemusha.gemspec.erb", "rb") { |file| file.read }
  erb = ERB.new(src, nil, "-")

  version = Kagemusha::VERSION
  date    = Time.now.strftime("%Y-%m-%d")

  files      = Dir.glob("**/*").select { |s| File.file?(s) }
  test_files = Dir.glob("test/**").select { |s| File.file?(s) }

  File.open("kagemusha.gemspec", "wb") { |file|
    file.write(erb.result(binding))
  }
end
