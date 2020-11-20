package com.expense.tracker.play.common.filters;

import lombok.Getter;

import java.io.Serializable;

@Getter
public class UserSession implements Serializable {
    private String email;

    public UserSession(String email) {
        this.email = email;
    }
}
