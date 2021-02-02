require 'rake'

desc "install the dot files into user's home directory"
task :install do
  $replace_all = false
  files = Rake::FileList.new("*")

  files.each do |file|
    next if %w[Rakefile README.md Session.vim LICENSE].include? file
    next if Dir.exist? File.join(ENV['HOME'], ".#{file}")
    replace_confirm(file)
  end
end

def replace_confirm(file)
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if $replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          $replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -nsf "$PWD/#{file}" "$HOME/.#{file}"}
end
