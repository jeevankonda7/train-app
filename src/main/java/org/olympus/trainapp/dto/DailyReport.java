package org.olympus.trainapp.dto;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

@Entity
public class DailyReport {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	@OneToOne
	private CreateTrain train;
	@Column(nullable=false)
	private String from_loc;
	@Column(nullable=false)
	private String to_loc;
	@Column(nullable=false)
	private String date;
	@OneToOne
	private CreateJourney journey;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public CreateTrain getTrain() {
		return train;
	}
	public void setTrain(CreateTrain train) {
		this.train = train;
	}
	public String getFrom_loc() {
		return from_loc;
	}
	public void setFrom_loc(String from_loc) {
		this.from_loc = from_loc;
	}
	public String getTo_loc() {
		return to_loc;
	}
	public void setTo_loc(String to_loc) {
		this.to_loc = to_loc;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public CreateJourney getJourney() {
		return journey;
	}
	public void setJourney(CreateJourney journey) {
		this.journey = journey;
	}
	
	
	
	

}
