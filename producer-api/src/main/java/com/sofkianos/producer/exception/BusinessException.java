package com.sofkianos.producer.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

/**
 * Custom runtime exception for business logic errors.
 */
@Getter
public class BusinessException extends RuntimeException {
    
    private final HttpStatus status;

    public BusinessException(String message) {
        this(message, HttpStatus.BAD_REQUEST);
    }

    public BusinessException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
