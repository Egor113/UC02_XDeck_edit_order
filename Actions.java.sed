import lrapi.lr;
import java.sql.*;

public class Actions
{
	Connection connection = null;

	public int init() throws Throwable {
		lr.start_transaction("UC02_TR01_Add_task");
		try {
            Class.forName("oracle.jdbc.OracleDriver");
	    	String url = "jdbc:oracle:thin:@192.168.14.53:1522:orcl";
	    	connection = DriverManager.getConnection(url,"c##x5","c##x5");
	    	lr.log_message("Connection Success");
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
	    	lr.abort();
	  	}
		return 0;
	}

	public int action() throws Throwable {
		updateID();
		addTask();
		return 0;
	}
	
	public void updateID() throws Throwable{
		try (Statement statement = connection.createStatement()) {

            connection.setAutoCommit(false);
            try {
            	lr.read_file("../file_id.txt","ID", lr.EXIT_ACTION_AND_CONTINUE);
            	String str = "UPDATE ticket SET state_id = '1' WHERE id = '" + 
            		lr.eval_string("{ID}").trim() + "'";
            	statement.execute(str);
                connection.commit();
                lr.log_message("Update Success");
            } catch (SQLException e) {
            	e.printStackTrace();
                connection.rollback();
            }

            connection.setAutoCommit(true);
        }
	}
	
	public void addTask() throws Throwable{
		try (Statement statement = connection.createStatement()) {

            connection.setAutoCommit(false);
            try {
            	String insert_query = "INSERT INTO task (id, change_id," +
					"ticket_id, guid, header, text, priority_id, state_id," +
            		"client_id, create_date, external_system) values ('" +
            		lr.eval_string("{ID}").trim() + "','IDC2D620524153zdzPWAoX9OFgW4UB'," +
					"'"+ lr.eval_string("{ID}").trim() +
					"','d830c5ee-9b77-4bd1-879a-0c4d2c282a67'," +
					"'Уведомление о нарушении работы холодильного оборудования'," +
            		"'Просим решить проблему в кратчайший срок', " +
            		"'3', '2', '106', '1511190000000', 'ASKO')";
            	statement.execute(insert_query);
                connection.commit();
                lr.log_message("Insert Success");
            } catch (SQLException e) {
            	e.printStackTrace();
                connection.rollback();
            }

            connection.setAutoCommit(true);
        }
	}
	
	
	public int end() throws Throwable {
		try {
                connection.close();
            } catch (SQLException e2) {
                e2.printStackTrace();
            }
		lr.end_transaction("UC02_TR01_Add_task",lr.PASS);
		return 0;
	}
}
