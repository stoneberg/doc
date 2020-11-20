package com.expense.tracker.play.common.audit;

import com.expense.tracker.play.config.security.service.CustomUserDetails;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

@Slf4j
public class AuditorAwareImpl implements AuditorAware<String> {

    @Override
    public Optional<String> getCurrentAuditor() {
        String creator = "SYSTEM";
        if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            creator = user.getEmail();
        }
        return Optional.of(creator);
    }

}
