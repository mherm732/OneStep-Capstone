package security;

import java.util.Date;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtUtils {
	private final String jwtSecret = "nT2lLTT59JUzY1BS3Af6c9FL+H1kBS8XKtwO2aIj6rGOuHRPvZXZ7y3B0ElLM+Fgph1OPX7Zp6RLDrMIM5xW1Q==";
	private final long jwtExpirationMs = 86400000;
	
	@SuppressWarnings("deprecation")
	public String generateJwtToken(Authentication authentication) {
		UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();
		return Jwts.builder()
				.setSubject(userPrincipal.getUsername())
				.setIssuedAt(new Date())
				.setExpiration(new Date(new Date().getTime() + jwtExpirationMs))
				.signWith(SignatureAlgorithm.HS512, jwtSecret)
				.compact();
	}
	
	@SuppressWarnings("deprecation")
	public String getEmailFromJwtToken(String token) {
		return Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token).getBody().getSubject();
	}
	
	@SuppressWarnings("deprecation")
	public boolean validateJwtToken(String token) {
		try {
			Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
