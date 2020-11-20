package com.expense.tracker.play.config.security.jwt;

import com.expense.tracker.play.config.security.service.CustomUserDetails;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.spec.SecretKeySpec;
import java.security.Key;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@RequiredArgsConstructor
@Component
public class JwtUtil {

    private final JwtConfig jwtConfig;

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    // SECRET_KEY property to generate the signing key, and uses that to verify token
    public Claims extractAllClaims(String token) {
        return Jwts.parserBuilder().setSigningKey(jwtConfig.getSecretKey()).build().parseClaimsJws(token).getBody();
    }

    public Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public String generateToken(String username, CustomUserDetails customUserDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("id", customUserDetails.getId());
        claims.put("username", customUserDetails.getUsername());
        claims.put("password", customUserDetails.getPassword());
        claims.put("email", customUserDetails.getEmail());
        claims.put("authorities", customUserDetails.getAuthorities());
        return createToken(claims, username);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        Key hmacKey = new SecretKeySpec(Base64.getDecoder().decode(jwtConfig.getSecretKey()),
                SignatureAlgorithm.HS256.getJcaName());
        return Jwts.builder().setClaims(claims).setSubject(subject).setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + jwtConfig.getTokenExpiration()))
                .signWith(hmacKey).compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
}
