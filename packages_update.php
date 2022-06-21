<head>
<title>Упаковки</title>
</head>
<a href="packages.php" >Назад</a>
<br>
<?php
pg_connect("host=localhost dbname=confectionery user=postgres password=nwraa2002jj");

$current_package = array('type' => '', 'price' => '');
if(isset($_POST['package_id'])){
	$current_package = pg_fetch_assoc(pg_query('select * from packages where package_id = '.$_POST['package_id']));
}

echo '
	
	<form action="packages.php" method="POST">
		<input type="text" name="package_type" value="'.$current_package['type'].'">Тип<br>
		<input type="text" name="price" value="'.$current_package['price'].'">Цена<br>';
		if(isset($_POST['package_id'])){
			echo '<button name="update_package_id" value="'.$_POST['package_id'].'">Сохранить</button>';
		} else {
			echo '<button name="create_package_id" value="0">Сохранить</button>';
		}
echo '
	</form>
	'
?>