object TypeChecker {

    def read_file(file: String): String = {

        val src = io.Source.fromFile(file)
        val str = try src.mkString finally src.close
        
        return str
    }

    def get_type(expr: String, expr_map: Map[String, String], rule_map: Map[String, String]): String = {
        /*
        typecheck string
        */

        // match all \$\d+
        val var_match = """\$\d+""".r
        val new_expr = var_match.replaceAllIn(expr, m => get_type(expr_map(m.group(0)), expr_map, rule_map))

        // if no matches in expr, return the match in rule_map
        val expr_key = new_expr.split("->")(0).trim
        try {
            return rule_map(expr_key)
        } catch {
            case e: Exception => throw new Exception("ERROR: no type in environment for " + expr_key)
        }
        
    }
    
    def main(args: Array[String]): Unit = {

        // Read in environment file
        val expr = read_file(args(0)).split("\n").map(x => x.replace("&", ""))
        val expr_arr = expr.map(x => x.split("->"))
        val expr_map = expr_arr.map(x => x(1).trim -> x(0).trim).toMap

        // Read in rule file
        val rule = read_file(args(1)).split("\n")
        val rule_arr = rule.map(x => x.split("->"))
        val rule_map = rule_arr.map(x => x(0).trim -> x(1).trim).toMap

        val root_expr = expr_arr(0)(0)

        try {
            // get the type of the first expression
            val checked_type = get_type(root_expr, expr_map, rule_map)
            println(checked_type)
        } catch {
            case e: Exception => println(e.getMessage)
        }
    }
}