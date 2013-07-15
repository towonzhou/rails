class Rmdir
    attr_accessor :filename
    def initialize filename
        raise ArgumentError, "filename can not be nil" unless File.exist?(filename)
        @filename = filename 
    end

    def rmdir 
        file_type self.filename
    end

    def file_type filename
        if File.directory?filename
            #is a dir
            is_dir filename
        else #is a file
            is_file filename
        end
    end

    def is_file filename
        File.delete(filename)
    end

    def is_dir dir_name
        if Dir.entries(dir_name).length == 2
            Dir.delete(dir_name)
        else
            path = File.expand_path(dir_name)
            p Dir.entries(path)
            Dir.foreach(dir_name) do |d|
                unless d.match(/^\.\.?$/)
                    _file = File.join(path, d)
                    r = Rmdir.new(_file) 
                    r.rmdir
                end
            end
            Rmdir.new(@filename).rmdir
        end
    end
end

r = Rmdir.new('a')
r.rmdir
#Dir.foreach('a') do |d|
#    p d
#end
#p File.directory?('hello')
p File.expand_path('a')
