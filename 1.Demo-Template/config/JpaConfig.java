package com.expense.tracker.play.config;

import com.expense.tracker.play.common.audit.AuditorAwareImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Configuration
@EnableJpaAuditing
public class JpaConfig {

    @Bean
    public AuditorAwareImpl auditorAware() {
        return new AuditorAwareImpl();
    }
}

