/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

import java.util.List;

/**
 *
 * @author aleja
 */
public class Instructor {

    private int id;
    private String nombre;
    private String email;
    private String telefono;
    private String especialidad;
    private String clases;
    private List<Integer> clasesIds;
    private boolean activo;

    public Instructor() {
    }

    public Instructor(int id, String nombre, String email, String telefono, String especialidad, String clases, List<Integer> clasesIds, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.telefono = telefono;
        this.especialidad = especialidad;
        this.clases = clases;
        this.clasesIds = clasesIds;
        this.activo = activo;
    }

   

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getClases() {
        return clases;
    }

    public void setClases(String clases) {
        this.clases = clases;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public List<Integer> getClasesIds() {
        return clasesIds;
    }

    public void setClasesIds(List<Integer> clasesIds) {
        this.clasesIds = clasesIds;
    }

    
}
