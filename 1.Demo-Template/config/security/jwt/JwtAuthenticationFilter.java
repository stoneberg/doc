package com.expense.tracker.play.config.security.jwt;

import com.expense.tracker.play.config.security.service.CustomUserDetails;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.FilterChain;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

import static com.expense.tracker.play.config.security.jwt.JwtConstants.AUTH_HEADER;
import static com.expense.tracker.play.config.security.jwt.JwtConstants.TOKEN_PREFIX;

/**
 * 사용자 Credential 인증
 */
public class JwtAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    public JwtAuthenticationFilter(AuthenticationManager authenticationManager, JwtUtil jwtUtil) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        setFilterProcessesUrl(JwtConstants.SING_IN_URL);
    }

    /**
     * 인증을 위해 request에서 username, password를 추출, UsernamePasswordAuthenticationToken에 적재
     */
    @Override
    public Authentication attemptAuthentication(HttpServletRequest req, HttpServletResponse res) {
        try {
            JwtRequest credentials = new ObjectMapper().readValue(req.getInputStream(), JwtRequest.class);
            return authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(credentials.getUsername(),
                    credentials.getPassword(), new ArrayList<>()));
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    /**
     * 인증 성공 시 Access Token 발급
     */
    @Override
    protected void successfulAuthentication(HttpServletRequest req, HttpServletResponse res, FilterChain chain, Authentication auth) {
        CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
        String token = jwtUtil.generateToken(auth.getName(), customUserDetails);
        logger.info("@issuing token===============>{}", token);
        res.addHeader(AUTH_HEADER, TOKEN_PREFIX + token);
    }
}
