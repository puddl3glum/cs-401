#!/usr/bin/ruby -w

require_relative 'Parser.rb'

class Lexer
    # lexer class

    # attr_accessor :count
    attr_accessor :prog_text
    attr_accessor :queue

    def initialize(program_file_name)
        #instance variables
        @prog_text = ''
        
        open(program_file_name) {|f|
          data = f.read
          @prog_text += data
        }
        
        @queue = Array.new #calls the Queueclass
        
    end
    
    def identifier?
        if(((/[[a-z]|[A-Z]][\w]*/ =~ @prog_text[0..-1]) == 0) && !((/if|while|not|end|do|true|   false|and/ =~ @prog_text[0..-1]) == 0))
            identifier = /[[a-z]|[A-Z]][\w]*/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(identifier, "")
            #push the identifier to the queue
            @queue.push [identifier,"identifier"]
            return TRUE
        else
            return FALSE
        end
    end
 
 
    def keyword?
        if((/if|while|not|end|do|and/ =~ @prog_text[0..-1]) == 0)
            keyword = /if|while|not|end|do|and/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(keyword, "")
            #push the keyword to the queue
            @queue.push [keyword,"keyword"]
            return TRUE
        else
            return FALSE
        end
    end


    def integer?
        if((/[0-9]+/ =~ @prog_text[0..-1]) == 0)
            intg = /[0-9]+/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(intg, "")
            #push the integer to the queue
            @queue.push [intg,"integer"]
            return TRUE
        else
            return FALSE
        end
    end
 
    def boolean?
        if((/true|false/ =~ @prog_text[0..-1]) == 0)
            bool = /true|false/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(bool, "")
            #push the boolean to the queue
            @queue.push [bool,"boolean"]
            return TRUE
        else
            return FALSE
        end
    end
 
 
    def operator?
        if((/\+|-|\*|\/|:=|<=|>=|>|</ =~ @prog_text[0..-1]) == 0)
            operator = /\+|-|\*|\/|:=|<=|>=|>|</.match(@prog_text[0..-1])[0]
            @prog_text.sub!(operator, "")
            #push the operator to the queue
            @queue.push [operator,"operator"]
            return TRUE
        else
            return FALSE
        end
    end
 
    def comment?
        if((/\/\/.*/ =~ @prog_text[0..-1]) == 0)
            comment = /\/\/.*/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(comment, "")
            return TRUE
        else
            return FALSE
        end
    end


    def seperator?
        if((/\(|\)|;/ =~ @prog_text[0..-1]) == 0)
            seperator = /\(|\)|;/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(seperator, "")
            #push the operator to the queue
            @queue.push [seperator,"seperator"]
            return TRUE
        else
            return FALSE
        end
    end


    def space?
        if((/\s/ =~ @prog_text[0..-1]) == 0)
            spaces = /\s/.match(@prog_text[0..-1])[0]
            @prog_text.sub!(spaces, "")
            return TRUE
        else
            return FALSE
        end
    end
 
    def run
        while @prog_text
            if self.identifier? | self.keyword? | self.integer? | self.boolean? | self.comment? | self.operator? | self.seperator? | self.space?
                #puts @queue[-1][0]
            else
                #puts "error at: "
                puts @prog_text[0..-1]
                break
            end
        end
        @queue.push ["EOF","EOF"]
        #puts @queue
    end

end

# main program
program_name = ARGV[0]
if program_name.nil?
    puts "Missing program name!"
    exit!
end
lexer = Lexer.new(program_name)
# a = Lexer.new('prog.txt')
lexer.run

parser = Parser.new(lexer.queue)
puts parser.program?
