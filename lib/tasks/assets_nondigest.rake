require 'fileutils'

desc "Create nondigest versions of all digest assets"
task "assets:precompile" do
  fingerprint = /\-[0-9a-f]{64}\./
  for file in Dir["public/assets/**/*"]
    next unless file =~ fingerprint
    nondigest = file.sub fingerprint, '.'
    FileUtils.cp file, nondigest, verbose: true
  end
end
