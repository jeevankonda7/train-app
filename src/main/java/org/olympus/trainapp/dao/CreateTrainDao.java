package org.olympus.trainapp.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.olympus.trainapp.dto.CreateTrain;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CreateTrainDao {
	
	@Autowired
	private Session session;
	
	public void save(CreateTrain train) {
		Transaction t = session.beginTransaction();
		session.saveOrUpdate(train);
		t.commit();
	}

	public List<CreateTrain> getAllTrainNames() {
		String query = "select t from CreateTrain t";
		Query<CreateTrain> t = session.createQuery(query);
		List<CreateTrain> list = t.getResultList();
		if(list.size()>0) {
			return list;
		}
		return null;
	}
	
	public CreateTrain findById(Integer id) {
		CreateTrain train = session.get(CreateTrain.class, id);
		if(train!=null) {
			return train;
		}
		return null;
	}
	public boolean isTrainNumberExists(Integer trainNumber) {
		String query = "select t from CreateTrain t where t.trainno=?1";
		Query<CreateTrain> train = session.createQuery(query);
		train.setParameter(1, trainNumber);
		CreateTrain ct = train.getSingleResult();
		if(ct!=null)
			return true;
		else
			return false;
	}

}
