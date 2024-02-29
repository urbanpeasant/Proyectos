package com.appSpring.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity //JPA pa mapear a tabla en db
@Data //lombok 
@NoArgsConstructor 
@AllArgsConstructor
@Table(name = "preguntas")

public class Pregunta {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(length = 2)
	private String tipo;
	
	@Column(columnDefinition = "TEXT")
	private String texto;
	
	@Column(length = 255)
	private String respuesta;
	
	@Column(columnDefinition = "TEXT")
	private String opciones;
	
	
	

	
	
	
	

}
