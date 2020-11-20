package com.expense.tracker.play.common.filters;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

//@Component
//public class AuthFilter extends GenericFilterBean {
public class AuthFilter {

//    private static final Logger log = LoggerFactory.getLogger(GenericFilterBean.class);
//
//    @Value("${app.jwt.secret-key}")
//    private String secretKey;
//
//    @Override
//    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
//        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
//        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;
//        String authHeader = httpRequest.getHeader("Authorization");
//        log.info("@authHeader===================>{}", authHeader);
//
//        if (authHeader != null) {
//            String[] authHeaderArr = authHeader.split("Bearer ");
//
//            if (authHeaderArr.length > 1 && authHeaderArr[1] != null) {
//                String token = authHeaderArr[1];
//                try {
//                    Claims claims = Jwts.parser().setSigningKey(secretKey)
//                            .parseClaimsJws(token).getBody();
//
//                    // 세션을 가져온다. (가져올 세션이 없다면 생성한다.)
//                    HttpSession httpSession = httpRequest.getSession(true);
//
//                    // session에 User attribute를 바인딩한다.
//                    httpSession.setAttribute("user", new UserSession(claims.get("email").toString()));
//
//                } catch (Exception e) {
//                    httpResponse.sendError(HttpStatus.FORBIDDEN.value(), "Invalid or Expired token");
//                    return;
//                }
//            } else {
//                httpResponse.sendError(HttpStatus.FORBIDDEN.value(), "Authorization token must be Bearer [token]");
//                return;
//            }
//        } else {
//            httpResponse.sendError(HttpStatus.FORBIDDEN.value(), "Authorization token must be provided");
//            return;
//        }
//
//        filterChain.doFilter(servletRequest, servletResponse);
//    }
}