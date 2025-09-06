package com.school.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {
    
    // In production, this should be loaded from environment variables
    private static final String SECRET_KEY = "mySecretKeyForSchoolManagementSystemThatIsLongEnoughForHS256Algorithm";
    private static final int JWT_EXPIRATION = 24 * 60 * 60 * 1000; // 24 hours
    
    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    }
    
    public String generateToken(String mobileNumber, String role, Long schoolId, String name) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("mobileNumber", mobileNumber);
        claims.put("role", role);
        claims.put("schoolId", schoolId);
        claims.put("name", name);
        claims.put("type", "access");
        
        return createToken(claims, mobileNumber);
    }
    
    public String generateRefreshToken(String mobileNumber) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("type", "refresh");
        
        return createToken(claims, mobileNumber);
    }
    
    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + JWT_EXPIRATION))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }
    
    public String extractMobileNumber(String token) {
        return extractClaim(token, Claims::getSubject);
    }
    
    public String extractRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }
    
    public Long extractSchoolId(String token) {
        Object schoolIdObj = extractClaim(token, claims -> claims.get("schoolId"));
        if (schoolIdObj == null) {
            return null;
        }
        if (schoolIdObj instanceof Integer) {
            return ((Integer) schoolIdObj).longValue();
        }
        return (Long) schoolIdObj;
    }
    
    public String extractName(String token) {
        return extractClaim(token, claims -> claims.get("name", String.class));
    }
    
    public String extractTokenType(String token) {
        return extractClaim(token, claims -> claims.get("type", String.class));
    }
    
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
    
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }
    
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
    
    public Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
    
    public Boolean validateToken(String token, String mobileNumber) {
        final String extractedMobileNumber = extractMobileNumber(token);
        return (extractedMobileNumber.equals(mobileNumber) && !isTokenExpired(token));
    }
    
    public Boolean isAccessToken(String token) {
        return "access".equals(extractTokenType(token));
    }
    
    public Boolean isRefreshToken(String token) {
        return "refresh".equals(extractTokenType(token));
    }
}
