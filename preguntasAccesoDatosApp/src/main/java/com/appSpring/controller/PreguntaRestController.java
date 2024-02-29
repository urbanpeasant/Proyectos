package com.appSpring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.appSpring.model.Pregunta;
import com.appSpring.service.PreguntaService;

@RestController
@RequestMapping("/api/preguntas")
public class PreguntaRestController {

    @Autowired
    private PreguntaService preguntaService;

    // Obtener todas las preguntas
    @GetMapping
    public List<Pregunta> getAllPreguntas() {
        return preguntaService.findAllPreguntas();
    }

    // Obtener una pregunta por ID
    @GetMapping("/{id}")
    public ResponseEntity<Pregunta> getPreguntaById(@PathVariable Long id) {
        return preguntaService.findPreguntaById(id)
                .map(pregunta -> ResponseEntity.ok(pregunta))
                .orElse(ResponseEntity.notFound().build());
    }

    // Crear una nueva pregunta
    @PostMapping
    public Pregunta createPregunta(@RequestBody Pregunta pregunta) {
        return preguntaService.save(pregunta);
    }

    // Actualizar una pregunta existente
    @PutMapping("/{id}")
    public ResponseEntity<Pregunta> updatePregunta(@PathVariable Long id, @RequestBody Pregunta preguntaDetails) {
        return preguntaService.findPreguntaById(id).map(pregunta -> {
            pregunta.setTexto(preguntaDetails.getTexto());
            pregunta.setTipo(preguntaDetails.getTipo());
            pregunta.setRespuesta(preguntaDetails.getRespuesta());
            pregunta.setOpciones(preguntaDetails.getOpciones());
            final Pregunta updatedPregunta = preguntaService.save(pregunta);
            return ResponseEntity.ok(updatedPregunta);
        }).orElse(ResponseEntity.notFound().build());
    }

    // Eliminar una pregunta
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePregunta(@PathVariable Long id) {
        return preguntaService.findPreguntaById(id).map(pregunta -> {
            preguntaService.delete(pregunta);
            return ResponseEntity.status(HttpStatus.OK).build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
