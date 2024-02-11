<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Page</title>
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

.container {
    width: 80%;
    margin: 20px auto;
}

h2 {
    color: #333;
}

.search-container {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.search-fields {
    display: flex;
    flex-wrap: wrap;
    margin-bottom: 20px;
}

.search-field {
    margin-right: 10px;
    margin-bottom: 10px;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.button-row {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 20px;
}

.button-row button {
    margin-left: 10px;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.button-row button[type="submit"] {
    background-color: #4caf50;
    color: #fff;
}

.button-row button[type="reset"] {
    background-color: #f44336;
    color: #fff;
}

.button-row button:hover {
    opacity: 0.8;
}

.createButtons {
    display: flex;
    margin-top: 20px;
}

.createButtons button {
    margin-right: 10px;
}

.createButtons button a {
    display: inline-block;
    padding: 10px 20px;
    text-decoration: none;
    color: #fff;
    border-radius: 4px;
}

.createButtons button a.create-train {
    background-color: #337ab7;
}

.createButtons button a.create-journey {
    background-color: #5bc0de;
}

.createButtons button a:hover {
    opacity: 0.8;
}

    .tablecontainer {
        margin-top: 20px;
    }

    .tablecontainer table {
        width: 100%;
        border-collapse: collapse;
    }

    .tablecontainer th, .tablecontainer td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: left;
    }

    .tablecontainer th {
        background-color: #f2f2f2;
    }

    .tablecontainer tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    .tablecontainer tr:hover {
        background-color: #ddd;
    }

    .tablecontainer td.actions a {
        display: inline-block;
        padding: 6px 12px;
        text-decoration: none;
        border-radius: 4px;
        color: #fff;
    }

    .tablecontainer td.actions a.edit-btn {
        background-color: #337ab7;
    }

    .tablecontainer td.actions a.delete-btn {
        background-color: #d9534f;
    }

    .tablecontainer td.actions a:hover {
        opacity: 0.8;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>Search Form</h2>
        <div class="search-container">
            <form  id="searchForm" action="searching" method="get">
                <!-- Adjust the action accordingly -->
                Booking ID: <input type="text" name="bookingid" class="search-field">
                <!-- Train No: <input type="text" name="trainNo" class="search-field"> -->
                Agency: <input type="text" name="agency" class="search-field">
                Phone: <input type="text" name="phone" class="search-field">
                <!-- Date: <input type="date" name="date" class="search-field"> -->
                <div class="button-group">
                    <button type="submit">Search</button> 
                    
                    <button type="submit" formaction="reset">Reset</button>
                </div>
            </form>
            <div class="createButtons">
                <button>
                    <a href="load?page=train" class="create-train">Create Train</a>
                </button>
                <button>
                    <a href="open?page=newcreatejourney" class="create-journey">Create Journey</a>
                </button>
            </div>
        </div>
    </div>
    <br />
    <div class="tablecontainer">
        <h2>Daily Reports</h2>
        <table>
            <tr>
                <th>Booking ID</th>
                <th>Agency</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
            <c:choose>
                <c:when test="${not empty journeyLists}">
                    <c:forEach items="${journeyLists}" var="journey">
                        <tr>
                            <td>${journey.bookingid}</td>
                            <td>${journey.agency}</td>
                            <td>${journey.phone}</td>
                            <td class="actions">
                                <a href="openUpdate?id=${journey.getId()}" class="btn edit-btn">Edit</a> 
                                <a href="delete?id=${journey.id}" class="btn delete-btn">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4">No search results found.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#searchForm').submit(function(event) {
                event.preventDefault(); // Prevent default form submission

                // Get form data
                var formData = $(this).serialize();

                // Send AJAX request to submit the form data
                $.ajax({
                    type: 'GET',
                    url: '/searching', // Endpoint to submit the form data
                    data: formData,
                    success: function(response) {
                    	if(response==null){
                    		 alert('An error occurred while processing the search request.'); 
                    	}
                    	else{
                        // Handle the response as needed, such as displaying search results
                        console.log(response);
                        // Example: Update a div with search results
                        $('#searchResults').html(response);
                    }
                    /* },
                    error: function(xhr, status, error) {
                        // Handle the error as needed, such as displaying an error message
                        console.error(xhr.responseText);
                       /*  alert('An error occurred while processing the search request.'); */
                    } */
                });
            });
        });
    </script>
</body>
</html>
