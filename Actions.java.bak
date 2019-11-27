import lrapi.lr;
import java.sql.*;
import java.util.HashSet;
import java.util.Set;

public class Actions
{
	Connection connection = null;
	Statement statement = null;
	Set<String> IDset = null;

	public int init() throws Throwable {
		lr.start_transaction("UC02_TR01_Add_task");
		try {
            Class.forName("oracle.jdbc.OracleDriver");
	    	String url = "jdbc:oracle:thin:@192.168.14.53:1522:orcl";
	    	connection = DriverManager.getConnection(url,"c##x5","c##x5");
	    	statement = connection.createStatement();
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
		getTasks();
		addTasks();
		updateIDs();
		return 0;
	}
	
	public void updateIDs() throws Throwable{
		connection.setAutoCommit(false);
        try {
			for(String id: IDset) {
	            String str = "UPDATE ticket SET state_id = '1' WHERE id = '" + 
	            id + "'";
	            statement.execute(str);
			}
            connection.commit();
            lr.log_message("Update Success");
            } catch (SQLException e) {
            	e.printStackTrace();
                connection.rollback();
            }
        connection.setAutoCommit(true);
	}
	
	public void addTasks() throws Throwable{
		connection.setAutoCommit(false);
		try {
			for(String id: IDset) {
				    String insert_query = "INSERT INTO task (id, change_id," +
					"ticket_id, guid, header, text, priority_id, state_id," +
	            	"client_id, create_date, external_system) values ('" +
	            	id + "','IDC2D620524153zdzPWAoX9OFgW4UB'," +
					"'"+ id +
					"','d830c5ee-9b77-4bd1-879a-0c4d2c282a67'," +
					"'Уведомление о нарушении работы холодильного оборудования'," +
	            	"'Просим решить проблему в кратчайший срок', " +
	            	"'3', '2', '106', '1511190000000', 'ASKO')";
	            statement.execute(insert_query);
       		}
			connection.commit();
			lr.log_message("Insert Success");
		} catch (SQLException e) {
	    	e.printStackTrace();
	        connection.rollback();
	    }
        connection.setAutoCommit(true);
    }
	
	public void getTasks() throws Throwable{
		String sqlRead = "select * from ticket where state_id =  '-1'";
		ResultSet rs = statement.executeQuery(sqlRead);
		IDset = new HashSet<>();
        while (rs.next()) {
             IDset.add(rs.getString("id"));
        }
	}
	
	public int end() throws Throwable {
		try {
                connection.close();
                statement.close();
            } catch (SQLException e2) {
                e2.printStackTrace();
            }
		lr.end_transaction("UC02_TR01_Add_task",lr.PASS);
		return 0;
	}
}
