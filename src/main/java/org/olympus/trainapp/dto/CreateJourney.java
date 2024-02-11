package org.olympus.trainapp.dto;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;


@Entity
public class CreateJourney {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	@Column(nullable=false,unique=true)
	private Integer bookingid;
	@Column(nullable=false)
	private String agency;
	@Column(nullable=false)
	private Long phone;
	@OneToMany(mappedBy = "journey", cascade= CascadeType.ALL)
	private List<DailyReport> report;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getBookingid() {
		return bookingid;
	}
	public void setBookingid(Integer bookingid) {
		this.bookingid = bookingid;
	}
	public String getAgency() {
		return agency;
	}
	public void setAgency(String agency) {
		this.agency = agency;
	}
	public Long getPhone() {
		return phone;
	}
	public void setPhone(Long phone) {
		this.phone = phone;
	}
	public List<DailyReport> getReport() {
		return report;
	}
	public void setReport(List<DailyReport> report) {
		this.report = report;
	}
	
	

}
