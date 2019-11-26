/*
 * LoadRunner Java script. (Build: _build_number_)
 * 
 * Script Description: 
 *                     
 */

import lrapi.lr;
import java.sql.*;

public class Actions
{
	Connection connection = null;

	public int init() throws Throwable {
		return 0;
	}//end of init


	public int action() throws Throwable {
		try {
            Class.forName("oracle.jdbc.OracleDriver");
	    	String url = "jdbc:oracle:thin:@192.168.14.53:1522:orcl";
	    	connection = DriverManager.getConnection(url,"c##x5","c##x5");
	    	lr.log_message("JDBC Connection Successful");
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
		} catch (SQLException e) {
	    	lr.log_message("Database Connection Failed, Please check your connection string");
	    	lr.abort();
	  	}
		try (Statement statement = connection.createStatement()) {

            connection.setAutoCommit(false);
            try {
            	lr.read_file("C:/Users/student/Desktop/Ogdanets/Project/UC01_task_create/file_id.txt","ID", lr.EXIT_ACTION_AND_CONTINUE);
            	String str = "UPDATE ticket SET state_id = '2' WHERE id = '" + lr.eval_string("{ID}").trim() + "'";
            	statement.execute(str);
                connection.commit();
                lr.log_message("Success");
            } catch (SQLException e) {
            	lr.log_message("Error");
                connection.rollback();
            }

            connection.setAutoCommit(true);
        }
		
		return 0;
	}
	public int end() throws Throwable {
		return 0;
	}//end of end
}
