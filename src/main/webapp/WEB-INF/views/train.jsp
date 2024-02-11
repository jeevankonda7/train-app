<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Schedule Train</title>
<style>
input {
            border: 1px solid rgb(116, 116, 116);
            height: 30px;
            width: 300px;
            border-radius: 5px;
        }
        .mainContainer {
            padding: 10px;
            background-color: rgba(188, 188, 222, 0.632);
            border-radius: 3px;
        }
        label {
            font-weight: bold;
        }

        input {
            margin-left: 30px;
        }
        .labelMain {
            width: 100%;
            display: flex;
        }

        .rightSideLables {
            margin-left: 300px;

        }
        .buttons button {
            width: 100px;
            height: 40px;
            background-color: #8c9192;
            border-radius: 5px;
            border: none;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
        }
        .buttons button:hover{
            background-color: rgba(38, 55, 132, 0.774);
        }
        .buttons{
         float: right;
         background-color: #fff;
        }
        .createTarinHead{
            height: 25px;
            background-color:#aab7b9;
            border-radius: 3px;
        }

        .SourceInput{
            margin-left: 42px;
        }
        a{
        color:#fff;
        text-decoration: none;
        }
        label.error {
        color: red; 
        font-size: 12px; 
    }
</style>
</head>
<body>
	<div>
		<div class="createTarinHead">
			<h3>Create Train</h3>
		</div>
		<div class="mainContainer">

			<form:form id="submitForm" action="savetrain" modelAttribute="t">
			<form:input path="id" type="number" value="${t.getId()}" cssStyle="display: none;" />
		<br />
				<div class="labelMain">
					<div class="leftSideLables">

						<label for="">Train No</label> 
						<form:input type="number" path="trainno" id="trainNoInput"/>
						<div id="trainNoError" class="error-message"></div>
						<br>
						<br>
						 <label for=""> Source </label> 
						 <form:input class="SourceInput" type="text" path="source"/><br>
						<br>

					</div>
					<div class="rightSideLables">
						<label for="">Train Name </label> 
						<form:input type="text" path="trainname"/><br>
						<br>
						<br> 
						<label for="">Destination </label>
						 <form:input type="text" path="destination"/><br>
						<br>
					</div>
				</div>
				<br>
			</form:form>
		</div>
		<br>
		<div class="buttons">
			<button type="submit" id="submitBtn">submit</button>
			<button><a href="cancel">cancel</a></button>
		</div>
	</div>
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
                    $('#trainNoError').text('');
                }
            });
        });
    </script>
</body>
</html>