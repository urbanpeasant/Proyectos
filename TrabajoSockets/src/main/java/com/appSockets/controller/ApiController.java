package com.appSockets.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.appSockets.service.ApiService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import reactor.core.publisher.Mono;

@RestController
public class ApiController {

    private final ApiService apiService;

    public ApiController(ApiService apiService) {
        this.apiService = apiService;
    }

    @Operation(summary = "prueba Swagger api")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Todo bien"),
            @ApiResponse(responseCode = "404", description = "Todo mal")
    })
    @GetMapping("/")
    public Mono<String> fetchUser() {
        return apiService.fetchUserData();
    }
}
