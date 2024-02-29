package com.appSpring.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.appSpring.model.Pregunta;

public interface IPreguntaRepository extends JpaRepository<Pregunta, Long>{
	/*Esto me deja hacer un select de las preguntas por el texto ignorando minusculasymnayusculas y usarlo en el buscador de la web*/
	@Query("SELECT p FROM Pregunta p WHERE :texto = '' OR LOWER(p.texto) LIKE LOWER(CONCAT('%', :texto, '%'))")
    Page<Pregunta> findByTextoIgnoraMayus(String texto, Pageable pageable);
}


