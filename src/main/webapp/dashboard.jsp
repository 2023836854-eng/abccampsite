<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ABC Campsite | Booking Performance Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
body {
    margin: 0;
    font-family: "Poppins", sans-serif;
    background: #f5f7fb;
    display: flex;
    height: 100vh;
    overflow: hidden;
}

/* Sidebar */
.sidebar {
    width: 250px;
    background: linear-gradient(180deg, #0b3b26, #0e6b37);
    color: #fff;
    display: flex;
    flex-direction: column;
    padding: 30px 20px;
    box-shadow: 4px 0 15px rgba(0,0,0,0.1);
}

.sidebar h2 {
    text-align: center;
    font-size: 22px;
    letter-spacing: 0.5px;
    margin-bottom: 40px;
}

.sidebar a {
    color: #d8efe0;
    text-decoration: none;
    padding: 12px 18px;
    border-radius: 10px;
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    font-weight: 500;
    transition: all 0.3s;
}

.sidebar a:hover {
    background: rgba(255,255,255,0.15);
    transform: translateX(6px);
}

.sidebar a.active {
    background: #1e5631;
    color: #fff;
}

.logout-btn {
    background: linear-gradient(90deg, #ff5f6d, #d32f2f);
    border: none;
    color: #fff;
    padding: 12px;
    border-radius: 8px;
    cursor: pointer;
    margin-top: auto;
    font-weight: bold;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
    transition: all 0.3s;
}

.logout-btn:hover {
    transform: scale(1.05);
}

/* Main */
.main {
    flex: 1;
    padding: 40px 55px;
    overflow-y: auto;
}

h1 {
    font-size: 30px;
    color: #2b3347;
    margin-bottom: 8px;
}

p {
    color: #555;
    margin-bottom: 30px;
}

/* Dashboard Cards */
.dashboard-cards {
    display: flex;
    gap: 25px;
    flex-wrap: wrap;
}

.card {
    flex: 1;
    min-width: 220px;
    background: rgba(255,255,255,0.9);
    border-radius: 18px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    padding: 25px;
    text-align: center;
    position: relative;
    backdrop-filter: blur(6px);
    transition: all 0.25s;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 18px rgba(0,0,0,0.15);
}

.card::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    height: 5px;
    width: 100%;
    border-radius: 18px 18px 0 0;
}

.card:nth-child(1)::before { background: #673ab7; } /* total bookings */
.card:nth-child(2)::before { background: #4caf50; }
.card:nth-child(3)::before { background: #f44336; }
.card:nth-child(4)::before { background: #2196f3; }

.card h3 {
    margin-top: 15px;
    font-size: 16px;
    color: #777;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.card b {
    font-size: 32px;
    color: #2b3347;
}

/* Graph Section */
.graph-section {
    display: flex;
    flex-wrap: wrap;
    margin-top: 45px;
    gap: 25px;
}

.graph-box {
    flex: 1;
    min-width: 420px;
    height: 310px;
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    padding: 25px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    transition: 0.3s;
}

.graph-box:hover {
    transform: translateY(-4px);
}

.graph-box h3 {
    margin-bottom: 15px;
    text-align: center;
    font-size: 18px;
    font-weight: 600;
    color: #2e3a59;
}

footer {
    text-align: center;
    padding: 15px;
    font-size: 13px;
    color: #777;
    margin-top: 40px;
    border-top: 1px solid #ddd;
}
</style>

<script>
function confirmLogout() {
    if (confirm("Are you sure you want to log out?")) {
        window.location.href = "logout.jsp";
    }
}
</script>
</head>
<body>

<%
String guestName = (String) session.getAttribute("guestName");
boolean loggedIn = guestName != null && !guestName.trim().isEmpty();

int totalBookings = 0, totalPaid = 0, totalCancelled = 0, totalCompleted = 0;
double totalPaidAmount = 0, totalCompletedAmount = 0;

if (loggedIn) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

        // 🔹 Count all bookings
        PreparedStatement ps = con.prepareStatement(
            "SELECT COUNT(*) AS totalBookings FROM bookings WHERE guest_name = ?"
        );
        ps.setString(1, guestName);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) totalBookings = rs.getInt("totalBookings");
        rs.close();

        // 🔹 Count per status
        ps = con.prepareStatement(
            "SELECT " +
            "SUM(CASE WHEN status='Paid' THEN 1 ELSE 0 END) AS paid, " +
            "SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END) AS cancelled, " +
            "SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed " +
            "FROM bookings WHERE guest_name = ?"
        );
        ps.setString(1, guestName);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalPaid = rs.getInt("paid");
            totalCancelled = rs.getInt("cancelled");
            totalCompleted = rs.getInt("completed");
        }
        rs.close();

        // 🔹 Total revenue
        ps = con.prepareStatement(
            "SELECT " +
            "SUM(CASE WHEN status='Paid' THEN total_price ELSE 0 END) AS paid_amount, " +
            "SUM(CASE WHEN status='Completed' THEN total_price ELSE 0 END) AS completed_amount " +
            "FROM bookings WHERE guest_name = ?"
        );
        ps.setString(1, guestName);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalPaidAmount = rs.getDouble("paid_amount");
            totalCompletedAmount = rs.getDouble("completed_amount");
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
} else {
    out.println("<p style='color:red;'>You must be logged in to view this dashboard.</p>");
}
%>


<div class="sidebar">
    <h2>ABC Campsite</h2>
    <a href="index.jsp">Home</a>
    <a href="register.jsp">Sign Up</a>
    <a href="bookinglist.jsp">My Bookings</a>
    <a href="bookingdashboard.jsp" class="active">Dashboard</a>
    <button class="logout-btn" onclick="confirmLogout()">Logout</button>
</div>

<div class="main">
    <h1>Booking Performance</h1>
    <% if (loggedIn) { %>
        <p>Welcome, <b><%=guestName%></b> Here's your latest booking summary.</p>
    <% } %>

    <div class="dashboard-cards">
        <div class="card">
            <h3>Total Bookings</h3>
            <b><%=totalBookings%></b>
        </div>
        <div class="card">
            <h3>Paid</h3>
            <b><%=totalPaid%></b>
        </div>
        <div class="card">
            <h3>Cancelled</h3>
            <b><%=totalCancelled%></b>
        </div>
        <div class="card">
            <h3>Completed</h3>
            <b><%=totalCompleted%></b>
        </div>
    </div>

    <div class="graph-section">
        <div class="graph-box">
            <h3>Booking Status Overview</h3>
            <canvas id="barChart"></canvas>
        </div>
        <div class="graph-box">
            <h3>Total Revenue (RM)</h3>
            <canvas id="pieChart"></canvas>
        </div>
    </div>

    <footer>&copy; 2025 ABC Campsite | Booking Performance Dashboard</footer>
</div>

<script>
const ctxBar = document.getElementById('barChart').getContext('2d');

// Gradient Colors
const gradientPaid = ctxBar.createLinearGradient(0, 0, 0, 300);
gradientPaid.addColorStop(0, '#4CAF50');
gradientPaid.addColorStop(1, '#A5D6A7');

const gradientCancelled = ctxBar.createLinearGradient(0, 0, 0, 300);
gradientCancelled.addColorStop(0, '#F44336');
gradientCancelled.addColorStop(1, '#FFCDD2');

const gradientCompleted = ctxBar.createLinearGradient(0, 0, 0, 300);
gradientCompleted.addColorStop(0, '#2196F3');
gradientCompleted.addColorStop(1, '#BBDEFB');

// Bar Chart
new Chart(ctxBar, {
    type: 'bar',
    data: {
        labels: ['Paid', 'Cancelled', 'Completed'],
        datasets: [{
            label: 'Number of Bookings',
            data: [<%=totalPaid%>, <%=totalCancelled%>, <%=totalCompleted%>],
            backgroundColor: [gradientPaid, gradientCancelled, gradientCompleted],
            borderRadius: 10
        }]
    },
    options: {
        plugins: {
            legend: { display: false },
            title: { display: true, text: 'Booking Status Overview', font: { size: 16, weight: 'bold' } }
        },
        scales: {
            y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: '#eee' } },
            x: { grid: { display: false } }
        },
        animation: { duration: 1200, easing: 'easeOutBounce' }
    }
});

// Doughnut Chart
new Chart(document.getElementById('pieChart'), {
    type: 'doughnut',
    data: {
        labels: ['Paid Amount', 'Completed Amount'],
        datasets: [{
            data: [<%=totalPaidAmount%>, <%=totalCompletedAmount%>],
            backgroundColor: ['#4CAF50', '#2196F3'],
            borderWidth: 2,
            hoverOffset: 8
        }]
    },
    options: {
        cutout: '65%',
        plugins: {
            legend: { position: 'bottom', labels: { font: { size: 13 } } },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        return context.label + ': RM ' + context.formattedValue;
                    }
                }
            }
        },
        animation: { animateRotate: true, duration: 1200 }
    }
});
</script>

</body>
</html>
