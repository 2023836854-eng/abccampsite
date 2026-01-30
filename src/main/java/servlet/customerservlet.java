package servlet;

import dao.customerdao;
import model.customer;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/customerservlet")  // PENTING! mesti sama dengan form action
public class customerservlet extends HttpServlet {

    private customerdao dao = new customerdao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("insert".equals(action)) {
            customer c = new customer();
            c.setName(req.getParameter("name"));
            c.setEmail(req.getParameter("email"));
            c.setPhone(req.getParameter("phone"));
            c.setPassword(req.getParameter("password"));
            dao.addCustomer(c);
            resp.sendRedirect("customer_list.jsp");
        } 
        else if ("reset".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.updatePassword(id, "abc123");
            resp.sendRedirect("customer_list.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteCustomer(id);
            resp.sendRedirect("customer_list.jsp");
        }
    }
}
