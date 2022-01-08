package org.transformafrica.controller;

import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.transformafrica.models.Customer;

@ApplicationScoped
@Path("/transfromapi/v1")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ApplicationController {
	
	@GET
	public List<Customer> getAllCustomers() {
		return Customer.getAllCustomers();

	}

}
