package com.appSpring.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;


//Con @controller indico que es un controlador de springboot

@Controller
//La clase implemena la interfaz de BS errorcontroller, para manejarlos y hacer el nuestro propio.
public class ErroresController implements ErrorController {

	
	//Con esto mapeo las peticiones get a /error
    @GetMapping("/error")
    public String handleError(HttpServletRequest request) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

        if (status != null) { //si el estado de null no es nulo...
            Integer statusCode = Integer.valueOf(status.toString());//... aquí lo paso a Integer para tratarlo.

            if (statusCode == HttpStatus.NOT_FOUND.value()) {//y si el stado es el 404
                return "error404"; //devuelvo mi vista custom error404.html
            }
        }

        // para los demás errores dejo el default
        return "error";
    }

}
