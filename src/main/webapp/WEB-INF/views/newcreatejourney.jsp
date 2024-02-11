<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<title>Journey page</title>
<style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
        }

        fieldset {
            border: 1px solid #ccc;
            padding: 20px;
            margin-bottom: 20px;
        }

        #box {
            background-color: #fff;
            padding: 20px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        .travel-row{
            background-color: #fff;
        }

        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        button:hover {
            background-color: #0056b3;
        }

        input[type="submit"] {
            padding: 10px 20px;
            background-color: #28a745;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        .removerow{
        background-color: red;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }
     </style>
</head>
<body>
	<form:form id="form" action="saverecords" modelAttribute="journey">
		<fieldset>

			<div id="box">
				<form:input hidden="true" path="id" id="journeyid" />
				<label>Booking ID :</label>
				<form:input path="bookingid" />
				<label>Agency :</label>
				<form:input required="true" path="agency" />
				<label>Phone:</label>
				<%-- <form:input type="number" path="phone" /> --%>
				<form:input type="text" path="phone" id="phone" onblur="validatePhoneNumber()" />
                <div id="phone-error" class="error-message"></div>
            </div>
			</div>

			<table border="1" id="traintable">
				<tr>
					<th>Train Name</th>
					<th>From</th>
					<th>To</th>
					<th>On</th>

				</tr>
				<tbody id="Tbody">
					<c:forEach var="index" begin="0"
						end="${empty journey.report ? 0 :journey.report.size()-1}">
						<tr class="travel-row" id="addRow">
							<td style="display: none"><form:input hidden="true"
									path="report[${index}].id" /></td>
							<td><form:select path="report[${index}].train.id">
									<c:forEach var="t" items="${trainlist}">
										<form:option value="${t.id}">${t.trainname}</form:option>
									</c:forEach>
								</form:select></td>
							<td><form:input path="report[${index}].from_loc" /></td>
							<td><form:input path="report[${index}].to_loc" /></td>
							<td><form:input path="report[${index}].date"
									type="date" /></td>
							<td><button class="removerow" type="button">Delete</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<button type="button" onClick="BtnAdd()">Add</button>
			
				<input type="submit" value="submit"></input>
		</fieldset>
	</form:form>

	<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
	<script>
	var index = ${empty journey.report ? 0 : journey.report.size()-1};

	$(document).ready(function() {
	    $(document).on('click', '.removerow', function() {
	        $(this).closest('tr').find('input, select').val('');
	        $(this).closest('tr').remove();
	        updateIndices();
	    });
	});

	function BtnAdd() {
	    index++;
	    var v = $('#addRow').clone();
	    $('#Tbody').find('tr:last').after(v);

	    $(v).find('input, select').each(function() {
	        $(this).val('').attr('name', $(this).attr('name').replace(/\[\d+\]/, '[' + index + ']'));
	    });
	    
	}
	 function validatePhoneNumber() {
         var phoneNumber = $('#phone').val();
         var regex = /^\d{10}$/;
         if (!regex.test(phoneNumber)) {
        	 alert("Phone number should be 10 digits");
        	 $('#phone').val('');
         } 
     }

</script>
</body>