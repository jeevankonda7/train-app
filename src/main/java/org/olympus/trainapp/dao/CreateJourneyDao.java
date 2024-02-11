package org.olympus.trainapp.dao;

import java.util.Iterator;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.transaction.Transactional;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.olympus.trainapp.dto.CreateJourney;
import org.olympus.trainapp.dto.CreateTrain;
import org.olympus.trainapp.dto.DailyReport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CreateJourneyDao {

	@Autowired
	private Session session;

	@Autowired
	private CreateTrainDao trainDao;

	@Transactional
	public void saveRecords(CreateJourney journey) {
		session.save(journey);
		for (DailyReport report : journey.getReport()) {
			Transaction t = session.beginTransaction();
			report.setJourney(journey);
			Integer trainId = report.getTrain().getId();
			CreateTrain train = session.find(CreateTrain.class, trainId);
			report.setTrain(train);
			session.save(report);
			t.commit();
		}
	}

	public CreateJourney findRecord(String id) {
		Integer i = Integer.parseInt(id);
		CreateJourney journey = session.get(CreateJourney.class, i);
		if (journey != null)
			return journey;
		else
			return null;
	}

	public List<CreateJourney> findRecords() {
		String query = "select c from CreateJourney c";
		Query<CreateJourney> qs = session.createQuery(query);
		List<CreateJourney> journeyList = qs.getResultList();
		if (journeyList.size() > 0)
			return journeyList;
		else
			return null;
	}

	public void updateRecords(CreateJourney journey) {
	    CreateJourney j = session.get(CreateJourney.class, journey.getId());
	    List<DailyReport> backend = j.getReport();
	    List<DailyReport> frontend = journey.getReport();
	    Transaction t = session.beginTransaction();
	    try {
	        j.setAgency(journey.getAgency());
	        j.setBookingid(journey.getBookingid());
	        j.setPhone(journey.getPhone());
	        session.update(j);
	        
	        for (DailyReport formData : frontend) {
	            if (formData.getId() == null && formData.getDate()!=null) {
	                formData.setJourney(j);
	                Integer id = formData.getTrain().getId();
	                CreateTrain train = session.get(CreateTrain.class, id);
	                formData.setTrain(train);
	                session.clear();
	                session.save(formData);
	            } else {
	                for (DailyReport dbData : backend) {
	                    if (dbData.getId() == formData.getId()) {
	                        DailyReport temp = session.get(DailyReport.class, dbData.getId());
	                        temp.setFrom_loc(formData.getFrom_loc());
	                        temp.setTo_loc(formData.getTo_loc());
	                        temp.setDate(formData.getDate());
	                        Integer id = formData.getTrain().getId();
	                        CreateTrain train = session.get(CreateTrain.class, id);
	                        temp.setTrain(train);
	                        temp.setJourney(j);
	                        session.update(temp);
	                    }
	                }
	            }
	        }
	        t.commit();
	    } catch (Exception e) {
	        t.rollback();
	        throw e;
	    }
	    Iterator<DailyReport> iterator = backend.iterator();
		while (iterator.hasNext()) {
			DailyReport dbData = iterator.next();
			boolean available = false;
			for (DailyReport formData : frontend) {
				if (formData.getId() != null && formData.getId().equals(dbData.getId())) {
					available = true;
					break;
				}
			}
			if (!available) {
				iterator.remove();
				t.begin();
				session.delete(dbData);
				t.commit();
			}
		}
		
	}

		/*
		 * // Delete child records that are not present in the updated journey
		 * List<DailyReport> existingReports = j.getReport(); for (DailyReport
		 * existingReport : existingReports) { if
		 * (!journey.getReport().contains(existingReport)) { t.begin();
		 * session.delete(existingReport); t.commit();
		 * 
		 * } }
		 */



	public void delete(String id) {
		CreateJourney journey = session.get(CreateJourney.class, Integer.parseInt(id));
		if(journey!=null) {
		Transaction t = session.beginTransaction();
			session.delete(journey);
			t.commit();
		}
		}
	

	/*
	 * @Transactional public void delete(String id) { Transaction t =
	 * session.beginTransaction(); try { CreateJourney journey =
	 * session.get(CreateJourney.class, Integer.parseInt(id)); List<DailyReport>
	 * reports = journey.getReport();
	 * 
	 * for (DailyReport dreports : reports) { DailyReport temp =
	 * session.get(DailyReport.class, dreports.getId()); session.delete(temp); }
	 * 
	 * if (journey.getReport().size() == 0) { session.delete(journey); }
	 * 
	 * t.commit(); } catch (Exception e) { if (t != null) { t.rollback(); }
	 * e.printStackTrace(); } }
	 */

	public List<CreateJourney> searchByBookingIdAgencyAndPhone(Integer bookingid, String agency, Long phone) {
		String query = "select j from CreateJourney j where j.bookingid=?1 and j.agency LIKE ?2 and j.phone=?3";
		String agencyPattern = "%" + agency + "%";
		Query<CreateJourney> q = session.createQuery(query);
		q.setParameter(1, bookingid);
		q.setParameter(2, agencyPattern);
		q.setParameter(3, phone);
		List<CreateJourney> result = q.getResultList();
		return result;

	}

	public List<CreateJourney> searchJourneys(String bookingid, String agency, String phone) {
		try {
			if (bookingid != null && !bookingid.isEmpty()) {
				if ((agency != null && !agency.isEmpty()) && (phone != null && !phone.isEmpty())) {
					return searchByBookingIdAgencyAndPhone(Integer.valueOf(bookingid), agency, Long.valueOf(phone));
				} else if (agency != null && !agency.isEmpty()) {
					return searchByBookingIdAndAgency(Integer.valueOf(bookingid), agency);
				} else if (phone != null && !phone.isEmpty()) {
					return searchByBookingIdAndPhone(Integer.valueOf(bookingid), Long.valueOf(phone));
				} else {
					return findByBookingId(Integer.valueOf(bookingid));
				}
			} else if ((agency != null && !agency.isEmpty()) && (phone != null && !phone.isEmpty())) {
				return searchByAgencyAndPhone(agency, Long.valueOf(phone));
			} else if (agency != null && !agency.isEmpty()) {
				return findByAgency(agency);
			} else if (phone != null && !phone.isEmpty()) {
				return findByPhone(Long.valueOf(phone));
			} else {
				return null;
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
			return null;
		}
	}

	public List<CreateJourney> searchByAgencyAndPhone(String agency, Long phone) {
		CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
		CriteriaQuery<CreateJourney> criteriaQuery = criteriaBuilder.createQuery(CreateJourney.class);
		Root<CreateJourney> root = criteriaQuery.from(CreateJourney.class);

		criteriaQuery.select(root).where(criteriaBuilder.equal(root.get("agency"), agency),
				criteriaBuilder.equal(root.get("phone"), phone));

		return session.createQuery(criteriaQuery).getResultList();
	}

	public List<CreateJourney> findByPhone(Long phone) {
		CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
		CriteriaQuery<CreateJourney> criteriaQuery = criteriaBuilder.createQuery(CreateJourney.class);
		Root<CreateJourney> root = criteriaQuery.from(CreateJourney.class);
		criteriaQuery.select(root).where(criteriaBuilder.equal(root.get("phone"), phone));
		return session.createQuery(criteriaQuery).getResultList();
	}

	public List<CreateJourney> findByBookingId(Integer id) {
		Query<CreateJourney> query = session.createQuery("select c from CreateJourney c where c.bookingid=?1");
		query.setParameter(1, id);
		return query.getResultList();
	}

	public List<CreateJourney> searchByBookingIdAndAgency(Integer bookingid, String agency) {
		Query<CreateJourney> query = session
				.createQuery("select j from CreateJourney j where j.bookingid=?1 and j.agency=?2");
		query.setParameter(1, bookingid);
		query.setParameter(2, agency);
		return query.getResultList();
	}

	public List<CreateJourney> searchByBookingIdAndPhone(Integer bookingid, Long phone) {
		Query<CreateJourney> query = session
				.createQuery("select j from CreateJourney j where j.bookingid=?1 and j.phone=?2");
		query.setParameter(1, bookingid);
		query.setParameter(2, phone);
		return query.getResultList();
	}

	public List<CreateJourney> findByAgency(String agency) {
		CriteriaBuilder builder = session.getCriteriaBuilder();
		CriteriaQuery<CreateJourney> criteriaQuery = builder.createQuery(CreateJourney.class);
		Root<CreateJourney> root = criteriaQuery.from(CreateJourney.class);
		Predicate agencyPredicate = builder.like(root.get("agency").as(String.class), "%" + agency + "%");
		criteriaQuery.select(root).where(agencyPredicate);

		return session.createQuery(criteriaQuery).getResultList();
	}
	
	public List<String> getCompletedDays(String currentDate) {
        
        List<String> completedDays = session.createQuery(
                "SELECT d.date FROM DailyReport d WHERE d.date <= :currentDate", String.class)
                .setParameter("currentDate", currentDate)
                .getResultList();
        
        return completedDays;
    }
	
	public List<DailyReport> getAllReports(CreateJourney journey){
		String query = "select r from DailyReport r where r.journey.id = ?1";
		Query<DailyReport> q = session.createQuery(query);
		q.setParameter(1, journey.getId());
		return q.getResultList();
	}

}
