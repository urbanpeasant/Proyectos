// VistaController.java
package com.appSpring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.appSpring.model.Pregunta;
import com.appSpring.model.Respuesta;
import com.appSpring.service.PreguntaService;
import com.appSpring.service.RespuestaService;

import jakarta.servlet.http.HttpSession;


//anotación para controlador como siempre
@Controller
public class PreguntaController {
	
	//un array de string pa guardar las rutas de las imgs random.
	
	private static final String[] IMAGENES = {
		"imagenes/image1.jpg",
		"imagenes/image2.jpg",
		"imagenes/image3.jpg",
	};

	// Autowired para inyectar la dependencia de spring y usar el service de pregunta
    @Autowired
    private PreguntaService preguntaService;
    @Autowired
    private RespuestaService respuestaService;
    
    
    //Mapeo los get a la raiz. Auí voy a ir a la página home. 
    @GetMapping("/")
    public String home(Model model) {
    	//con el random pillo una imagen del array y la meto en el modelo
        String imagenRandom = IMAGENES[new Random().nextInt(IMAGENES.length)];
        model.addAttribute("imagenRandom", imagenRandom);
        return "home";
    }

//Esto es de antes de paginar. Lo dejo comentado 25/02/24
    
//    @GetMapping("/preguntas")
//    public String listaPreguntas(Model model) {
//        model.addAttribute("preguntas", preguntaService.findAllPreguntas());
//        return "preguntas";
//    }

    @GetMapping("/preguntas") // Mapeo a /preguntas
    public String listaPreguntas(
    		Model model, 
    		@RequestParam(value = "texto", defaultValue = "") String texto, 
    		@RequestParam(value = "isListado", defaultValue = "false") boolean isListado, 
    		@RequestParam(value = "page", defaultValue = "0") int page, 
    		@RequestParam(value = "size", defaultValue = "5") int size) {
        Pageable pageable = PageRequest.of(page, size); // Creo un pageable para poder paginar.
        Page<Pregunta> paginaDePreguntas = preguntaService.findPreguntasPaged(texto, pageable); // y aqui obtengo una lista de preguntas ya paginadas.
        
        // Añade al modelo la lista de preguntas, si es la última página, la página actual y el tamaño de página
        model.addAttribute("preguntas", paginaDePreguntas.getContent());
        model.addAttribute("esUltimaPagina", paginaDePreguntas.isLast());
        model.addAttribute("esPrimeraPagina", paginaDePreguntas.isFirst());
        model.addAttribute("paginaActual", page);
        model.addAttribute("tamanoPagina", size);
        model.addAttribute("totalPaginas", paginaDePreguntas.getTotalPages());

        return isListado ? "listado" : "preguntas"; // devuelvo la vista ya paginada por grupo de preguntas. 
    }

    @GetMapping("/preguntas/crear")
    public String mostrarFormularioDeCreacion(Model model) {
        model.addAttribute("pregunta", new Pregunta());
        return "crearPregunta"; // Nombre del archivo HTML para el formulario de creación
    }
        
    @PostMapping("/preguntas/crear")
    public String crearPregunta(@ModelAttribute Pregunta pregunta) {
        preguntaService.save(pregunta);
        return "redirect:/preguntas";
    }
        
    @GetMapping("/preguntas/editar/{id}")
    public String mostrarFormularioDeEdicion(@PathVariable Long id, Model model) {
        Pregunta pregunta = preguntaService.findPreguntaById(id)
                            .orElseThrow(() -> new IllegalArgumentException("ID de pregunta inválido: " + id));
        model.addAttribute("pregunta", pregunta);
        return "editarPregunta"; // Nombre del archivo HTML para el formulario de edición
    }

    @PostMapping("/preguntas/editar/{id}")
    public String actualizarPregunta(@PathVariable Long id, @ModelAttribute Pregunta pregunta) {
        pregunta.setId(id);
        preguntaService.save(pregunta);
        return "redirect:/preguntas";
    }
    
    @GetMapping("/preguntas/eliminar/{id}")
    public String eliminarPregunta(@PathVariable Long id) {
        preguntaService.findPreguntaById(id)
            .ifPresent(pregunta -> preguntaService.delete(pregunta));
        return "redirect:/preguntas";
    }

    @PostMapping("/guardarRespuestas")
    public String guardarRespuestas(@RequestParam Map<String, String> respuestas,
                                    @RequestParam("paginaActual") int paginaActual,
                                    @RequestParam("tamanoPagina") int tamanoPagina,
                                    HttpSession session) {
        @SuppressWarnings("unchecked")
		Map<String, String> respuestasSession = (Map<String, String>) session.getAttribute("respuestasSession");
        if (respuestasSession == null) {
            respuestasSession = new HashMap<>();
        }
        
        respuestasSession.putAll(respuestas);
        session.setAttribute("respuestasSession", respuestasSession);

        Pageable pageable = PageRequest.of(paginaActual, tamanoPagina);
        Page<Pregunta> paginaDePreguntas = preguntaService.findPreguntasPaged("", pageable);
        boolean haySiguientePagina = paginaActual < paginaDePreguntas.getTotalPages() - 1;

        if (haySiguientePagina) {
            return "redirect:/preguntas?page=" + (paginaActual + 1) + "&size=" + tamanoPagina;
        } else {
            return "redirect:/enviarRespuestas";
        }
    }
    
    @GetMapping("/enviarRespuestas")
    @Transactional
    public String enviarRespuestas(HttpSession session, Model model) {
        @SuppressWarnings("unchecked")
		Map<String, String> respuestasSession = (Map<String, String>) session.getAttribute("respuestasSession");
        respuestasSession.forEach((key, value) -> {
            if(key.startsWith("respuestas[")) {
            	String preguntaIdFormateada = key.replace("respuestas[", "").replace("]", "");
            	Long preguntaId = Long.parseLong(preguntaIdFormateada);
                String valorRespuesta = value;

                Respuesta respuesta = new Respuesta();
                respuesta.setPreguntaId(preguntaId);
                respuesta.setValor(valorRespuesta);

                respuestaService.save(respuesta);
            }

        });
        session.removeAttribute("respuestasSession");

        List<Pregunta> preguntas = preguntaService.findAllPreguntas();
        model.addAttribute("preguntas", preguntas);
        model.addAttribute("respuestasSeleccionadas", respuestasSession);

        return "resultados";
    }
}
