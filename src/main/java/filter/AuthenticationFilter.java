package filter;

import utils.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Authentication filter to protect guest pages
 * Checks if guest is logged in before allowing access to protected resources
 */
@WebFilter(urlPatterns = {
    "/bookinglist.jsp",
    "/booking.jsp",
    "/payment.jsp",
    "/viewbooking.jsp",
    "/viewreceipt.jsp",
    "/dashboard.jsp",
    "/BookingServlet",
    "/PaymentServlet",
    "/UpdateBookingServlet"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Check if guest is logged in
        if (!SessionUtil.isGuestLoggedIn(httpRequest)) {
            // Get the requested URI for redirect after login
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            
            String redirectUrl = requestURI;
            if (queryString != null) {
                redirectUrl += "?" + queryString;
            }
            
            // Redirect to login page with return URL
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/login.jsp?redirect=" + 
                                     java.net.URLEncoder.encode(redirectUrl, "UTF-8") +
                                     "&msg=login_required");
            return;
        }
        
        // User is authenticated, continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
