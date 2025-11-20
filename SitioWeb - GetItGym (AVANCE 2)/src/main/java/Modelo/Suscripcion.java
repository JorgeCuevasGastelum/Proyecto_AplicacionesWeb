/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author infemovdev
 */

public class Suscripcion {
    private int id;
    private String tipo;
    private double precio;
    
    // Getters y Setters
    public Suscripcion() {}
    public Suscripcion(int id, String tipo, double precio) {
        this.id = id; this.tipo = tipo; this.precio = precio;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
}
