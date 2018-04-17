#!/usr/bin/ruby -w

class Parser

    def initialize(token_queue)
        @tok_queue = token_queue.reverse
        @temp_stack = Array.new
        @err_queue = Array.new
    end


    def getTokenKind
        # if the token queue is not empty, 
        if ! @tok_queue.empty?
            return @tok_queue[-1][1]
        else
            return "empty"
        end
    end


    def clear_err_queue
        @err_queue.clear
    end


    def update_err_queue
        puts @err_queue[0]
        @err_queue.insert(0,@tok_queue[-1])
    end


    def getTokenText
        if ! @tok_queue.empty?
            return @tok_queue[-1][0]
        else
            return "empty"
        end
    end


    def nextToken
        if ! @tok_queue.empty?
            @temp_stack.push(@tok_queue.pop)
        else
            puts "empty"
        end
    end


    def backtrack(top)
        while (@tok_queue[-1] != top) && (not @tok_queue.empty?) do
            @tok_queue.push(@temp_stack.pop)
        end
    end


    def program?
        #puts @tok_queue
        #puts " "
        if self.stmts?
            #puts @tok_queue
            puts " "
            if self.getTokenText == 'EOF'
                self.nextToken
                puts "No errors"
                return TRUE
            else
                puts "Syntax error"
                self.update_err_queue
                puts @err_queue[0]
                return FALSE
            end
        else
            puts "Syntax error"
            self.update_err_queue
            puts @err_queue[0]
            return FALSE
        end
    end


    def stmts?
        top = @tok_queue[-1]
        if self.stmt?
            #puts "statment"
            if self.getTokenText == ';'
                self.nextToken
                while self.stmt?
                    #puts @tok_queue
                    if self.getTokenText == ';'
                        self.nextToken
                    else
                        break
                    end
                end
                
                self.clear_err_queue
                return TRUE
            else
                self.update_err_queue
                self.backtrack(top)
                return FALSE
            end
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end


    def stmt?
        top = @tok_queue[-1]
        if self.getTokenKind == "identifier"
            self.nextToken
            if self.getTokenText == ":="
                self.nextToken
                if self.addop?
                    self.clear_err_queue
                    return TRUE
                else
                    self.update_err_queue
                    #backtrack
                    self.backtrack(top)
                    return FALSE
                end
            else  
                self.update_err_queue
                self.backtrack(top)
                return FALSE
            end
                
        elsif self.getTokenText == "if"
            self.nextToken
            if self.lexpr?
                if self.getTokenText == "then"
                    self.nextToken
                    if self.stmts?
                        if self.getTokenText == "else"
                            self.nextToken
                            if self.stmts?
                                if self.getTokenText == "end"
                                    self.nextToken
                                    self.clear_err_queue
                                    return TRUE
                                else
                                    self.update_err_queue
                                    self.backtrack(top)
                                    return FALSE
                                end
                            else
                                self.update_err_queue
                                self.backtrack(top)
                                return FALSE
                            end
                        else
                            self.update_err_queue
                            self.backtrack(top)
                            return FALSE
                        end
                    else
                        self.update_err_queue
                        self.backtrack(top)
                        return FALSE
                    end
                else
                    self.update_err_queue
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.update_err_queue
                self.backtrack(top)
                return FALSE
            end

        elsif self.getTokenText == "while"
            self.nextToken
            if self.lexpr?
                if self.getTokenText == "do"
                    self.nextToken
                    if self.stmts?
                        if self.getTokenText == "end"
                            self.nextToken
                            self.clear_err_queue
                            return TRUE
                        else
                            self.update_err_queue
                            self.backtrack(top)
                            return FALSE
                        end
                    else
                        self.update_err_queue
                        self.backtrack(top)
                        return FALSE
                    end
                else
                    self.update_err_queue
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.update_err_queue
                self.backtrack(top)
                return FALSE
            end
                
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end


    def addop?
        top = @tok_queue[-1]
        if self.mulop?
            if (self.getTokenText == "+") | (self.getTokenText == "-")
                self.nextToken
                if self.addop?
                    self.clear_err_queue
                    return TRUE
                else
                    self.update_err_queue
                    #backtrack
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.clear_err_queue
                return TRUE
            end
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end


    def mulop?
        top = @tok_queue[-1]
        if self.factor?
            if (self.getTokenText == "/") | (self.getTokenText == "*")
                self.nextToken
                if self.mulop?
                    self.clear_err_queue
                    return TRUE
                else
                    #backtrack
                    self.update_err_queue
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.clear_err_queue
                return TRUE
            end
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end

    
    def factor?
        top = @tok_queue[-1]
        if self.getTokenKind == "integer"
            self.nextToken
            self.clear_err_queue
            return TRUE
            
        elsif self.getTokenKind == "identifier"
            self.nextToken
            self.clear_err_queue
            return TRUE
        #tests for ( <addop> )
        elsif self.getTokenText == '('
            self.nextToken
            if self.addop?
                if self.getTokenText == ')'
                    self.nextToken
                    self.clear_err_queue
                    return TRUE
                else
                    self.update_err_queue
                    #backtrack
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.update_err_queue
                self.backtrack(top)
                return FALSE
            end
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end


    def lexpr?
        top = @tok_queue[-1]
        if lterm?
            if self.getTokenText == 'and'
                self.nextToken
                if self.lexpr?
                    self.clear_err_queue
                    return TRUE
                else
                    self.update_err_queue
                    #backtrack
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.clear_err_queue
                return TRUE
            end
        else
            self.clear_err_queue
            return TRUE
        end
    end


    def lterm?
        top = @tok_queue[-1]
        if self.getTokenText == "not"
            self.nextToken
            if self.lfactor?
                self.clear_err_queue
                return TRUE
            else
                self.update_err_queue
                #backtrack
                self.backtrack(top)
                return FALSE
            end
        elsif self.lfactor?
            self.clear_err_queue
            return TRUE
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end


    def lfactor?
        if self.getTokenText == "true"
            self.nextToken
            self.clear_err_queue
            return TRUE
        elsif self.getTokenText == "false"
            self.nextToken
            self.clear_err_queue
            return TRUE
        elsif self.relop?
            self.clear_err_queue
            return TRUE
        else
            self.update_err_queue
            return FALSE
        end
    end


    def relop?
        top = @tok_queue[-1]
        if self.addop?
            if self.getTokenText == "<=" || self.getTokenText == "<" || self.getTokenText == "="
                self.nextToken
                if self.addop?
                    self.clear_err_queue
                    return TRUE
                else
                    self.update_err_queue
                    #backtrack
                    self.backtrack(top)
                    return FALSE
                end
            else
                self.clear_err_queue
                return TRUE
            end
        else
            self.update_err_queue
            self.backtrack(top)
            return FALSE
        end
    end
end
