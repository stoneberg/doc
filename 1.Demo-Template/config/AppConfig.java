package com.expense.tracker.play.config;

import com.expense.tracker.play.common.annotations.LoginUserArgumentResolver;
import com.expense.tracker.play.common.filters.AuthFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.servlet.FilterRegistration;
import java.util.List;

@RequiredArgsConstructor
@Configuration
public class AppConfig implements WebMvcConfigurer {

    private final LoginUserArgumentResolver loginUserArgumentResolver;

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
        argumentResolvers.add(loginUserArgumentResolver);
    }

//    @Bean
//    public FilterRegistrationBean<AuthFilter> filterRegistrationBean(AuthFilter authFilter) {
//        FilterRegistrationBean<AuthFilter> registration = new FilterRegistrationBean<>();
//        registration.setFilter(authFilter);
//        registration.addUrlPatterns("/api/categories/*");
//        return registration;
//    }

}
