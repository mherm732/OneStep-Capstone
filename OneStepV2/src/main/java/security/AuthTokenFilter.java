package security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

@Component
public class AuthTokenFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain)
                                    throws ServletException, IOException {
    	if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
    	    response.setStatus(HttpServletResponse.SC_OK);
    	    return;
    	}
    	
    	try {
            String path = request.getServletPath();
            System.out.println("Raw Authorization Header: " + request.getHeader("Authorization"));
            System.out.println("Request Path: " + path);
            if(path.startsWith("/api/auth")) {
            	filterChain.doFilter(request, response);
            	return;
            }
            
            String jwt = parseJwt(request);
            
            if (jwt == null) {
                System.out.println("No JWT token found in Authorization header.");
            } else if (!jwtUtils.validateJwtToken(jwt)) {
                System.out.println("Invalid JWT token received.");
            }

            if (jwt != null && jwtUtils.validateJwtToken(jwt)) {
                String email = jwtUtils.getEmailFromJwtToken(jwt);
                System.out.println("Token is valid. Authenticated user: " + email);
                
                UserDetails userDetails = userDetailsService.loadUserByUsername(email);
                UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities());

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception e) {
            System.err.println("Cannot set user authentication: " + e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (headerAuth != null && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }

        return null;
    }
}
