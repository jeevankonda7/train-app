<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

form {
    width: 50%;
    margin: 20px auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

form label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

form input[type="text"],
form input[type="number"] {
    width: calc(50% - 5px);
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-bottom: 10px;
}

form input[type="submit"] {
    padding: 10px 20px;
    background-color: #4caf50;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

form input[type="submit"]:hover {
    background-color: #45a049;
}


</style>
</head>
<body>
	 <form:form id = "submitForm" modelAttribute="t" method="post" action="savetrain">


		<form:input path="id" type="number" value="${t.getId()}" cssStyle="display: none;" />
		<br />
		
		<label for="Train No">Train No:</label>
		<form:input path="trainno" id="trainNoInput" />
		<div id="trainNoError" class="error-message"></div>

		<br />
		<label for="name">Name</label>
		<form:input path="trainname"/>

		<br />

		<label for="source">Source:</label>
		<form:input path="source"/>

		<br />

		<label for="destination">Destination:</label>
		<form:input path="destination"/>

		<br />

		<!-- <input type="submit" value="submit" /> -->
		<input type="button" id="submitBtn" value="submit" />
	</form:form> 
	 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Include jQuery Validation plugin -->
    <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#submitForm').validate({
                rules: {
                    trainno: {
                        required: true
                    },
                    trainname: {
                        required: true
                    },
                    source: {
                        required: true
                    },
                    destination: {
                        required: true
                    }
                },
                messages: {
                    trainno: {
                        required: "Train No is required"
                    },
                    trainname: {
                        required: "Name is required"
                    },
                    source: {
                        required: "Source is required"
                    },
                    destination: {
                        required: "Destination is required"
                    }
                },
                errorPlacement: function (error, element) {
                    error.insertAfter(element); // Display error message below each input field
                }
            });

            $('#submitBtn').click(function () {
                if ($('#submitForm').valid()) {
                    // If form is valid, you can submit the form or perform further actions
                    $('#submitForm').submit();
                }
            });
        });
        $('#trainNoInput').blur(function () {
            var trainNumber = $(this).val();
            $.ajax({
                type: 'POST',
                url: 'checkTrainNumberAvailability',
                data: { trainNumber: trainNumber },
                success: function (response) {
                    $('#trainNoError').text(response);
                },
                error: function () {
                    $('#trainNoError').text('Error occurred while checking train number availability');
                }
            });
        });
    </script>
</body>
</html>