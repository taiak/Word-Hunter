# if no file name exist with otomat name. name new 
way = File.dirname(__FILE__)

Dir.chdir( way )
Dir.mkdir('./marshalled_files') unless Dir.exist?('marshalled_files')
system 'ruby ./automat_maker.rb'
system 'ruby ./archive_maker.rb'