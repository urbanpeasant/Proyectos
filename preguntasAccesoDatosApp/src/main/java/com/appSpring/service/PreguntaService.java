package com.appSpring.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.appSpring.model.Pregunta;
import com.appSpring.repository.IPreguntaRepository;

@Service
public class PreguntaService {
	
	@Autowired
    private IPreguntaRepository preguntaRepository;


    public List<Pregunta> findAllPreguntas() {
        return preguntaRepository.findAll();
    }
    
    public Page<Pregunta> findPreguntasPaged(String texto, Pageable pageable) {
        return preguntaRepository.findByTextoIgnoraMayus(texto, pageable);
    }

    public Optional<Pregunta> findPreguntaById(Long id) {
        return preguntaRepository.findById(id);
    }

    public Pregunta save(Pregunta pregunta) {
        return preguntaRepository.save(pregunta);
    }

    public void delete(Pregunta pregunta) {
        preguntaRepository.delete(pregunta);
    }
}
