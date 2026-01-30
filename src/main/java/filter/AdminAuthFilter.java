package filter;

import utils.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Admin authentication filter to protect admin pages
 * Checks if admin is logged in before allowing access to admin resources
 */
@WebFilter(urlPatterns = {
    "/admin/*"
})
public class AdminAuthFilter implements Filter {

    // Public paths that don't require authentication
    private static final String[] PUBLIC_PATHS = {
        "/admin/login.jsp"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Check if the request is for a public path
        if (isPublicPath(requestURI, contextPath)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if admin is logged in
        if (!SessionUtil.isAdminLoggedIn(httpRequest)) {
            // Redirect to admin login page
            httpResponse.sendRedirect(contextPath + "/admin/login.jsp?msg=login_required");
            return;
        }
        
        // Admin is authenticated, continue with the request
        chain.doFilter(request, response);
    }

    /**
     * Check if the requested path is a public path
     */
    private boolean isPublicPath(String requestURI, String contextPath) {
        String path = requestURI.substring(contextPath.length());
        
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath)) {
                return true;
            }
        }
        
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
