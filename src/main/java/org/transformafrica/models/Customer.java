package org.transformafrica.models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
@Table(name = "Customers")
public class Customer extends PanacheEntity {

	@Column(name = "name")
	private String name;
	@Column(name = "email")
	private String email;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public static List<Customer> getAllCustomers() {
		return Customer.findAll().list();
	}
}
