package utils;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/abccampsite";
    private static final String USER = "root";   // user default XAMPP
    private static final String PASS = "";       // kosong sebab XAMPP default tiada password

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Berjaya sambung database!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
