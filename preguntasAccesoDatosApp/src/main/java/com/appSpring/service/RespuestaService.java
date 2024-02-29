package com.appSpring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.appSpring.model.Respuesta;
import com.appSpring.repository.IRespuestaRepository;

@Service
public class RespuestaService {

    @Autowired
    public IRespuestaRepository respuestaRepository;

    public Respuesta save(Respuesta respuesta) {
        return respuestaRepository.save(respuesta);
    }

}
