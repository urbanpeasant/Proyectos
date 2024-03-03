package com.appSockets.service;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

@Service
public class ApiService {

    private final WebClient webClient;

    public ApiService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("http://jsonplaceholder.typicode.com").build();
    }

    public Mono<String> fetchUserData() {
        return this.webClient.get()
                             .uri("/users/1") 
                             .retrieve()
                             .bodyToMono(String.class); 
    }
}


//http://jsonplaceholder.typicode.com/users/1

