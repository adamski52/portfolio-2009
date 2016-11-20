<?php
	if(isset($_POST["email"]) && $_POST["email"] != "" && isset($_POST['message']) && $_POST['message'] != "") {
    	mail("me@jonathanadamski.com", "Portfolio message", $_POST["email"] . " says: " . $_POST['message']);
    }
?>