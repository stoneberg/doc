package com.expense.tracker.play.config.security.jwt;

import com.expense.tracker.play.config.security.service.CustomUserDetails;
import com.google.common.base.Strings;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static com.expense.tracker.play.config.security.jwt.JwtConstants.AUTH_HEADER;
import static com.expense.tracker.play.config.security.jwt.JwtConstants.TOKEN_PREFIX;

/**
 * Access Token 인증 (사용자 인증 후 발급된 JWT Token)
 */
public class JwtAuthorizationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthorizationFilter.class);

    private final UserDetailsService userDetailsService;
    private final JwtUtil jwtUtil;

    public JwtAuthorizationFilter(UserDetailsService userDetailsService, JwtUtil jwtUtil) {
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws IOException, ServletException {

        String authorizationHeader = request.getHeader(AUTH_HEADER);

        if (Strings.isNullOrEmpty(authorizationHeader) || !authorizationHeader.startsWith(TOKEN_PREFIX)) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authorizationHeader.replace(TOKEN_PREFIX, StringUtils.EMPTY);

        try {
            CustomUserDetails customUserDetails = (CustomUserDetails) restoreCustomUserDetails(token);
            setSecurityContextHolderContextAuthentication(customUserDetails, request);
            String username = jwtUtil.extractUsername(token);

            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                setSecurityContextHolderContextAuthentication(userDetails, request);
            }

        } catch (JwtException e) {
            throw new IllegalStateException(String.format("Your token ===> [%s] is invalid!", token));
        }

        filterChain.doFilter(request, response);
    }

    @SuppressWarnings("unchecked")
    public UserDetails restoreCustomUserDetails(String token) {
        Claims claims = jwtUtil.extractAllClaims(token);
        Integer id = (Integer) claims.get("id");
        String email = (String) claims.get("email");
        String username = (String) claims.get("username");
        String password = (String) claims.get("password");
        List<Map<String, String>> authorities = (List<Map<String, String>>) claims.get("authorities");

        Set<SimpleGrantedAuthority> simpleGrantedAuthorities = authorities.stream()
                .map(m -> new SimpleGrantedAuthority(m.get("authority"))).collect(Collectors.toSet());

       return new CustomUserDetails(Long.valueOf(id), username, email, password, simpleGrantedAuthorities);
    }

    public void setSecurityContextHolderContextAuthentication(UserDetails userDetails, HttpServletRequest request) {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken
                = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        usernamePasswordAuthenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
    }

}

